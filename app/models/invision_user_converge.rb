# == Schema Information
# Schema version: 20090404033151
#
# Table name: ibf_members_converge
#
#  converge_id        :integer(4)      not null, primary key
#  converge_email     :string(250)     default(""), not null
#  converge_joined    :integer(4)      default(0), not null
#  converge_pass_hash :string(32)      default(""), not null
#  converge_pass_salt :string(5)       default(""), not null
#

class InvisionUserConverge < ActiveRecord::Base
  set_table_name "ibf_members_converge"
  set_primary_key "converge_id"
end
