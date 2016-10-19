require 'spec_helper'

describe Bitfinex do
  it 'has a version number' do
    expect(Bitfinex::VERSION).not_to be nil
  end

  it 'configures correctly' do
    Bitfinex::Client.configure do |conf|
      conf.secret = ENV["BFX_API_SECRET"]
      conf.api_key = ENV["BFX_API_KEY"]
    end
    expect(Bitfinex::Client.config.secret).to eq('qoFv68HJACNmzflHztGnPE5U05LbSMES2OhaCVltj4k')
    expect(Bitfinex::Client.config.api_key).to eq('jK3FjbxhS7IRIQagYTMDUiQN5PcHO5xsMacDuFO990a')
  end
  it 'creates an instance' do
    client = Bitfinex::Client.new
    expect(client).to be_instance_of(Bitfinex::Client)
  end
  it 'gets a ticker' do
    client = Bitfinex::Client.new    
    ticker = client.ticker('btcusd')
    expect(ticker).not_to eq(nil)
    expect(ticker).to have_key('mid')
  end
  it 'gets stats' do
    client = Bitfinex::Client.new
    stats = client.stats()
    expect(stats[0]).to have_key('period')
  end
  it 'gets funding book' do
    client = Bitfinex::Client.new
    funding_book = client.funding_book()
    expect(funding_book).to have_key('bids')
  end
  it 'gets an order book' do
    client = Bitfinex::Client.new
    order_book = client.orderbook()
    expect(order_book).to have_key('bids')
  end
  it 'gets trades' do
    client = Bitfinex::Client.new
    trades = client.trades()
    expect(trades[0]).to have_key('price')
  end
  it 'gets lends' do
    client = Bitfinex::Client.new
    lends = client.lends
    expect(lends[0]).to have_key('amount_lent')
  end
end
