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
  end

  def self.reload_coins
    self.coins = self.get_all_coins
  end

  def self.get_quote_dollar(coin)
    url = "#{URI_BASE}ticker/#{coin_from.id}/?convert=#{coin_from.symbol}"
    quote = get_JSON(url)['data']['quotes']["USD"]["price"]
  end

  def self.get_quotes_to_dollar
    url = "https://api.coinmarketcap.com/v2/ticker/?start=1&limit=5&sort=id"
    response = RestClient.get(url)
    data = JSON.parse(response)
    quotes = []
    coin_hash = data["data"]
    coin_hash.each do |coin_id, coin|
      quotes << coin['quotes']["USD"]["price"]
    end
    quotes
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

  begin
    @@coins = self.get_all_coins
  rescue RestClient::TooManyRequests => e
    puts 'Too many requests to free API.'
  end

end
