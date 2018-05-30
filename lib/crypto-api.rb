require 'rest-client'
require 'json'

class CryptoApi

  URI_BASE = "https://api.coinmarketcap.com/v2/"

  def self.get_coin_by_name(name)
    coins.find {|coin| coin.name == name}
  end

  def self.get_coin_by_id(id)
    coins.find {|coin| coin.id == id}
  end

  def self.coins
    @@coins
    # self.get_all_coins
  end

  def self.reload_coins
    self.coins = self.get_all_coins
  end

  private
  def self.get_JSON(api_endpoint)
    response = RestClient.get(api_endpoint)
    data = JSON.parse(response)
  end

  def self.get_all_coins
    url = "#{URI_BASE}listings/"
    coins = get_JSON(url)['data']
    coins.map {|coin|
      Coin.new(coin)
    }
  end

  def self.get_quote(coin_from, coin_to)
    url = "#{URI_BASE}ticker/#{coin_from.id}/?convert=#{coin_to.symbol}"
    quote = get_JSON(url)['data']['quotes'][coin_to.symbol]["price"]
  end


  @@coins = self.get_all_coins

end
