ItemStat.blueprint do
  item    { 'Item Name' }
  item_id { 12345 }
  level   { 213 }
end
ItemStat.blueprint(:mainhand) do
  slot { 'Main Hand' }
end
ItemStat.blueprint(:quest_item) do
  item { 'Heroic Key to the Focusing Iris' }
  slot { nil }
end
ItemStat.blueprint(:twohand) do
  slot { 'Two-Hand' }
end
ItemStat.blueprint(:onehand) do
  slot { 'One-Hand' }
end
ItemStat.blueprint(:trinket) do
  slot { 'Trinket' }
end
ItemStat.blueprint(:chest_token) do
  item { 'Breastplate of the Lost Conqueror' }
  slot { nil }
end