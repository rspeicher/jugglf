Factory.define :member_rank do |f|
  f.prefix '<b>'
  f.suffix '</b>'
  f.name 'Rank'
end

Factory.define :declined_applicant_rank, :parent => :member_rank do |f|
  f.name 'Declined Applicant'
end