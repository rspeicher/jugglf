# require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
# 
# describe ItemPrice do
#   before(:all) do
#     @ip = Juggy::ItemPrice.instance
#   end
#   
#   it "should calculate Head prices" do
#     @ip.price(:slot => 'Head', :level => 226).should == 2.50
#   end
# 
#   it "should calculate Shoulder prices" do
#     @ip.price(:slot => 'Shoulder', :level => 226).should == 2.00
#   end
# 
#   it "should calculate Wrist prices" do
#     @ip.price(:slot => 'Wrist', :level => 226).should == 1.50
#   end
# 
#   it "should calculate Neck prices" do
#     @ip.price(:slot => 'Neck', :level => 226).should == 2.00
#   end
# 
#   it "should calculate Two-Hand prices" do
#     @ip.price(:slot => 'Two-Hand', :level => 226).should == 5.00
#     @ip.price(:slot => 'Two-Hand', :level => 226, :class => 'Hunter').should == 2.00
#   end
# 
#   it "should calculate Main Hand prices" do
#     @ip.price(:slot => 'Main Hand', :level => 226, :class => 'Priest').should == 3.50
#     @ip.price(:slot => 'Main Hand', :level => 226, :class => 'Hunter').should == 1.00
#   end
# 
#   it "should calculate One-Hand prices" do
#     @ip.price(:slot => 'One-Hand', :level => 226, :class => 'Rogue').should == 2.50
#     @ip.price(:slot => 'One-Hand', :level => 226, :class => 'Hunter').should == 1.00
#   end
# 
#   it "should calculate Relic and Ranged prices" do
#     @ip.price(:slot => 'Relic', :level => 226).should == 1.00
#     @ip.price(:slot => 'Ranged', :level => 226, :class => 'Hunter').should == 4.00
#   end
# 
#   it "should calculate Trinket prices" do
#     @ip.price(:slot => 'Trinket', :name => 'Soul of the Dead', :level => 226).should == 4.00
#     @ip.price(:slot => 'Trinket', :name => 'InvalidTrinket', :level => 226).should be_nil
#   end
#   
#   describe "special case items" do
#     it "should calculate for Heroic Key to the Focusing Iris" do
#       @ip.price(:name => 'Heroic Key to the Focusing Iris').should == 2.00
#     end
#     
#     it "should calculate for Fragment of Val'anyr" do
#       @ip.price(:name => 'Fragment of Val\'anyr', :level => 80).should == 0.00
#     end
#     
#     it "should not return nil for older items" do
#       @ip.price(:slot => "Two-Hand", :level => 158, :class => "Warlock").should == 0.00
#     end
#     
#     describe "tier tokens" do
#       it "should calculate for Breastplate" do
#         @ip.price(:name => 'Breastplate of the Wayward Conqueror', :level => 80).should == 2.50
#       end
#       
#       it "should calculate for Crown" do
#         @ip.price(:name => 'Crown of the Wayward Conqueror', :level => 80).should == 2.50
#       end
#       
#       it "should calculate for Gauntlets" do
#         @ip.price(:name => 'Gauntlets of the Wayward Conqueror', :level => 80).should == 2.00
#       end
#       
#       it "should calculate for Legplates" do
#         @ip.price(:name => 'Legplates of the Wayward Conqueror', :level => 80).should == 2.50
#       end
#       
#       it "should calculate for Mantle" do
#         @ip.price(:name => 'Mantle of the Wayward Conqueror', :level => 80).should == 2.00
#       end
#       
#       it "should calculate for Lost" do
#         @ip.price(:name => 'Mantle of the Lost Vanquisher', :level => 80).should == 1.50
#       end
#       
#       it "should calculate for Wayward" do
#         @ip.price(:name => 'Mantle of the Wayward Vanquisher', :level => 80).should == 2.00        
#       end
#     end
#   end
# end
# 
# describe ItemPrice, "weapon special cases" do
#   before(:each) do
#     @ip = Juggy::ItemPrice.instance
#   end
#   
#   describe "for Death Knights" do
#     it "should calculate all weapon prices" do
#       @ip.price(:slot => 'Off Hand', :level => 226, :class => 'Death Knight').should == 2.50
#     end
#   end
#   
#   describe "for Hunters" do
#     it "should calculate all weapon prices" do
#       @ip.price(:slot => 'Main Hand', :level => 226, :class => 'Hunter').should == 1.00
#       @ip.price(:slot => 'Ranged', :level => 226, :class => 'Hunter').should == 4.00
#     end
#   end
#   
#   describe "for Rogues" do
#     it "should calculate all weapon prices" do
#       @ip.price(:slot => 'One-Hand', :level => 226, :class => 'Rogue').should == 2.50
#       @ip.price(:slot => 'Thrown', :level => 226, :class => 'Rogue').should == 1.00
#     end
#   end
#   
#   describe "for Shaman" do
#     it "should calculate Shield price" do
#       @ip.price(:slot => 'Shield', :level => 226, :class => 'Shaman').should == 1.50
#     end
#   
#     it "should calculate One-Hand price" do
#       @ip.price(:slot => 'One-Hand', :level => 226, :class => 'Shaman').should == 2.50
#     end
#   
#     it "should calculate every other slot price" do
#       @ip.price(:slot => 'Main Hand', :level => 226, :class => 'Shaman').should == 3.50
#     end
#   end
#   
#   describe "for Warriors" do
#     it "should calculate Shield price" do
#       @ip.price(:slot => 'Shield', :level => 226, :class => 'Warrior').should == 2.50
#     end
#     
#     it "should calculate all weapon prices" do
#       @ip.price(:slot => 'Off Hand', :level => 226, :class => 'Warrior').should == 2.50
#     end
#   end
#   
#   describe "for other classes" do
#     it "should calculate all weapon prices" do
#       @ip.price(:slot => 'Main Hand', :level => 232, :class => 'Priest').should == 3.50
#     end
#   end
# end