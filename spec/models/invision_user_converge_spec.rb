# == Schema Information
# Schema version: 20090224005026
#
# Table name: ibf_members_converge
#
#  converge_id        :integer(4)      not null, primary key
#  converge_email     :string(250)     default(""), not null
#  converge_joined    :integer(4)      default(0), not null
#  converge_pass_hash :string(32)      default(""), not null
#  converge_pass_salt :string(5)       default(""), not null
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InvisionUserConverge do
end
