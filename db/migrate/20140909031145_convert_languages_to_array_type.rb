class ConvertLanguagesToArrayType < ActiveRecord::Migration
  def up
    execute "drop index locations_languages"
    change_column :locations, :languages, "text[] USING (string_to_array(languages, '\n- '))", default: []
    add_index :locations, :languages, using: 'gin'

    Location.find_each do |loc|
      clean_langs = loc.languages.drop(1).map { |lang| lang.strip.gsub("\n", '') }
      loc.update!(languages: clean_langs)
    end
  end

  def down
    execute "drop index index_locations_on_languages"
    change_column :locations, :languages, "text USING (array_to_string(languages, ','))"

    Location.find_each do |loc|
      if loc.languages.blank?
        loc.update!(languages: "--- []\n")
      else
        loc.update!(languages: loc.languages.split(',').to_yaml)
      end
    end

    execute "create index locations_languages on locations using gin(to_tsvector('english', languages))"
  end
end
