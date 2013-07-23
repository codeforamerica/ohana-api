ActiveAdmin.register Language do
  belongs_to :location
  navigation_menu :location

  index do
    column :name
    default_actions
  end

  filter :name

  form do |f|
    f.inputs "Language" do
      f.input :name
    end
    f.actions
  end

  show :title => :name do
    panel "Language" do
      attributes_table_for language do
        row("Name") { language.name }
      end
    end
  end
end
