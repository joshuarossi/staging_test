require 'spec_helper'

Bitfinex::Client.configure do |conf|
  conf.api_key = ENV["BFX_API_KEY"]
  conf.secret = ENV["BFX_API_SECRET"]
  conf.api_endpoint = "https://dev-prdn.bitfinex.com:2998/v1/"
  conf.websocket_api_endpoint = "wss://dev-prdn.bitfinex.com:3000/ws"
end
client = Bitfinex::Client.new
describe Bitfinex do
  it 'has a version number' do
    expect(Bitfinex::VERSION).not_to be nil
  end

  it 'gets a ticker' do
    ticker = client.ticker('btcusd')
    expect(ticker).not_to eq(nil)
    expect(ticker).to have_key('mid')
  end
  it 'gets stats' do
    stats = client.stats()
    expect(stats[0]).to have_key('period')
  end
  it 'gets funding book' do
    funding_book = client.funding_book()
    expect(funding_book).to have_key('bids')
  end
  it 'gets an order book' do
    order_book = client.orderbook()
    expect(order_book).to have_key('bids')
  end
  it 'gets trades' do
    trades = client.trades()
    expect(trades[0]).to have_key('price')
  end
  it 'gets lends' do
    lends = client.lends
    expect(lends[0]).to have_key('amount_lent')
  end
  it 'gets symbols' do
    symbols = client.symbols
    expect(symbols).to include('btcusd')
  end
  it 'gets symbol details' do
    details = client.symbols_details
    expect(details[0]).to have_key('price_precision')
  end
  it 'gets account info' do
    info = client.account_info
    expect(info[0]).to have_key('maker_fees')
  end
  it 'gets a summary' do
    summary = client.summary
    expect(summary).to have_key('trade_vol_30d')
  end
  it 'gets a deposit address' do
    address = client.deposit('bitcoin', 'exchange')
    expect(address).to be_kind_of(String)
    pending
  end
  it 'submits an order' do
    id = client.new_order("btcusd", 1, "exchange limit", "sell", 700)
    expect(id).to have_key('id')
  end
  it 'gets active orders' do
    orders = client.orders
    expect(orders).to_not be_empty
  end
  it 'gets a single order status' do
    orders = client.orders
    order_id = orders[0]['id']
    order = client.order_status(order_id)
    expect(order).to have_key('id')
  end
  it 'replaces an order' do
    order = client.new_order('btcusd', 1, 'exchange limit', 'buy', 500)
    new_order = client.replace_order(order['id'], 'btcusd', 1, 'exchange limit', 'buy', 501)
    expect(new_order).to have_key('id')
  end
  it 'cancels a single order' do
    orders = client.orders
    cancel = client.cancel_orders(orders[0]['id'])
    expect(cancel).to have_key('is_cancelled')
  end
  it 'cancels all orders' do
    cancel = client.cancel_orders
    expect(cancel['result']).to be(1)
  end
  it 'gets active positions' do
    position = client.new_order('btcusd', 1, 'market', 'buy')
    positions = client.positions
    expect(positions).to_not be_empty
  end
  it 'claims a position' do
    positions = client.positions
    position = positions[0]
    result = client.claim_position(position['id'], '1.0')
    expect(result).to have_key('id')
  end
  it 'gets balance history' do
    result = client.history
    expect(result[0].keys).to include('description', 'timestamp','balance', 'currency', 'amount')
  end
  it 'gets movements' do
    movements = client.movements('usd')
    expect(movements).to be_kind_of(Array)
  end
  it 'gets past trades' do
    past_trades = client.mytrades('btcusd')
    expect(past_trades[0].keys).to include('price','amount')
  end
  it 'places a new offer' do
    new_offer = client.new_offer('usd', 100, 20, 30, "lend")
    expect(new_offer).to have_key('rate')
  end
  it 'gets all offers and checks the status of one offer' do
    offers = client.offers
    expect(offers).to be_kind_of(Array)
    offer = offers[0]
    expect(offer).to have_key('rate')
  end
  it 'cancels one offer' do
    offers = client.offers
    cancel = client.cancel_offer(offers[0]['id'])
    expect(cancel).to have_key('rate')
  end
  it 'views your active credits' do
    active_credits = client.credits
    expect(active_credits).to be_kind_of(Array)
  end
  it 'views taken funds' do
    taken_funds = client.taken_funds
    expect(taken_funds).to be_kind_of(Array)
  end
  it 'views unused taken funds' do
    funds = client.unused_taken_funds
    expect(funds).to be_kind_of(Array)
  end
  it 'total taken funds' do
    total = client.total_taken_funds
    expect(total).to be_kind_of(Array)
  end
  it 'closes used or unused funds' do
    fundingbook = client.funding_book('usd')
    offer = fundingbook['asks'][0]
    client.new_offer('usd', 100, offer['rate'], offer['period'], 'loan')
    taken_funds = client.unused_taken_funds
    to_be_canceled = taken_funds[0]
    result = client.close_funding(to_be_canceled['id'])
    expect(result).to have_key('rate')
  end
  it 'checks wallet balances' do
    balances = client.balances
    expect(balances).to be_kind_of(Array)
  end
  it 'checks margin info' do
    info = client.margin_infos
    expect(info).to be_kind_of(Array)
  end
  it 'transfers funds between wallets' do
    transfer = client.transfer(10, 'usd', 'exchange','deposit')
    transfer = client.transfer(10, 'usd', 'deposit', 'exchange')
    expect(transfer[0]['status']).to eq('success')
  end
  it 'requests a withdrawal' do
    withdrawal = client.withdraw("bitcoin","deposit",1000, address: "1DKwqRhDmVyHJDL4FUYpDmQMYA3Rsxtvur")
    expect(withdrawal).to be_kind_of(Array)
  end
  it 'checks the permission of the key' do
    result = client.key_info
    expect(result).to have_key('withdraw')
  end
  it 'connects via websockets' do
    client.listen_ticker do |tick|
      tick.inspect
    end
    client.listen_trades do |trade|
      trade.inspect
    end
    client.listen_book do |book|
      book.inspect
    end
  end
end
