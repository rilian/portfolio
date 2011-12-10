ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(Rails)
require 'rspec/rails'
#require 'devise/test_helpers'
#require 'paperclip/matchers'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
Dir[Rails.root.join("spec/examples/**/*.rb")].each {|f| require f}

RSpec.configure do |config|

  #config.include Devise::TestHelpers, :type => :controller
  #config.include Paperclip::Shoulda::Matchers

  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.before(:all) do
    #
  end

  config.after(:all) do
    ActiveRecord::Base.connection.tables.collect{|t| t.classify.constantize rescue nil }.compact.map(&:delete_all)
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  #config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, comment the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false
end

#Resque.inline = true

# Paperclip processing
# Took here: http://www.jstorimer.com/ruby/2010/01/05/speep-up-your-paperclip-tests.html
#class Footage::Image
#  before_post_process do |file|
#    false # halts processing
#  end
#end
#
#class Footage::Video
#  before_post_process do |file|
#    false # halts processing
#  end
#end

#def authenticate_user
#  @user = Factory(:admin_user)
#  @user.stub!(:disabled?).and_return(false)
#  @user.stub!(:sign_in_count).and_return(0)
#  @user.stub!(:sign_in_count=)
#  @user.stub!(:authentication_token).and_return('123qwe')
#  controller.sign_in(@user)
#end

#def admin_sign_in
#  sign_in Factory(:user, :admin => true, :password => "123456")
#end

#def file_hash(suffix)
#  {:file => File.new("#{Rails.root}/test/assets/file.#{suffix.to_s}")}
#end
