class Balance < ActiveRecord::Base
  belongs_to :account
  belongs_to :coin

  # Returns current balance if transaction is successful,
  # raises an exception otherwise
  def withdraw(amount)
    if self.amount >= amount
      self.amount -= amount
    else
      raise NotEnoughFunds.new('There is not enough funds to process this transaction.')
    end
  end

  # Adds a deposit amount to the balance amount
  def deposit(amount)
    self.amount += amount
  end

  class NotEnoughFunds < StandardError
  end
end
