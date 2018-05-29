class Coin < ActiveRecord::Base
  has_many :balances
  has_many :accounts, through: :balances
end
