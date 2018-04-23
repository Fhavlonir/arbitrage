class Ticker
	attr_accessor :traded_ticker, :reference_ticker, :delimiter, :bid, :ask
	def initialize(name, delimiter)
		if delimiter.nil?
			@delimiter = name.gsub(/\w+/, '')
		else
			@delimiter = delimiter
		end
		unless name.nil? || @delimiter.nil?
			@traded_ticker, @reference_ticker = name.split("#{@delimiter}")
		end
	end
	def update_ticker(bid, ask)
		@bid = bid
		@ask = ask
	end
	def to_s
		return "#{@traded_ticker}#{@delimiter}#{@reference_ticker}"
	end
end

