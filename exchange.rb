require_relative 'ticker.rb'
require 'json'
require 'httparty'
class Exchange
	attr_accessor :api_config, :tickers, :delimiter, :api_keys
	def initialize(api_config)
		@api_config = api_config
		@tickers = {}
	end
	def update_prices
		r = JSON.parse( HTTParty.get(@api_config[:url] + 
					     @api_config.dig( :prices, :url)).body)
		
		marketname = @api_config.dig( :prices, :market)
		bidname = @api_config.dig( :prices, :bid)
		askname = @api_config.dig( :prices, :ask)

		##THIS IS INCREDIBLY UGLY AND BAD (but it works)
		if marketname.nil?
			r.each do |ticker|
				ticker.each do |name, t|
					
					unless tickers.key? name
						self.addtickers(name)
					end
					puts "t: #{t}"
					puts "name: #{name}"
					puts "tickers[name]: #{tickers[name]}"
					tickers[name].update_ticker(t[bidname], t[askname])
				end
			end
		else
			r.each do |t|
				puts t
				unless tickers.key? t[marketname]
					self.addtickers(t[marketname])
				end
				tickers[t[marketname]].update_ticker(t[bidname],t[askname])
			end
		end
	end


	def addtickers(tickers=nil)
		ticker = Ticker.new(tickers, api_config[:delimiter])
		@tickers[ticker.to_s] = ticker
	end
end
if __FILE__ == $0
	southapi={url:'https://www.southxchange.com/api', delimiter:'/', markets:'/markets', prices:{url:'/prices', market:'Market', bid:'Bid', ask:'Ask'}}
	stocksapi={url:'https://stocks.exchange/api2', delimiter:'_', prices:{url:'/ticker', market:'market_name', bid:'bid', ask:'ask'}}
	ogreapi={url:'https://tradeogre.com/api/v1', delimiter:'-', prices:{url:'/markets', market:nil, bid:'bid', ask:'ask'}}
	ex = Exchange.new(stocksapi)
	ex.update_prices
	puts ex.api_config
	ex.tickers.each do |name, ticker|
		puts ticker.to_s + " Bid: "+  ticker.bid.to_s + " Ask: " + ticker.ask.to_s
	end
end
