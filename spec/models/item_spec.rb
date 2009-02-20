# == Schema Information
# Schema version: 20090213233547
#
# Table name: items
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  price        :float           default(0.0)
#  situational  :boolean(1)
#  best_in_slot :boolean(1)
#  member_id    :integer(4)
#  raid_id      :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#  rot          :boolean(1)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Item do
  fixtures :items
  
  before(:each) do
    @valid_attributes = {
    }
  end

  it "should create a new instance given valid attributes" do
    Item.create!(@valid_attributes)
  end
  
  it "should return the correct adjusted price" do
    items(:rot).adjusted_price.should == 0.50
    items(:best_in_slot).adjusted_price.should == items(:best_in_slot).price
  end
  
  it "should allow multiple items of the same name" do
    Item.destroy_all
    
    10.times do
      Item.create(:name => "Ubiquitous Item", :price => 3.14)
    end
    
    Item.all.count.should == 10
  end
  
  describe "from JuggyAttendance output" do
    before(:all) do
      @strings = {
        :single       => "Sebudai - [Arachnoid Gold Band]",
        :false_bis    => "Sebisudai - [Arachnoid Gold Band]",
        :best_in_slot => "Modrack (bis) - [Crown of the Lost Vanquisher]",
        :rot          => "Modrack (rot) - [Crown of the Lost Vanquisher]",
        :sit          => "Modrack (sit) - [Crown of the Lost Vanquisher]",
        :bisrot       => "Modrack (bis rot) - [Crown of the Lost Vanquisher]",
        :multiple     => "Modrack (bis), Rosoo (bis) - [Crown of the Lost Vanquisher]"
      }
    end
    
    before(:each) do
      Item.destroy_all
      Member.destroy_all
    end
    
    it "should not automatically insert items" do
      items = Item.from_attendance_output(@strings[:single])
      
      Item.count.should == 0
    end
    
    it "should correctly set best_in_slot" do
      items = Item.from_attendance_output(@strings[:best_in_slot])
      items[0].best_in_slot?.should be_true
    end
    
    it "should correctly set rot" do
      items = Item.from_attendance_output(@strings[:rot])
      items[0].rot?.should be_true
    end
    
    it "should correctly set situational" do
      items = Item.from_attendance_output(@strings[:sit])
      items[0].situational?.should be_true
    end
    
    it "should correctly set best_in_slot and rot" do
      items = Item.from_attendance_output(@strings[:bisrot])

      items[0].adjusted_price.should == 0.50
      items[0].best_in_slot?.should be_true
      items[0].situational?.should_not be_true
    end
    
    it "should not have false positives for purchase types inside buyer names" do
      items = Item.from_attendance_output(@strings[:false_bis])
      
      items[0].rot?.should_not be_true
      items[0].best_in_slot?.should_not be_true
      items[0].situational?.should_not be_true
    end
    
    it "should populate single item from single line" do
      items = Item.from_attendance_output(@strings[:single])
      items.length.should == 1
    end
    
    it "should populate multiple items from single line" do
      items = Item.from_attendance_output(@strings[:multiple])
      items.length.should == 2
    end
    
    it "should populate multiple items from multiple lines" do
      output = %Q{Sebudai - [Arachnoid Gold Band]
      Scipion - [Chains of Adoration]
      Elanar (rot), Alephone (sit) - [Shadow of the Ghoul]
      Scipion - [Wraith Strike]
      Horky (bis) - [Dying Curse]
      Parawon (sit) - [Thrusting Bands]
      Sebudai (rot) - [The Hand of Nerub]
      Modrack (bis), Rosoo (bis) - [Crown of the Lost Vanquisher]
      }
      
      output.each do |line|
        unless line.strip!.empty?
          items = Item.from_attendance_output(line)
        
          items.each do |item|
            item.save!
          end
        end
      end
      
      Item.count.should == 10
      Member.find_by_name('Sebudai').items.size.should == 2
    end
  end
  
  describe "automatic pricing" do
    fixtures :members
    
    it "should calculate Torch of Holy Fire (Main Hand) price for Hunters" do
      i = Item.create(:name => 'Torch of Holy Fire', :member => members(:sebudai))
      i.determine_item_price.should == 1.25
    end
    
    it "should calculate Torch of Holy Fire (Main Hand) price for non-Hunters" do
      i = Item.create(:name => 'Torch of Holy Fire', :member => members(:tsigo))
      i.determine_item_price.should == 4.00
    end
  end
end
