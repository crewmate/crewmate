# -*- encoding : utf-8 -*-
Given /^there is a task called "([^\"]*)"$/ do |name|
  Task.find_by_name(name) || Factory(:task, :name => name)
end

Given /^I have a task called "([^\"]*)"$/ do |name|
  task_list = @task_list || Factory(:task_list)
  project = @current_project || Factory(:project)
  @task = project.create_task(@current_user, task_list, {:name => name})
end

## FIXME: it's better for 'givens' to set tasks up directly in the db:

Given /^the following tasks? with associations exists?:?$/ do |table|
  table.hashes.each do |hash|
    Factory(:task,
      :name      => hash[:name],
      :task_list => TaskList.find_by_name(hash[:task_list]),
      :project   => Project.find_by_name(hash[:project])
    )
  end
end

Given /^the following tasks? with hours exists?:?$/ do |table|
  table.hashes.each do |hash|
    Factory(:task,
      :name      => hash[:name],
      :task_list => TaskList.find_by_name(hash[:task_list]),
      :project   => Project.find_by_name(hash[:project]),
      :user      => @current_user
    ).comments.create :body => hash[:comment], :human_hours => hash[:hours]
  end
end

Given /^the task called "([^\"]*)" belongs to the task list called "([^\"]*)"$/ do |task_name, task_list_name|
  step %(there is a task called "#{task_name}")
  step %(there is a task list called "#{task_list_name}")
  task_list = TaskList.find_by_name(task_list_name)
  Task.find_by_name(task_name).update_attribute(:task_list, task_list)
end

Given /^the task called "([^\"]*)" belongs to the project called "([^\"]*)"$/ do |task_name, project_name|
  step %(there is a task called "#{task_name}")
  step %(there is a project called "#{project_name}")
  project = Project.find_by_name(project_name)
  Task.find_by_name(task_name).update_attribute(:project, project)
end

Given /^the task called "([^\"]*)" is due today$/ do |name|
  step %(there is a task called "#{name}")
  Task.find_by_name(name).update_attribute(:due_on, Date.today)
end

Given /^the task called "([^\"]*)" was due (\d+) days ago$/ do |name, days_ago|
  step %(there is a task called "#{name}")
  Task.find_by_name(name).update_attribute(:due_on, Date.today - days_ago.to_i)
end

Given /^the task called "([^\"]*)" is due tomorrow$/ do |name|
  step %(there is a task called "#{name}")
  Task.find_by_name(name).update_attribute(:due_on, Date.tomorrow)
end

Given /^the task called "([^\"]*)" is due in (\d+) days?$/ do |name, in_days|
  step %(there is a task called "#{name}")
  Task.find_by_name(name).update_attribute(:due_on, Date.today + in_days.to_i)
end

Given /^the task called "([^\"]*)" does not have a due date$/ do |name|
  step %(there is a task called "#{name}")
  Task.find_by_name(name).update_attribute(:due_on, nil)
end

Given /^the task called "([^\"]*)" is assigned to me$/ do |name|
  step %(there is a task called "#{name}")
  task = Task.find_by_name(name)
  task.project.add_user(@current_user)
  task.assign_to(@current_user)
end

Given /^the task called "([^\"]*)" is assigned to "([^\"]*)"$/ do |task_name, login|
  step %(there is a task called "#{task_name}")
  task = Task.find_by_name(task_name)
  user = User.find_by_login(login)
  task.project.add_user(user)
  task.assign_to(user)
end

Given /^I have no tasks assigned to me$/ do
  @current_user.assigned_tasks.destroy_all
end

Given /^the task called "([^\"]*)" is (new|hold|open|resolved|rejected)(?:ed)?$/ do |name, status|
  Task.find_by_name(name).update_attribute(:status, Task::STATUSES[status.to_sym])
end

Then /^I should( not)? see the task called "([^\"]*)" in the "([^\"]*)" task list$/ do |negative, task_name, task_list_name|
  task_list = TaskList.find_by_name!(task_list_name)
  project = task_list.project
  step %(I should#{negative} see "#{task_name}" within "#project_#{project.id}_task_list_#{task_list.id}_the_main_tasks")
end

Then /^I should see the following tasks:$/ do |table|
  table.hashes.each do |hash|
    step %(I should see the task called "#{hash['task_name']}" in the "#{hash['task_list_name']}" task list)
  end
end

Then /^I should not see the following tasks:$/ do |table|
  table.hashes.each do |hash|
    step %(I should not see the task called "#{hash['task_name']}" in the "#{hash['task_list_name']}" task list)
  end
end

Then /^I should see the task "([^\"]*)" before "([^\"]*)"$/ do |task1, task2|
  Task.find_by_name(task1).position.should < Task.find_by_name(task2).position
end

Then /^I fill the task comment box with "([^\"]*)"$/ do |text|
  step %(I fill in "task[comments_attributes][0][body]" with "#{text}")
end

Then /^I click on the date selector$/ do
  find('.actions .localized_date').click
end

Then /^I select the month of "([^\"]*)" with the(?: ([^\"]*))? date picker$/ do |month,type|
  type = type.try(:strip).blank? ? 'task' : type.strip
  step %(I select "#{month}" from "#{type}_due_on_month" within "div[class='calendar_date_select']")
end

Then /^I select the year "([^\"]*)" with the(?: ([^\"]*))? date picker$/ do |year,type|
  type = type.try(:strip).blank? ? 'task' : type.strip
  step %(I select "#{year}" from "#{type}_due_on_year" within "div[class='calendar_date_select']")
end

Then /^I select the day "([^\"]*)" with the date picker$/ do |day|
  with_css_scope("div[class='calendar_date_select']") do |node|
    element = node.all(:xpath, "//td/div[contains(., '#{day}')]").detect do |e|
      !e[:class].to_s.include?('other')
    end
    element.click
  end
end

Then /^I should see "([^\"]*)"(?: and "([^\"]*)")? within the last comment body$/ do |text1, text2|
  comment = all("div.comments .body").last.text
  comment.should match(/#{text1}/)
  comment.should match(/#{text2}/) if text2.present?
end

Then /^I fill the name field with "([^"]*)"$/ do |name|
  step %(I fill in "task_name" with "#{name}")
end

Then /^I should see "([^"]*)" within the task header$/ do |text|
  step %(I should see "#{text}" within ".task_header h2")
end

When /^(?:|I )select "([^\"]*)" in the "([^\"]*)" calender?$/ do |number, calender|
  with_css_scope("div[id$='_#{calender}_on']") do |node|
    node.find("table div", :text => number).click
  end
end

Then /^(?:|I )should see "([^\"]*)" status change?$/ do |text|
  page.should have_content(text)
end

Then /^I should see "([^\"]+)" in the task thread title$/ do |msg|
  with_scope('.thread[data-class=task] p.thread_title') do
    first(:link).should have_content(/#{msg}/)
  end
end
