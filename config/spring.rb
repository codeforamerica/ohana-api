%w[
  .ruby-version
  .rbenv-vars
  tmp/restart.txt
  tmp/caching-dev.txt
  config/application.yml
  config/settings.yml
].each { |path| Spring.watch(path) }

Spring.watch_method = :listen
