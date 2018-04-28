class Ticker
	attr_accessor :traded_ticker, :reference_ticker, :delimiter, :bid, :ask, :exchange
	def initialize(name, delimiter)
		if name.respond_to?("each")
			@traded_ticker=name[0]
			@reference_ticker=name[1]
			@delimiter = delimiter
			return
		end
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

