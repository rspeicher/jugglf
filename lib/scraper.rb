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

# Parses a mmo-champion.com 'Loot Table' page using Scrapi
class ScrapiParser
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
        if item[:source] =~ /-hard$/
          item[:source].gsub!(/-hard$/, '')
          item[:hard] = true
        end
        
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

parser = ScrapiParser.new
parser.print_results