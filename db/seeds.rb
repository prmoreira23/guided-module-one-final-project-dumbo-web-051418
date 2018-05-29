
sammy = Account.create(username: "sammy")
pablo = Account.create(username: "pablo")
anthony = Account.create(username: "anthony")

bitcoin = Coin.create(name: "bitcoin", symbol: "BTC", website_slug: "bitcoin")
litecoin = Coin.create(name: "litecoin", symbol: "LTC", website_slug: "litecoin")


sammy_balance = Balance.create(account_id: sammy.id, coin_id: bitcoin.id, amount: 1000)
pablo_balance = Balance.create(account_id: pablo.id, coin_id: bitcoin.id, amount: 2000)
pablo_balance2 = Balance.create(account_id: pablo.id, coin_id: litecoin.id, amount: 500)
anthony_balance = Balance.create(account_id: anthony.id, coin_id: bitcoin.id, amount: 8000)


# require 'rest-client'
# require 'json'
#
# url = 'https://api.coinmarketcap.com/v2/listings/'
# response = RestClient.get(url)
# data = JSON.parse(response)
