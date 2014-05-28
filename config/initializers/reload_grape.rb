if Rails.env == 'development'
  api_files = Dir['#{Rails.root}/app/api/**/*.rb']
  api_reloader = ActiveSupport::FileUpdateChecker.new(api_files) do
    Rails.application.reload_routes!
  end

  ActionDispatch::Callbacks.to_prepare do
    api_reloader.execute_if_updated
  end
end
