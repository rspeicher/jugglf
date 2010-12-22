require 'rspec/expectations'

module PriceItemMatcher
  extend RSpec::Matchers::DSL

  matcher :price_item do |args|
    match do |subject|
      @args = args
      @actual_price = subject.price(args)
      @expected_price == @actual_price
    end

    failure_message_for_should do
      "expected ItemPrice.price(#{@args.inspect}) to return #{@expected_price}, but got #{@actual_price}"
    end

    chain :to do |expected_price|
      @expected_price = expected_price
    end
  end
end
