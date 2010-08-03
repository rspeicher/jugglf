When /^(?:|I )?expect the following item prices?:$/ do |table|
  @expected = table
  @prices   = []

  table.hashes.each do |hash|
    args = hash.symbolize_keys.reject! { |k, v| k == :price }
    @prices << ItemPrice.instance.price(args)
  end
end

Then /^(?:|I )?should receive the correct prices?$/ do
  @expected.hashes.each_with_index do |hash, i|
    if @prices[i] != hash['price'].to_f
      fail "Expected price for #{hash.inspect} to be #{hash['price']} but was #{@prices[i]}"
    end
  end
end
