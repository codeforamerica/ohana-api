task parse_data_to_csvs: :environment do
  ParseDataToCsvs.new.parse_csv()
end
