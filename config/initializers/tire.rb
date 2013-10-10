Tire.configure do
  url ENV['BONSAI_URL']
end

# This is required to be able to run tests using a separate
# index. This allows you to create a unique index per environment.
app_env = Rails.env.downcase
app_name = Rails.application.class.parent_name.underscore.downcase
INDEX_NAME = "#{app_env}-#{app_name}"