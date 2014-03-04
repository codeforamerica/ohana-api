task :setup_smc_db do
  Rake::Task[:load_cip_data].invoke("data/smc_sample_data.json")
  Rake::Task[:load_farmers_markets].invoke
  Rake::Task[:create_categories].invoke
end

