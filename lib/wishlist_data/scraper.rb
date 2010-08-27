require 'rubygems'

class ArmoryParser
  require 'open-uri'
  require 'nokogiri'

  attr_accessor :results

  def initialize
    @results = {}

    # tags = {
    #   # Tag => [Size, Difficulty, Boss ID]
    #   'marrowgar-10'          => [10, 'normal', 36612],
    #   'deathwhisper-10'       => [10, 'normal', 36855],
    #   'gunship-10'            => [10, 'normal', 202178],
    #   'saurfang-10'           => [10, 'normal', 37813],
    #   'festergut-10'          => [10, 'normal', 36626],
    #   'rotface-10'            => [10, 'normal', 36627],
    #   'putricide-10'          => [10, 'normal', 36678],
    #   'bloodprinces-10'       => [10, 'normal', 37970],
    #   'queenlanathel-10'      => [10, 'normal', 37955],
    #   'valithria-10'          => [10, 'normal', 201959],
    #   'sindragosa-10'         => [10, 'normal', 36853],
    #   'lichking-10'           => [10, 'normal', 36597],

    #   'marrowgar-10-hard'     => [10, 'heroic', 36612],
    #   'deathwhisper-10-hard'  => [10, 'heroic', 36855],
    #   'gunship-10-hard'       => [10, 'heroic', 202178],
    #   'saurfang-10-hard'      => [10, 'heroic', 37813],
    #   'festergut-10-hard'     => [10, 'heroic', 36626],
    #   'rotface-10-hard'       => [10, 'heroic', 36627],
    #   'putricide-10-hard'     => [10, 'heroic', 36678],
    #   'bloodprinces-10-hard'  => [10, 'heroic', 37970],
    #   'queenlanathel-10-hard' => [10, 'heroic', 37955],
    #   'valithria-10-hard'     => [10, 'heroic', 201959],
    #   'sindragosa-10-hard'    => [10, 'heroic', 36853],
    #   'lichking-10-hard'      => [10, 'heroic', 36597],

    #   'marrowgar-25'          => [25, 'normal', 37957],
    #   'deathwhisper-25'       => [25, 'normal', 38106],
    #   'gunship-25'            => [25, 'normal', 202180],
    #   'saurfang-25'           => [25, 'normal', 38582],
    #   'festergut-25'          => [25, 'normal', 37504],
    #   'rotface-25'            => [25, 'normal', 38390],
    #   'putricide-25'          => [25, 'normal', 38431],
    #   'bloodprinces-25'       => [25, 'normal', 38401],
    #   'queenlanathel-25'      => [25, 'normal', 38434],
    #   'valithria-25'          => [25, 'normal', 202339],
    #   'sindragosa-25'         => [25, 'normal', 38265],
    #   'lichking-25'           => [25, 'normal', 39166],

    #   'marrowgar-25-hard'     => [25, 'heroic', 37957],
    #   'deathwhisper-25-hard'  => [25, 'heroic', 38106],
    #   'gunship-25-hard'       => [25, 'heroic', 202180],
    #   'saurfang-25-hard'      => [25, 'heroic', 38582],
    #   'festergut-25-hard'     => [25, 'heroic', 37504],
    #   'rotface-25-hard'       => [25, 'heroic', 38390],
    #   'putricide-25-hard'     => [25, 'heroic', 38431],
    #   'bloodprinces-25-hard'  => [25, 'heroic', 38401],
    #   'queenlanathel-25-hard' => [25, 'heroic', 38434],
    #   'valithria-25-hard'     => [25, 'heroic', 202339],
    #   'sindragosa-25-hard'    => [25, 'heroic', 38265],
    #   'lichking-25-hard'      => [25, 'heroic', 39166],
    # }

    tags = {
      'halion-10'      => [10, 'normal', 39863],
      'halion-25'      => [25, 'normal', 39864],
      'halion-10-hard' => [10, 'heroic', 39863],
      'halion-25-hard' => [25, 'heroic', 39864],
    }

    tags.each do |tag, data|
      parse_boss(tag, data[0], data[2], data[1])
      sleep(3)
    end
  end

  def parse_boss(tag, size, boss_id, difficulty)
    url = "http://www.wowarmory.com/search.xml?fl[source]=dungeon&fl[dungeon]=rubysanctum#{size}&fl[boss]=#{boss_id}&fl[difficulty]=#{difficulty}&searchType=items"

    doc = Nokogiri::XML(open(url, content_headers))
    doc.search('page/armorySearch/searchResults/items/item').each do |item|
      result = {
        :level  => item.search('filter[@name="itemLevel"]').first['value'].to_i,
        :name   => item['name'],
        :id     => item['id'].to_i,
        :rarity => item['rarity'].to_i
      }

      @results[tag] ||= []

      if result[:level] >= 80 and result[:rarity] == 4 and result[:id] != 49426 # Emblem of Frost
        @results[tag] << result
      end
    end
  end

  def print_results
    return if @results.length <= 0

    last_source = nil
    @results.each do |source, items|
      unless source == last_source
        puts "when \"#{source}\""
      end

      items = items.sort { |a,b| a[:name] <=> b[:name] }
      items.each do |item|
        puts "  item(boss, #{item[:id]}) ##{item[:name]}"
      end
    end
  end

  private
    # HTTP headers used to make wowarmory.com give us what we want!
    def content_headers
      { 'User-Agent'      => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.0.7) Gecko/2009021906 Firefox/3.0.7",
        'Accept-language' => 'enUS' }
    end
end

parser = ArmoryParser.new
parser.print_results
