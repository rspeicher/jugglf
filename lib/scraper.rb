# Parses the javascript db.mmo-champion.com uses to populate its HTML tables
# That method prevents Scrapi or Nokogiri from being used, so we just parse the
# raw output with gold ol' Regex
class JavascriptParser
  require 'open-uri'

  def initialize
    tags = {
      'northrendbeasts-10'       => 'Northrend Beasts',
      'jaraxxus-10'              => 'Jaraxxus',
      'factionchampions-10'      => 'Faction Champions',
      'twinvalkyrs-10'           => 'Twin Valkyrs',
      'anubarakraid-10'          => "Anub'arak",

      'northrendbeasts-10-hard'  => 'Northrend Beasts',
      'jaraxxus-10-hard'         => 'Jaraxxus',
      'factionchampions-10-hard' => 'Faction Champions',
      'twinvalkyrs-10-hard'      => 'Twin Valkyrs',
      'anubarakraid-10-hard'     => "Anub'arak",
      'tributechest-10'          => 'Tribute Chest',
      'tributechest-10-hard'     => 'Tribute Chest (Hard)',

      'northrendbeasts-25'       => 'Northrend Beasts',
      'jaraxxus-25'              => 'Jaraxxus',
      'factionchampions-25'      => 'Faction Champions',
      'twinvalkyrs-25'           => 'Twin Valkyrs',
      'anubarakraid-25'          => "Anub'arak",

      'northrendbeasts-25-hard'  => 'Northrend Beasts',
      'jaraxxus-25-hard'         => 'Jaraxxus',
      'factionchampions-25-hard' => 'Faction Champions',
      'twinvalkyrs-25-hard'      => 'Twin Valkyrs',
      'anubarakraid-25-hard'     => "Anub'arak",
      'tributechest-25'          => 'Tribute Chest',
      'tributechest-25-hard'     => 'Tribute Chest (Hard)'
    }

    tags.each do |tag, name|
      parse_tag(tag, name)
    end
  end

  def parse_tag(tag, name)
    html = open("http://db.mmo-champion.com/tag/item/#{tag}/").string

    unless html.nil?
      puts "##{tag} - #{name}"
      puts "when \"#{name}\""
      results = html.match(/var\ssearch_results\s=\s\{(.*)\}\s+drawtable/im)

      if results.length > 0
        results[0].split("\n").each do |result|
          # "47608:{'slot': 8, 'name': 'Acidmaw Boots', 'level': 232, 'subclass': 'Leather', 'link': '/i/47608/acidmaw-boots/', 'quality': 4, 'required_level': 80},"
          details = result.match(/^([0-9]+):.+'name': '(.+)', 'level':/)
          unless details.nil?
            puts "  item(boss, #{details[1].to_i}) # #{details[2]}"
          end
        end
      end
    end
  end
end

class ArmoryParser
  require 'open-uri'
  require 'nokogiri'

  attr_accessor :results

  def initialize
    @results = {}

    tags = {
      # Tag => [Size, Difficulty, Boss ID]
      'marrowgar-10'          => [10, 'normal', 36612],
      'deathwhisper-10'       => [10, 'normal', 36855],
      'gunship-10'            => [10, 'normal', 202178],
      'saurfang-10'           => [10, 'normal', 37813],
      'festergut-10'          => [10, 'normal', 36626],
      'rotface-10'            => [10, 'normal', 36627],
      'putricide-10'          => [10, 'normal', 36678],
      'bloodprinces-10'       => [10, 'normal', 37970],
      'queenlanathel-10'      => [10, 'normal', 37955],
      'valithria-10'          => [10, 'normal', 201959],
      'sindragosa-10'         => [10, 'normal', 36853],
      'lichking-10'           => [10, 'normal', 36597],

      'marrowgar-10-hard'     => [10, 'heroic', 36612],
      'deathwhisper-10-hard'  => [10, 'heroic', 36855],
      'gunship-10-hard'       => [10, 'heroic', 202178],
      'saurfang-10-hard'      => [10, 'heroic', 37813],
      'festergut-10-hard'     => [10, 'heroic', 36626],
      'rotface-10-hard'       => [10, 'heroic', 36627],
      'putricide-10-hard'     => [10, 'heroic', 36678],
      'bloodprinces-10-hard'  => [10, 'heroic', 37970],
      'queenlanathel-10-hard' => [10, 'heroic', 37955],
      'valithria-10-hard'     => [10, 'heroic', 201959],
      'sindragosa-10-hard'    => [10, 'heroic', 36853],
      'lichking-10-hard'      => [10, 'heroic', 36597],

      'marrowgar-25'          => [25, 'normal', 37957],
      'deathwhisper-25'       => [25, 'normal', 38106],
      'gunship-25'            => [25, 'normal', 202180],
      'saurfang-25'           => [25, 'normal', 38582],
      'festergut-25'          => [25, 'normal', 37504],
      'rotface-25'            => [25, 'normal', 38390],
      'putricide-25'          => [25, 'normal', 38431],
      'bloodprinces-25'       => [25, 'normal', 38401],
      'queenlanathel-25'      => [25, 'normal', 38434],
      'valithria-25'          => [25, 'normal', 202339],
      'sindragosa-25'         => [25, 'normal', 38265],
      'lichking-25'           => [25, 'normal', 39166],

      'marrowgar-25-hard'     => [25, 'heroic', 37957],
      'deathwhisper-25-hard'  => [25, 'heroic', 38106],
      'gunship-25-hard'       => [25, 'heroic', 202180],
      'saurfang-25-hard'      => [25, 'heroic', 38582],
      'festergut-25-hard'     => [25, 'heroic', 37504],
      'rotface-25-hard'       => [25, 'heroic', 38390],
      'putricide-25-hard'     => [25, 'heroic', 38431],
      'bloodprinces-25-hard'  => [25, 'heroic', 38401],
      'queenlanathel-25-hard' => [25, 'heroic', 38434],
      'valithria-25-hard'     => [25, 'heroic', 202339],
      'sindragosa-25-hard'    => [25, 'heroic', 38265],
      'lichking-25-hard'      => [25, 'heroic', 39166],
    }

    tags.each do |tag, data|
      parse_boss(tag, data[0], data[2], data[1])
      sleep(3)
    end
  end

  def parse_boss(tag, dungeon, boss_id, difficulty)
    url = "http://www.wowarmory.com/search.xml?fl[source]=dungeon&fl[dungeon]=icecrowncitadel#{dungeon}&fl[boss]=#{boss_id}&fl[difficulty]=#{difficulty}&searchType=items"

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

# Parses a mmo-champion.com 'Loot Table' page using Nokogiri
class NokogiriParser
  require 'open-uri'
  require 'nokogiri'

  attr_accessor :results

  def initialize
    @results = {}

    doc = Nokogiri::HTML(open("http://www.mmo-champion.com/index.php?page=904"))
    1.upto(4) do |i|
      doc.css("#tabs-#{i} > table > tbody > tr").each do |tr|
        item = {
          :level       => tr.css("td:nth-child(1)").first.content,
          :name        => tr.css("td:nth-child(5) > a").first.content,
          :link        => tr.css("td:nth-child(5) > a").first['href'],
          :hard        => false
        }

        # Sometimes a source is blank. Grumble grumble.
        if tr.css("td:nth-child(6) > a").first.nil?
          item[:source] = 'Unknown'
          item[:source_link] = ''
        else
          item[:source]      = tr.css("td:nth-child(6) > a").first.content
          item[:source_link] = tr.css("td:nth-child(6) > a").first['href']
        end

        # Hard mode isn't in a separate zone no mo'.
        # if item[:source] =~ /-hard$/
        #   item[:source].gsub!(/-hard$/, '')
        #   item[:hard] = true
        # end

        @results[item[:source]] ||= []
        @results[item[:source]] << item
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
        hard_mode = ( item[:hard] ) ? ", 'Heroic'" : ''
        puts "  item(boss, #{item[:link].gsub(/.+i\/(\d+)\/.+/, '\1')}#{hard_mode}) ##{item[:name]}"
      end
    end
  end
end

parser = ArmoryParser.new
parser.print_results