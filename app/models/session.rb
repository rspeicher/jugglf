# == Schema Information
# Schema version: 20090717234345
#
# Table name: sessions
#
#  id         :integer(4)      not null, primary key
#  session_id :string(255)     default(""), not null
#  data       :text
#  created_at :datetime
#  updated_at :datetime
#

class Session < ActiveRecord::Base
end
