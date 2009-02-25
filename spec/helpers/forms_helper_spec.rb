require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include FormsHelper

describe FormsHelper do
  describe "styled_button" do
    it "should use type as text when no text is given" do
      styled_button(:type => 'button').
        should match(/<button.+>Button<\/button>$/)
    end
    
    it "should determine style based on type when no style is given" do
      styled_button(:type => 'submit').
        should match(/class='positive'/)
    end
    
    it "should include an image when one is supplied" do
      styled_button(:type => 'button', :image => 'tick.png').
        should match(/src=".+tick.png/)
    end
  end
end
