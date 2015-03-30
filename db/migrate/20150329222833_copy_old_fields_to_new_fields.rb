class CopyOldFieldsToNewFields < ActiveRecord::Migration
  def up
    execute 'update addresses set address_1 = street_1'
    execute 'update addresses set address_2 = street_2'
    execute 'update addresses set country = country_code'

    execute 'update mail_addresses set address_1 = street_1'
    execute 'update mail_addresses set address_2 = street_2'
    execute 'update mail_addresses set country = country_code'

    execute 'update services set application_process = how_to_apply'
  end

  def down
    execute 'update addresses set street_1 = address_1'
    execute 'update addresses set street_2 = address_2'
    execute 'update addresses set country_code = country'

    execute 'update mail_addresses set street_1 = address_1'
    execute 'update mail_addresses set street_2 = address_2'
    execute 'update mail_addresses set country_code = country'

    execute 'update services set how_to_apply = application_process'
  end
end
