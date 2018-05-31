require 'digest'
require 'highline/import'

class CommandLineInterface
  @@options = {user: Hash.new(:error), no_user: Hash.new(:error)}
    @@options[:no_user]["0"] = :exit_cli
    @@options[:no_user]["1"] = :login
    @@options[:no_user]["2"] = :register
    @@options[:no_user]["3"] = :prices
    @@options[:no_user]["4"] = :help

    @@options[:user]["0"] = :logout
    @@options[:user]["1"] = :balances
    @@options[:user]["2"] = :withdraw
    @@options[:user]["3"] = :prices
    @@options[:user]["5"] = :help


    def initialize
      @user = nil
      @option = @@options[:no_user]
    end

    def welcome_message
      puts "\nWelcome to the Coinbase CLI."
    end

    def print_options
      puts @user ? "\n1 - See balances\n2 - Withdraw\n3 - Prices\n0 - Logout" : "1 - Login\n2 - Register\n3 - Prices\n4 - Help\n0 - Exit"
    end

    def run
      welcome_message
      loop do
        puts "\nPlease enter an option:"
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
      puts @user ? "\nSuccessful login as #{username}" : "\nInvalid username or password."
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
        puts "\n#{username} is valid\n#{username}, your account is registered\n"
        Account.create(username: username, password: password, first_name: first_name, last_name: last_name)
      end
    end

    def withdraw
      balances
      puts "Which balance would you like to withdraw from?"
      input = gets.chomp
      puts "How much would you like to withdraw?"
      amount = gets.chomp
      balance = @user.balances[input.to_i]

      begin
        balance.withdraw(amount.to_f)
        puts "You are withdrawing #{amount} from your #{balance.coin.name} wallet."
      rescue
        puts "You do not have enough in your balance to withdraw that amount."
      end

    end

    def balances
      @user.balances.map { |balance|
        puts "\n#{balance.coin.name} : #{balance.amount}\n\n"
      }
    end

    def prices
      url = 'https://api.coinmarketcap.com/v2/ticker/?start=1&limit=5&sort=id'
      response = RestClient.get(url)
      data = JSON.parse(response)

      coin_hash = data["data"]
      coin_hash.each do |coin_id, coin|
        puts "#{coin['symbol']} : #{coin['quotes']['USD']['price']}"
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
    end

    def exit_cli
      puts "\nBye, see you soon!"
      puts ""
      exit
    end
end
