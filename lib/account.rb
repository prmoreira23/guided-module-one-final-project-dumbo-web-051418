class Account < ActiveRecord::Base
  has_many :balances
  has_many :coins, through: :balances
  validates_uniqueness_of :username, unique: true

  # Returns an instance of Account if authentication is successful
  # returns nil otherwise.
  def authenticate(password)
    self.password == password ? self : nil
  end

  # Withdraw a certain amount from a balance
  # Can raise a NotEnoughFunds exception or returns the new balance if successful
  def withdraw(balance, amount)
    balance.withdraw(ammount)
  end


  def deposit(balance, amount)
    balance.deposit(amount)
  end
end
