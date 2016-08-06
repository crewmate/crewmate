# -*- encoding : utf-8 -*-
Then /^I should see the project "([^\"]*)"$/ do |project_name|
  step %(I should see "#{project_name}" within "#my_projects")
end

Then /^I should see the task "([^\"]*)" in the sidebar$/ do |task_name|
  step %(I should see "#{task_name}" within "#my_tasks")
end

Then /^I should see the organization "([^\"]*)" in the sidebar$/ do |organization_name|
  step %(I should see "#{organization_name}" within "#my_organizations")
end

When /^I follow "([^\"]*)" in the sidebar$/ do |link|
  step %(I follow "#{link}" within "#column")
end
