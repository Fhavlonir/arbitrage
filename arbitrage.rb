require_relative 'ticker.rb'
require_relative 'exchange.rb'

southapi={name:"SouthXchange", url:'https://www.southxchange.com/api', delimiter:'/', reversed:false,
	  prices:{url:'/prices', market:'Market', bid:'Bid', ask:'Ask'}}
stocksapi={name:"stocks.exchange", url:'https://stocks.exchange/api2', delimiter:'_', reversed:false,
	   prices:{url:'/ticker', market:'market_name', bid:'bid', ask:'ask'}}
ogreapi={name:"TradeOgre", url:'https://tradeogre.com/api/v1', delimiter:'-', reversed:true,
	 prices:{url:'/markets', market:nil, bid:'bid', ask:'ask'}}
ex = []
ex << Exchange.new(southapi)
ex << Exchange.new(stocksapi)
ex << Exchange.new(ogreapi)
ex.each { |e| e.update_prices}
pairs = []
ex.each do |e|
	e.tickers.each do |name, ticker|
		if ticker.bid != 0 && ticker.bid != nil  &&
				ticker.ask != 0 && ticker.ask != nil
			pairs << ticker
		end
	end
end
def findprofits(pairs)
	trades=[]
	pairs.each do |pair1|
		pairs.each do |pair2|
			if pair1.traded_ticker == pair2.traded_ticker &&
			   pair1.reference_ticker == pair2.reference_ticker ||
			   pair1.traded_ticker == pair2.reference_ticker &&
			   pair1.reference_ticker == pair2.traded_ticker

				if pair1.bid-pair2.ask > 0
					trades << [pair1, pair2, 100*((pair1.bid/pair2.ask)-1)]
				end
			end
		end
	end
	trades.sort_by! {|e| -e[2]}
	trades.each do |t|
		output = "Buy #{t[0].to_s}" 
		output += " "*(16 - output.length)
		output += "for #{t[1].ask}" 
		output += " "*(30 - output.length)
		output += " on #{t[1].exchange}" 
		output += " "*(50 - output.length)
		output += " and sell for #{t[0].bid}" 
		output += " "*(80 - output.length)
		output += " at #{t[0].exchange}," 
		output += " "*(100 - output.length)
		output += " and make a profit of "
		output += " "*(10 - "#{t[2].round(2)}%".length)
		output += "#{t[2].round(2)}%"
		puts output
	end
end
def printpairs(pairs)
	pairs.each do |ticker|
		output = ticker.traded_ticker + "/" + ticker.reference_ticker 
		output += " "*(11 - output.length)
		output += " Bid: "+  ticker.bid.to_s
		output += " "*(30 - output.length)
		output += " Ask: " + ticker.ask.to_s
		output += " "*(50 - output.length)
		output += " Exchange: " + ticker.exchange.to_s

		puts output
	end
end
findprofits(pairs)
