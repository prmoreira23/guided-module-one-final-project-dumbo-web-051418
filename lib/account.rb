class Account < ActiveRecord::Base
  has_many :balances
  has_many :coins, through: :balances
  validates_uniqueness_of :username, unique: true

  after_create do
    Coin.all.each { |coin|
      self.balances << Balance.create(coin: coin, account: self, amount: 0)
    }
  end

  # Returns an instance of Account if authentication is successful
  # returns nil otherwise.
  def authenticate(password)
    self.password == password ? self : nil
  end

  # Withdraw a certain amount from a balance
  # Can raise a NotEnoughFunds exception or returns the new balance if successful
  def withdraw(balance, amount)
    balance.withdraw(amount)
  end


  def deposit(balance, amount)
    balance.deposit(amount)
  end

  # def transfer(balance, account, amount)
  #   balance.transfer(balance, account, amount)
  # end

  def find_balance_by_coin(coin)
    self.balances.find {|balance| balance.coin == coin}
  end
end
