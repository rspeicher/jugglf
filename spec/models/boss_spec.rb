# == Schema Information
# Schema version: 20090404033151
#
# Table name: bosses
#
#  id       :integer(4)      not null, primary key
#  name     :string(255)     default(""), not null
#  position :integer(4)      default(0)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Boss do
end
