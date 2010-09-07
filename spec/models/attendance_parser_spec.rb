require 'spec_helper'

describe AttendanceParser, ".parse_attendees" do
  let(:attendance_output) { "Sebudai,1.00,233" }

  it "should return an array of hashes" do
    att = AttendanceParser.parse_attendees(attendance_output)
    att.size.should eql(1)
    att[0].class.should eql(Hash)
  end

  it "should return duplicate members when provided" do
    output = ''
    3.times { output += attendance_output + "\n" }
    att = AttendanceParser.parse_attendees(output)

    att.size.should eql(3)
  end
end

describe AttendanceParser, ".parse_loots" do
  describe "basic parsing" do
    let(:member) { Factory(:member) }
    let(:item) { Factory(:item) }

    it "should return an array of hashes" do
      loots = AttendanceParser.parse_loots("#{member.name} - [#{item.name}]")
      loots.size.should eql(1)
      loots[0].should be_a Hash
    end

    it "should figure out price based on item stats" do
      loots = AttendanceParser.parse_loots("#{member.name} - [#{Factory(:item_with_real_stats).name}]")
      loots[0][:price].should eql(1.00)
    end

    it "should initialize a non-existent item by ID if provided" do
      Item.should_receive(:find_or_initialize_by_id).with('12345').and_return(item)
      AttendanceParser.parse_loots("#{member.name} - [Whatever]|12345")
    end
  end

  describe "loot attributes" do
    let(:item) { Factory(:item_with_real_stats) }

    it "should return one Hash" do
      loot = AttendanceParser.parse_loots("Member - #{item.name}")
      loot[0].should be_a Hash
    end

    it "should correctly set best_in_slot" do
      loot = AttendanceParser.parse_loots("Member (bis) - #{item.name}")
      loot[0][:best_in_slot].should be_true
    end

    it "should correctly set situational" do
      loot = AttendanceParser.parse_loots("Member (sit) - #{item.name}")
      loot[0][:situational].should be_true
    end

    it "should correctly set rot" do
      loot = AttendanceParser.parse_loots("Member (rot) - #{item.name}")
      loot[0][:rot].should be_true
    end

    it "should correctly set best_in_slot and rot at the same time" do
      loot = AttendanceParser.parse_loots("Member (bis rot) - #{item.name}")
      loot[0][:best_in_slot].should be_true
      loot[0][:rot].should be_true
    end

    it "should not have false positives for purchase types inside buyer names" do
      loot = AttendanceParser.parse_loots("Membiser - #{item.name}")
      loot[0][:best_in_slot].should be_false
    end

    it "should set member as nil if buyer is 'DE'" do
      loot = AttendanceParser.parse_loots("DE - #{item.name}")
      loot[0][:member].should be_nil
    end

    context "with multiple buyers on one line" do
      let(:loot) { AttendanceParser.parse_loots("Modrack (bis), Rosoo (sit), DE - #{item.name}") }

      it "should get the correct number of buyers" do
        loot.size.should eql(3)
      end

      it "should get the correct buyer names" do
        loot[0][:member].name.should eql('Modrack')
        loot[1][:member].name.should eql('Rosoo')
        loot[2][:member].should be_nil
      end

      it "should get the correct item types" do
        loot[0][:best_in_slot].should be_true
        loot[1][:situational].should be_true
      end
    end
  end
end
