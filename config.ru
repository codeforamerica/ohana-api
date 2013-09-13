# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

NewRelic::Agent.manual_start

run OhanaApi::Application
