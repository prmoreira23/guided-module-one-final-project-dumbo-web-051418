class Account < ActiveRecord::Base
  has_many :balances
  has_many :coins, through: :balances
  validates_uniqueness_of :username, unique: true

  # Returns an instance of Account if authentication is successful
  # returns nil otherwise.
  def authenticate?(password)
    self.password == password ? self : nil
  end

  # Withdraw a certain amount from a balance
  # Can raise a NotEnoughFunds exception or returns the new balance if successful
  def withdraw(balance, amount)
    balance.withdraw(ammount)
  end

  def find_balance_by_coin(coin)
    if coin
      balances.find { |balance|
        return balance if balance.coin == coin
      }.nil? and begin
        balance = Balance.create(account: self, coin: coin, amount: 0)
        self.balances << balance
        return balance
      end
    end
  end


  def deposit(balance, amount)
    balance.deposit(amount)
  end
end
