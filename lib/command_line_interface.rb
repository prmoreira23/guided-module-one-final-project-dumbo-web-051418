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
    options = "\t\t1 - See Balances\n\t\t2 - Deposit Coin\n\t\t0 - Logout" if @user
    puts options
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

    system("clear")
  end

  def create_account
    puts "Creating new account..."
    gets.chomp
  end

  def about_us
    puts "\nWe are the major crypto currency exchange in the United States. \nWe work with all major coins."
    print "\nPress [ENTER]."
    gets.chomp
  end

  def coins_quotes
    CryptoApi.coins[1..5].each {|coin|
      begin
        puts "Name: #{coin.name}. U$ #{CryptoApi.get_quote_dollar(coin)}"
        sleep 1 # API blocks us if we do several request so fast
      rescue RestClient::TooManyRequests => e
        puts 'Too many requests to free API.'
        break
      end
    }
  end

  def logout
    puts "\nThank you for using KoinBase, #{@user.first_name}!" if @user
    print "\nPress [ENTER]."
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

    print "\nPress [ENTER]."
    gets.chomp
  end

  def deposit_coin
    puts "DEPOSIT"
    Coin.all.each { |coin|
      puts coin.name
    }
    puts "Select coin: "
    id = gets.chomp

    puts "Amount: "
    amount = gets.chomp

    coin = Coin.find_by(id: id)
    balance = coin ? @user.find_balance_by_coin(coin) : nil
    @user.deposit(balance, amount.to_f) if balance
  end

  def finish
    puts "\nThank you for using KoinBase!" unless @user
    print "\nPress [ENTER]."
    gets.chomp
    exit
  end

  def error
    puts "option not available..."
    gets.chomp
  end
end
