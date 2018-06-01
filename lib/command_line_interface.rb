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
      puts @user ? "|\t\t|\t1 - See balances\t|\n\t\t|\t2 - Withdraw\t\t|\n\t\t|\t3 - Transfer\t\t|\n\t\t|\t4 - Prices\t\t|\n\t\t|\t0 - Logout\t\t|\n\t\t|_______________________________|" :
      "\t\t|\t1 - Login\t\t|\n\t\t|\t2 - Register\t\t|\n\t\t|\t3 - Prices\t\t|\n\t\t|\t4 - Help\t\t|\n\t\t|\t0 - Exit\t\t|\n\t\t|_______________________________|"
    end

    def run
      welcome_message
      loop do
        system("clear")
        puts "\n"
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
      print "\n\t\tPress [ENTER] to continue"
      gets.chomp
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
      print "\n\t\tPress [ENTER] to continue"
      gets.chomp
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
      print "\n\t\tPress [ENTER] to continue"
      gets.chomp
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
      print "\n\t\tPress [ENTER] to continue"
      gets.chomp

    end

    def balances
      @user.balances.map { |balance|
        puts "\n\t\t#{balance.coin.id-1} - #{balance.coin.name} : #{balance.amount}\n\n"
      }
      print "\n\t\tPress [ENTER] to continue"
      gets.chomp
    end

    def prices
      url = 'https://api.coinmarketcap.com/v2/ticker/?start=1&limit=5&sort=id'
      response = RestClient.get(url)
      data = JSON.parse(response)

      coin_hash = data["data"]
      coin_hash.each do |coin_id, coin|
        puts "\n\t\t#{coin['symbol']} : #{coin['quotes']['USD']['price']}"
      end
      print "\n\t\tPress [ENTER] to continue"
      gets.chomp
    end

    def help
      puts "\n\t\tEnter '1' to log in to your account"
      puts "\t\tEnter '2' to register a new account"
      puts "\t\tEnter '3' to display current prices of coins"
      # puts ""
      print "\n\t\tPress [ENTER] to continue"
      gets.chomp
    end

    def error
      puts "\nInvalid entry...\nEnter '4' for help"
      print "\n\t\tPress [ENTER] to continue"
      gets.chomp
    end

    def logout
      @user = nil
      @option = @@options[:no_user]
      puts "\nYou have successfully logged out."
      puts ""
      print "\n\t\tPress [ENTER] to continue"
      gets.chomp
    end

    def admin
      @user = Account.find_by(username: "pabloo")
      @option = @@options[:user] if @user
      print "\n\t\tPress [ENTER] to continue"
      gets.chomp
    end

    def exit_cli
      puts "\nBye, see you soon!"
      puts ""
      exit
    end
end
