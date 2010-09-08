# Given I am logged in as an administrator
# Given I am logged in as a user
# Given I am logged in as a guest
# Given I am not logged in
Given /^I am (not )?logged in(?: as an? (.+))?$/ do |negative, user|
  if negative
    # logout?
  else
    unless user == :guest
      user = Factory.create(user)

      visit login_path
      fill_in 'Username', :with => user.name
      fill_in 'Password', :with => 'password'
      click_button 'Sign In'
    end
  end
end
