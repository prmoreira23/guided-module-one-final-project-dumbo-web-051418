require 'highline/import'

class CommandLineInterface
  @@options = {no_user: Hash.new(:error), user: Hash.new(:error)}
  @@options[:no_user]["0"] = :finish
  @@options[:no_user]["1"] = :login
  @@options[:no_user]["2"] = :create_account
  @@options[:no_user]["3"] = :about_us
  @@options[:no_user]["4"] = :coins_quotes

  @@options[:user]["0"] = :logout
  @@options[:user]["1"] = :see_balances
  @@options[:user]["2"] = :deposit_coin
  @@options[:user]["3"] = :withdraw

  def initialize
    @user = nil
  end

  def get_option_hash
    @user ? @@options[:user] : @@options[:no_user]
  end

  def welcome_message
    puts "+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=++=+=+=+=+=++=+=+=+=+=+=+=+"
    puts "|\t\t\tWelcome to KoinBase!\t\t\t|" unless @user
    puts "|\tWelcome Back to KoinBase, #{@user.first_name}!" if @user
    puts "+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=++=+=+=+=+=++=+=+=+=+=+=+=+"
    puts ""
  end

  def print_options
    options = "\t\t1 - login\n\t\t2 - create new account\n\t\t3 - about us\n\t\t4 - major coins quotes\n\n\t\t0 - Exit" unless @user
    options = "\t\t1 - See Balances\n\t\t2 - Deposit Coin\n\t\t3 - Withdraw\n\t\t0 - Logout" if @user
    puts options
  end

  def coins_quotes
    quotes = CryptoApi.get_quotes_to_dollar
    Coin.all.each {|coin|
        puts "Name: #{coin.name}. USD #{quotes[coin.id - 1]}"
    }
    print "\nPress [ENTER]"
    gets.chomp
  end

  def about_us
    puts "\nWe are the major crypto currency exchange in the United States. \nWe work with all major coins."
    print "\nPress [ENTER]"
    gets.chomp
  end

  def create_account
      print "\nType your desired username: "
      username = gets.chomp #future if statement to validate username
      if Account.find_by(username: username)
        puts "Username is already taken"
      else
        print "Type your desired password: "
        password = gets.chomp
        password = Digest::MD5.hexdigest(password)
        print "Type your first name: "
        first_name = gets.chomp
        print "Type your last name: "
        last_name = gets.chomp

        Account.create(username: username, password: password, first_name: first_name, last_name: last_name)
        puts "\n#{first_name}, your account has been registered.\n"
        print "\nPress [ENTER]"
        gets.chomp
      end
    end

  def run
    loop do
      system("clear")
      welcome_message
      print_options
      print "\nType your option: "
      option = gets.chomp
      self.send(self.get_option_hash[option])
    end
  end

  def login
    print "username: "
    username = gets.chomp
    password = ask("password:  ") { |q| q.echo = "*" }
    account = Account.find_by(username: username)
    @user = account.authenticate?(password) if account
    puts @user ? "\nSuccessfully logged in as #{@user.first_name}." : "\nUsername/Password Invalid"
    print "\nPress [ENTER]"
    gets.chomp
  end



  def logout
    puts "\nThank you for using KoinBase, #{@user.first_name}!" if @user
    print "\nPress [ENTER]"
    gets.chomp
    @user = nil
  end

  def see_balances
    puts ""
    @user.balances.each { |balance|
      puts "#{balance.coin.name}: #{balance.amount}"
    }.empty? and begin
      puts "No balances to be displayed."
    end

    print "\nPress [ENTER]"
    gets.chomp
  end

  def deposit_coin
    puts "DEPOSIT"
    Coin.all.each { |coin|
      puts "#{coin.id} - #{coin.name}"
    }
    puts "Select coin: "
    id = gets.chomp

    return nil if id.to_i == 0

    puts "Amount: "
    amount = gets.chomp

    return nil if amount.to_f == 0

    coin = Coin.find_by(id: id)
    balance = coin ? @user.find_balance_by_coin(coin) : nil
    @user.deposit(balance, amount.to_f) if balance
  end

  def balances
      @user.balances.map { |balance|
        puts "\n#{balance.coin.id-1} - #{balance.coin.name} : #{balance.amount}\n\n"
      }
    end

  def withdraw
    puts "DEPOSIT"
    Coin.all.each { |coin|
      puts "#{coin.id} - #{coin.name}"
    }
    puts "Select coin: "
    id = gets.chomp

    return nil if id.to_i == 0

    puts "Amount: "
    amount = gets.chomp

    return nil if amount.to_f == 0

    coin = Coin.find_by(id: id)
    balance = coin ? @user.find_balance_by_coin(coin) : nil
    return nil unless balance

      begin
        @user.withdraw(balance, amount.to_f)
        puts "\nYou are withdrawing #{amount} from your #{balance.coin.name} wallet."
      rescue NotEnoughFunds
        puts "\nYou do not have enough in your balance to withdraw that amount."
      rescue StandardError
        puts "\nYou cannot withdraw a negative amount."
      end

      puts "\nThank you for using KoinBase!" unless @user
      print "\nPress [ENTER]"
      gets.chomp
    end

  def finish
    puts "\nThank you for using KoinBase!" unless @user
    print "\nPress [ENTER]"
    gets.chomp
    exit
  end

  def error
    puts "option not available..."
    print "\nPress [ENTER]"
    gets.chomp
  end
end
