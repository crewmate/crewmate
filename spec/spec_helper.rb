# -*- encoding : utf-8 -*-
if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

require File.expand_path('../factories', __FILE__)

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

require 'email_spec/helpers'
require 'email_spec/matchers'
require 'cancan/matchers'
require 'database_cleaner'
require 'webmock/rspec'
# require 'rack/test'
require 'csv'

WebMock.disable_net_connect!(:allow => 'codeclimate.com')

RSpec.configure do |config|
  config.include AuthenticatedTestHelper
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers
  # config.include Rack::Test::Methods

  config.fixture_path = Rails.root + '/spec/fixtures/'

  # == Focus
  # Run only focus specs when specified
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  # == Database cleaner
  database_adapter = ActiveRecord::Base.connection.adapter_name.downcase.to_sym

  config.before(:suite) do
    DatabaseCleaner.strategy = database_adapter.eql?(:sqlite) ? :truncation : :transaction
    DatabaseCleaner.clean_with :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"
  #
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  #
  # == Notes
  #
  # For more information take a look at Spec::Runner::Configuration and Spec::Runner
end

# FIXME: this should be a shared example
def route_matches(path, method, params)
  it "is routable for params #{params.inspect} with #{method.to_s.upcase} and #{path.inspect}" do
    { method.to_sym => path }.should route_to(params)
  end
end

def generate_file(filename, size = 1024)
  File.open(filename,"wb") { |f| f.seek(size-1); f.write("\0") }
end

def mock_uploader(file, type = 'image/png', data=nil)
  file_path = data ? file : "%s/%s" % [ File.dirname(__FILE__), file ]
  tempfile = Tempfile.new(file_path)
  if data
    tempfile << data
  else
    tempfile << File.read(file_path)
  end
  tempfile.seek(0)
  ActionDispatch::Http::UploadedFile.new({ :type => type, :filename => file_path, :tempfile => tempfile })
end

def mock_file(user, page=nil)
  @project.uploads.new(mock_file_params).tap do |page_upload|
    page_upload.page = page
    page_upload.user = user
    page_upload.save!
  end
end

def mock_file_params
  {:asset => mock_uploader("#{rand}.js", 'application/javascript', "1/0")}
end

def upload_file(name, type)
  Rack::Test::UploadedFile.new(name, type)
end

def make_a_typical_project
    @user = Factory.create(:confirmed_user)
    @project = Factory.create(:project)
    @organization = @project.organization
    @organization.add_member(@user, Membership::ROLES[:participant])
    @owner = @project.user
    @project.add_user(@user)
    @observer = Factory.create(:confirmed_user)
    @organization.add_member(@observer, Membership::ROLES[:participant])
    @project.add_user(@observer, :role => Person::ROLES[:observer])
    @admin = Factory.create(:confirmed_user)
    @organization.add_member(@admin, Membership::ROLES[:admin])
    @project.add_user(@admin, :role => Person::ROLES[:admin])
    @project
end

def make_the_crewmate_dump
  @project = Factory(:project)
  @task_list = Factory(:task_list, :project => @project)
  @conversation = Factory(:conversation, :project => @project)
  @task = Factory(:task, :task_list_id => @task_list.id, :project => @project)
end

def make_and_dump_the_crewmate_dump
  make_the_crewmate_dump
  @crewmate_dump = dump_test_data

  @user_list = User.all.map(&:login)

  Organization.destroy_all
  User.destroy_all
  Project.destroy_all
end

def decode_test_csv(body)
  CSV.parse(body)
end

def dump_test_data
  ActiveSupport::JSON.decode(ActiveSupport::JSON.encode(CrewmateData.new.serialize(Organization.all, Project.all, User.all)))
end

# Backwards compatibility fix: this way we can use it in subject blocks
def description
  self.example.description
end

# RAILS3 document this for rack-test
def app
  Rails.application
end
