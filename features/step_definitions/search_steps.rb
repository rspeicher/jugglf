# When I search for "Tsigo"
# When I search for "Tsigo" in "members"
# When I search for "Tsigo" in "members" as json
When /^I search for "([^\"]+)"(?: in "([^\"]+)")?(?: as (html|xml|json|js|lua))?$/ do |query, context, format|
  format ||= 'html'
  visit search_path(:q => query, :context => context, :format => format)
end
