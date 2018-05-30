class Balance < ActiveRecord::Base
  belongs_to :account
  belongs_to :coin

  # Returns current balance if transaction is successful,
  # raises an exception otherwise
  def withdraw(amount)
    if has_enough_funds?
      self.amount -= amount
    else
      raise NotEnoughFunds.new('There is not enough funds to process this transaction.')
    end
  end

  # Adds a deposit amount to the balance amount
  def deposit(amount)
    self.amount += amount
  end

  # def transfer(balance, account, amount)
  #   if balance.withdraw(amount)
  #     account.find_or_create_balance_by_coin(balance.coin).deposit(amount)
  #   end
  # end

  def has_enough_funds?(amount)
    self.amount >= amount
  end

  class NotEnoughFunds < StandardError
  end
end
