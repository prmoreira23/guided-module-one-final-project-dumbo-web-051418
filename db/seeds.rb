Coin.destroy_all
Account.destroy_all
Balance.destroy_all

#Accounts
sammy = Account.create(username: "sammy", password: "thebull", first_name: "Sammy", last_name: "Akharaz")
pablo = Account.create(username: "pabloo", password: "brazilrocks", first_name: "Pablo", last_name: "Moreira")
anthony = Account.create(username: "anthony" ,password: "tonyspizza", first_name: "Anthony", last_name: "Lam")
matt = Account.create(username: "matt", password: "youguysareawesome", first_name: "Matt", last_name: "McAlister")
prince = Account.create(username: "prince", password: "mattisgreat", first_name: "Prince", last_name: "Wilson")

#Coins
coins = CryptoApi.coins[1..5]
coins.each {|coin| coin.save }

#Balances

prince_balance = Balance.create(account_id: 5, coin_id: 2, amount: 1663.0)
prince_balance2 = Balance.create(account_id: 5, coin_id: 3, amount: 1756.0)
matt_balance = Balance.create(account_id: 4, coin_id: 5, amount: 933.0)
matt_balance2 = Balance.create(account_id: 4, coin_id: 2, amount: 1991.0)
anthony_balance = Balance.create(account_id: 3, coin_id: 3, amount: 423.0)
anthony_balance2 = Balance.create(account_id: 3, coin_id: 2, amount: 1938.0)
sammy_balance = Balance.create(account_id: 1, coin_id: 3, amount: 405.0)
sammy_balance2 = Balance.create(account_id: 1, coin_id: 1, amount: 1275.0)
sammy_balance3 = Balance.create(account_id: 1, coin_id: 4, amount: 1550.0)
sammy_balance4 = Balance.create(account_id: 1, coin_id: 5, amount: 814.0)
pablo_balance = Balance.create(account_id: 2, coin_id: 1, amount: 1991.0)
pablo_balance2 = Balance.create(account_id: 2, coin_id: 2, amount: 453.0)
pablo_balance3 = Balance.create(account_id: 2, coin_id: 5, amount: 2000.0)
