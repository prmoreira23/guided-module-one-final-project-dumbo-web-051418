require 'digest'
require 'highline/import'

class CommandLineInterface
  @@options = {user: Hash.new(:error), no_user: Hash.new(:error)}
    @@options[:no_user]["0"] = :exit_cli
    @@options[:no_user]["1"] = :login
    @@options[:no_user]["2"] = :register
    @@options[:no_user]["3"] = :prices
    @@options[:no_user]["4"] = :help
    @@options[:no_user]["42"] = :admin

    @@options[:user]["0"] = :logout
    @@options[:user]["1"] = :balances
    @@options[:user]["2"] = :withdraw
    @@options[:user]["3"] = :transfer
    @@options[:user]["4"] = :prices
    @@options[:user]["5"] = :help


    def initialize
      @user = nil
      @option = @@options[:no_user]
    end

    def welcome_message
      puts "+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=++=+=+=+=+=++=+=+=+=+=+=+=+"
      puts "|\t\t\tWelcome to KoinBase!\t\t\t|" unless @user
      puts "|\tWelcome Back to KoinBase, #{@user.first_name}!" if @user
      puts "================================================================="
      puts "|\t The place where experts manage their cryptocurrency \t|"
      puts "|                                                               |"
      puts "|\t\t Created by Pablo, Sammy, & Anthony \t\t|"
      puts "+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=++=+=+=+=+=++=+=+=+=+=+=+=+"

    end


    def print_options
      puts @user ? "|\t\t|\t1 - See balances\n\t2 - Withdraw\n\t3 - Transfer\n\t4 - Prices\n\t0 - Logout\n |" :
      "\t\t|\t1 - Login\t\t|\n\t\t|\t2 - Register\t\t|\n\t\t|\t3 - Prices\t\t|\n\t\t|\t4 - Help\t\t|\n\t\t|\t0 - Exit\t\t|\n\t\t|_______________________________|"
    end

    def run
      welcome_message
      loop do
        puts "\t\t*********************************\t"
        puts "\t\t|    Please enter an option:\t|\t"
        puts "\t\t*********************************\t\t"
        print_options
        option = gets.chomp
        self.send(@option[option])
      end
    end

    def login
      puts "\nPlease enter your username"
      username = gets.chomp
      password = ask("Please enter your password") {|p| p.echo = "*"}
      password = Digest::MD5.hexdigest(password)
      user = Account.find_by(username: username)
      @user = user.authenticate(password) if user
      puts @user ? "\nSuccessful login as #{username}!" : "\nInvalid username or password."
      @option = @@options[:user] if @user
    end

    def register
      puts "\nPlease enter your desired username"
      username = gets.chomp #future if statement to validate username
      if Account.find_by(username: username)
        puts "\nUsername is already taken"
      else
        puts "\nPlease enter your desired password"
        password = gets.chomp
        password = Digest::MD5.hexdigest(password)
        puts "\nPlease enter your first name"
        first_name = gets.chomp
        puts "\nPlease enter your last name"
        last_name = gets.chomp
        puts "\n#{username} is valid\n#{username}, your account is registered\n\n\n"
        Account.create(username: username, password: password, first_name: first_name, last_name: last_name)
      end
    end

    def withdraw
      balances
      puts "Which balance would you like to withdraw from?\n"
      input = gets.chomp
      puts "How much would you like to withdraw?"
      amount = gets.chomp
      balance = @user.balances[input.to_i]

      begin
        @user.withdraw(balance, amount.to_f)
        puts "\nYou are withdrawing #{amount} from your #{balance.coin.name} wallet."
      rescue
        puts "\nYou do not have enough in your balance to withdraw that amount."
      end

    end

    def transfer
      balances
      puts "Which balance would you like to transfer from?\n"
      input = gets.chomp
      puts "How much would you like to transfer?"
      amount = gets.chomp
      balance = @user.balances[input.to_i]
      puts "Which account number(account id) would you like to transfer to?"
      account_number = gets.chomp
      acc = Account.find_by(id: account_number)
      begin
        if acc
          @user.withdraw(balance, amount.to_f)
          acc.deposit(acc.balances[input.to_i], amount.to_f)
          puts "\nYou are transferring #{amount} from your #{balance.coin.name} wallet."
        end
      rescue
        puts "\nYou do not have enough in your balance to transfer that amount."
      end

    end

    def balances
      @user.balances.map { |balance|
        puts "\n#{balance.coin.id-1} - #{balance.coin.name} : #{balance.amount}\n\n"
      }
    end

    def prices
      url = 'https://api.coinmarketcap.com/v2/ticker/?start=1&limit=5&sort=id'
      response = RestClient.get(url)
      data = JSON.parse(response)

      coin_hash = data["data"]
      coin_hash.each do |coin_id, coin|
        puts "\n#{coin['symbol']} : #{coin['quotes']['USD']['price']}"
      end
    end

    def help
      puts "\nEnter '1' to login to your account"
      puts "Enter '2' to register a new account"
      puts "Enter '3' to login as a guest and trade with paper money"
      # puts ""
    end

    def error
      puts "\nInvalid entry...\nEnter '4' for help"
    end

    def logout
      @user = nil
      @option = @@options[:no_user]
      puts "\nYou have successfully logged out."
      puts ""
    end

    def admin
      @user = Account.find_by(username: "pabloo")
      @option = @@options[:user] if @user
    end

    def exit_cli
      puts "\nBye, see you soon!"
      puts ""
      exit
    end
end
