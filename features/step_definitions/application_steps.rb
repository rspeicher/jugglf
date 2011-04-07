# web_steps extensions

Then /^(?:|I )should (not )?see "([^"]*)" within a table header$/ do |negative, text|
  if negative
    find(:xpath, "//th[contains(text(),'#{text}')]").should(be_nil, "Expected not to find '#{text}' within the selector 'th', but did'")
  else
    find(:xpath, "//th[contains(text(),'#{text}')]").should_not(be_nil, "Could not find the text '#{text}' within the selector 'th'")
  end
end

# When I fill in "Attendance" with:
#   """
#   Stuff
#   Goes
#   Here
#   """
When /^(?:|I )fill in "([^"]*)"(?: within "([^"]*)")? with:$/ do |field, selector, value|
  with_scope(selector) do
    fill_in(field, :with => value)
  end
end

# Authentication steps

# Given I am logged in as an admin
# Given I am logged in as a user
# Given I am logged in as a user with an associated member
# Given I am logged in as a guest
# Given I am not logged in
Given /^I am (not )?logged in(?: as an? (\w+))?( with an associated member)?$/ do |negative, user, association|
  if negative
    # logout?
  else
    unless user == :guest
      user = Factory.create(user)
      Factory(:member, :user => user) if association

      visit login_path
      fill_in 'Username', :with => user.name
      fill_in 'Password', :with => 'password'
      click_button 'Sign In'
    end
  end
end

# ItemPrice steps

When /^(?:|I )?expect the following item prices?:$/ do |table|
  @expected = table
  @prices   = []

  table.hashes.each do |hash|
    args = hash.symbolize_keys.reject! { |k, v| k == :price }
    @prices << ItemPrice.instance.price(args)
  end
end

Then /^(?:|I )?should receive the correct prices?$/ do
  @expected.hashes.each_with_index do |hash, i|
    if @prices[i] != hash['price'].to_f
      fail "Expected price for #{hash.inspect} to be #{hash['price']} but was #{@prices[i]}"
    end
  end
end

# Search Steps

# When I search for "Tsigo"
# When I search for "Tsigo" in "members"
# When I search for "Tsigo" in "members" as json
When /^I search for "([^\"]+)"(?: in "([^\"]+)")?(?: as (html|xml|json|js|lua))?$/ do |query, context, format|
  format ||= 'html'
  visit search_path(:q => query, :context => context, :format => format)
end
