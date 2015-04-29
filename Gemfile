source 'https://rubygems.org'

group :rails do
  gem 'rails', '~> 3.0.20'
  gem 'builder', '~> 2.1.2'
  gem 'dalli' #a Memcache client
  gem 'tzinfo', '~> 0.3.12'
  gem 'i18n', '0.5.0'
  gem 'tmail', '~> 1.2.3'
  gem 'text-format', git: 'git://github.com/ccarruitero/text-format.git'
end

#Temporary hack - Fix once this ticket: is resolved
#gem 'activesupport-i18n-patch', git: 'git://github.com/teambox/activesupport-i18n-patch.git'

gem 'nokogiri'
gem 'SystemTimer', '~> 1.2.0', require: 'system_timer', platform: :mri_18
gem 'whenever', '~> 0.4.1', require: nil
gem 'icalendar', '~> 1.1.3'
gem 'libxml-ruby'
gem 'rdiscount', '~> 1.6.3'
gem 'haml'
gem 'sass'
gem 'aws-s3', '~> 0.6.2', require: 'aws/s3'
gem 'hpricot', '~> 0.8.2'
gem 'json'
gem 'oa-oauth', require: 'omniauth/oauth'
gem 'net-ldap'
gem 'tilt'
gem 'choices', git: 'git://github.com/teambox/choices.git'

gem 'will_paginate', git: 'git://github.com/mislav/will_paginate.git', branch: 'rails3'
gem 'thinking-sphinx', require: 'thinking_sphinx'
gem 'sprockets-rails'
gem 'sprockets', '1.0.2'
gem 'barista', '~> 1.0'
gem 'vestal_versions', '~> 1.2.2', git: 'git://github.com/adamcooper/vestal_versions'
gem 'paperclip', '~> 2.7.5'
gem 'teambox-permalink_fu', require: 'permalink_fu'
gem 'cancan', '~> 1.4.1'
gem 'immortal', git: 'git://github.com/davidmm/immortal.git', branch: 'postgresql_fix'
gem 'rack-ssl-enforcer', require: 'rack/ssl-enforcer'
gem 'jammit'
gem 'rake', '0.9.2'
gem 'thin'


gem 'mysql2', '~> 0.2.0', group: 'mysql'
# gem 'mysql', '~> 2.8.1', :require => nil, :group => 'mysql'
gem 'pg', group: 'pg'
gem 'sqlite3', group: 'sqlite'

group :development do
  gem 'pry-rails'
  gem 'pry-debugger'
  gem 'better_errors'
  gem 'active_reload' # DEPRECATED
  gem 'guard-rspec', require: false
end

group :test, :development do
  gem 'rspec-rails', '~> 2.14.1'
  gem 'webrat'
  gem 'fuubar'
  gem 'faker', require: nil
  gem 'timecop', require: 'timecop'
  gem 'webmock'
end

group :test do
  gem 'codeclimate-test-reporter', require: nil
end

# we don't call the group :test because we don't want them auto-required
group :testing do
  gem 'database_cleaner', '~> 1.2.0'
  gem 'factory_girl', '~> 1.3.2'
  gem 'pickle', '~> 0.4.4'
  gem 'cucumber-rails', '~> 0.3.2', require: nil
  gem 'cucumber', '~> 0.10.0'
  gem 'headless', require: nil
  gem 'capybara', '~> 0.4.0'
  gem 'launchy', '~> 0.3.7'
end
gem 'faye-websocket', '~> 0.9.2'
