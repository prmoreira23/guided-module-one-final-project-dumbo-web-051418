class CommandLineInterface
  @@options = Hash.new(:error)
    @@options["1"] = :login
    @@options["2"] = :register
    @@options["3"] = :guest_login
    @@options["4"] = :help
    @@options["5"] = :exit_cli

    def welcome_message
      puts "\nWelcome to the Coinbase CLI."
    end

    def print_options
      puts "1 - Login"
      puts "2 - Register"
      puts "3 - Login as guest"
      puts "4 - Help"
      puts "5 - Exit"
    end

    def run
      welcome_message
      loop do
        puts "\nPlease enter an option:"
        print_options
        option = gets.chomp
        self.send(@@options[option])
      end
    end

    def login
      puts "\ncoming soon.."
    end

    def register
      puts "\nPlease enter your desired username"
      username= gets.chomp #future if statement to validate username
      puts "\n#{username} is valid\n#{username}, your account is registered\n"
      Account.create(username: username)
    end

    def guest_login
      puts "\ncoming soon.."
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

    def exit_cli
      puts "\nBye, see you soon!"
      puts ""
      exit
    end
end
