# == Schema Information
# Schema version: 20090312150316
#
# Table name: mgdkp_member_ranks
#
#  rank_id     :integer(2)      default(0), not null, primary key
#  rank_name   :string(50)      default(""), not null
#  rank_hide   :boolean(1)      not null
#  rank_prefix :string(75)      default(""), not null
#  rank_suffix :string(75)      default(""), not null
#

class LegacyMemberRank < ActiveRecord::Base
  set_table_name "mgdkp_member_ranks"
  set_primary_key "rank_id"
end
