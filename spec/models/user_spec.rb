# == Schema Information
# Schema version: 20090225185730
#
# Table name: users
#
#  id                 :integer(4)      not null, primary key
#  login              :string(255)     default(""), not null
#  crypted_password   :string(255)     default(""), not null
#  password_salt      :string(255)     default(""), not null
#  persistence_token  :string(255)     default(""), not null
#  login_count        :integer(4)      default(0), not null
#  failed_login_count :integer(4)      default(0), not null
#  last_request_at    :datetime
#  current_login_at   :datetime
#  last_login_at      :datetime
#  current_login_ip   :string(255)
#  last_login_ip      :string(255)
#  is_admin           :boolean(1)      not null
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
    @user = User.make
  end
  
  it "should be valid" do
    @user.should be_valid
  end
end
