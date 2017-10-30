task create_real_addresses_for_fake_orgs: :environment do
  CreateRealAddressesForFakeOrgs.new.magic()
end
