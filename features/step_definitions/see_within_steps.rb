# -*- encoding : utf-8 -*-
{
  'in the title'         => 'h2',
  'in the watchers list' => '.watching',
  'as a button'          => 'a.button, button',
  'in the preview'       => '.previewBox'
}.
each do |within, selector|
  Then /^(?:|I )should( not)? see "([^\"]*)" #{within}$/ do |negate, text|
    with_scope(selector) do
      if page.html.present?
        negate ? page.should(have_no_content(text)) : page.should(have_content(text))
      else
        step %(I should#{negate} see "#{text}")
      end
    end
  end
end

Then /^I should see an error message: "([^\"]*)"$/ do |text|
  with_scope('.flash-error') do
    step %(I should see "#{text}")
  end
end

Then /^I should see a notice: "([^\"]*)"$/ do |text|
  with_scope('.flash-notice') do
    step %(I should see "#{text}")
  end
end
