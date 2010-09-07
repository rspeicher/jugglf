module ItemLookupHelpers
  def valid_lookup_results
    results = ItemLookup::Results.new
    result = ItemLookup::Result.new({
      :id      => 40395,
      :name    => 'Torch of Holy Fire',
      :quality => 4,
      :icon    => 'INV_Mace_82',
      :level   => 226,
      :heroic  => false
    })

    results << result
  end

  def invalid_lookup_results
    results = ItemLookup::Results.new
    result = ItemLookup::Result.new

    results << result
  end
end
