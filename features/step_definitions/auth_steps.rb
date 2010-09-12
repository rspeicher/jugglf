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
