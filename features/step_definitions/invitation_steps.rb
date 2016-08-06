# -*- encoding : utf-8 -*-
When /^"([^\"]*)" accepts the invitation from "([^\"]*)"$/ do |username,email|
  step %(I log out)
  step %(I am logged in as #{username})
  open_email(email)
  step %(I follow "Accept the invitation to start collaborating" in the email)
  step %(I press "Accept")
end
