require_relative 'ticker.rb'
require 'json'
require 'httparty'
class Exchange
	attr_accessor :api_config, :tickers, :delimiter, :api_keys
	def initialize(api_config, tickers)
		@api_config = api_config
		@tickers = []
		self.addtickers(tickers)
	end
	def addtickers(tickers=nil)
		if tickers.respond_to?("each")
			tickers.each do |t|
				self.addticker(t)
			end
		else
			@tickers << Ticker.new(tickers, nil)
		end
	end
end
if __FILE__ == $0
	ex = Exchange.new("This is supposed to be an api_config file", "MSR/BTC")
	puts ex.api_config
	puts ex.tickers
	response=HTTParty.get('https://www.southxchange.com/api/markets')
	b = response.body
	r = JSON.parse(b)
	r.each do |t|
		ex.addtickers("#{t[0]}/#{t[1]}")
	end
	ex.tickers.each do |t|
		puts t
	end
end
