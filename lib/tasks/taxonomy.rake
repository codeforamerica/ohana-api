require 'csv'

task oe_csv: :environment do
  Kernel.puts 'Creating taxonomy.csv based on Open Eligibility...'

  json ||= JSON.parse(File.read('data/oe.json'))

  top_levels ||= json['taxonomy']['top_level']

  CSV.open(
    'data/taxonomy.csv',
    'w',
    write_headers: true,
    headers: %w(taxonomy_id name parent_id parent_name)
  ) do |writer|
    top_levels.each do |hash|
      writer << [hash['@id'], hash['@title'], nil, nil]
      hash['second_level'].each do |h|
        writer << [h['@id'], h['@title'], hash['@id'], hash['@title']]
        next if h['third_level'].nil?
        h['third_level'].each do |i|
          writer << [i['@id'], i['@title'], h['@id'], h['@title']]
          next if i['fourth_level'].nil?
          i['fourth_level'].each do |j|
            writer << [j['@id'], j['@title'], i['@id'], i['@title']]
          end
        end
      end
    end
  end
end
