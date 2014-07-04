RSpec.configure do |config|

  config.before(:each) do
    Bullet.start_request if Bullet.enable?
  end

  config.after(:each) do
    Bullet.end_request if Bullet.enable?
  end
end
