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
					tickers[name].update_ticker(t[bidname].to_f, t[askname].to_f)
				end
			end
		else
			r.each do |t|
				unless tickers.key? t[marketname]
					self.addtickers(t[marketname])
				end
				tickers[t[marketname]].update_ticker(t[bidname].to_f,t[askname].to_f)
			end
		end
	end


	def addtickers(tickers=nil)
		ticker = Ticker.new(tickers, api_config[:delimiter])
		ticker.exchange = self
		@tickers[ticker.to_s] = ticker
	end
	def to_s
		return api_config[:name]
	end
end
