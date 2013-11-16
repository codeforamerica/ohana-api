Tire.configure do
  url ENV['ELASTICSEARCH_URL']
  ## Uncomment the line below to debug Elasticsearch errors
  #logger 'elasticsearch.log', :level => 'debug'
end

# This is required to be able to run tests using a separate
# index. This allows you to create a unique index per environment.
app_env = Rails.env.downcase
app_name = Rails.application.class.parent_name.underscore.downcase
INDEX_NAME = "#{app_env}-#{app_name}"