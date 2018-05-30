class Coin < ActiveRecord::Base
  has_many :balances
  has_many :accounts, through: :balances

  def convert_to(coin)
    
  end
end
