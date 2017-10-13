task create_fake_org_categories: :environment do
  CreateFakeOrgCategories.new.create_orgs()
end
