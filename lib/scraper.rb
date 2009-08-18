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
end

# Parses a mmo-champion.com 'Loot Table' page using Scrapi
class ScrapiParser
  require 'rubygems'
  require 'scrapi'
  
  attr_accessor :results
  
  def initialize
    @results = {}
    
    scraper = Scraper.define do
      array :items
      # Horde tabs are "tabs3-[1-4]"
      1.upto(4) do |i|
        process "#tabs3-#{i} > table > tbody > tr", :items => Scraper.define {
          process "td:nth-child(1)", :level => :text
          process "td:nth-child(5) > a", :name => :text, :link => "@href"
          process "td:nth-child(6) > a", :source => :text, :source_link => "@href"
          result :level, :name, :link, :source, :source_link
        }
      end
      result :items
    end
    
    uri = URI.parse("http://www.mmo-champion.com/index.php?page=870")
    # uri = File.read(File.dirname(__FILE__) + '/page-870.html')
    items = scraper.scrape(uri)
    unless items.nil?
      items.each do |item|
        @results[item.source] ||= []
        @results[item.source] << item
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
      
      items = items.sort { |a,b| a.name <=> b.name }
      items.each do |item|
        puts "  item(boss, #{item.link.gsub(/.+i\/(\d+)\/.+/, '\1')}) ##{item.name}"
      end
    end
  end
end

parser = ScrapiParser.new
parser.print_results