class Account < ActiveRecord::Base
  has_many :balances
  has_many :coins, through: :balances
end
