ActiveAdmin.register Organization do
  index do
    selectable_column
    column :name
    column :updated_at
    column "Link to Locations" do |organization|
      link_to "Locations", admin_organization_locations_path(organization)
    end
    # column "" do |organization|
    #   links = ''.html_safe
    #   links += link_to I18n.t('active_admin.view'), admin_organization_path(organization), :class => "member_link view_link"
    #   links += link_to I18n.t('active_admin.edit'), edit_admin_organization_path(organization), :class => "member_link edit_link"
    #   links
    # end
    default_actions
  end

  filter :name

  show :title => :name do |organization|
    attributes_table do
      row :name
      row :description
      row :funding_sources
      row :_keywords
    end

    panel "Locations" do
      table_for organization.locations do |t|
        t.column("Name") do |location|
          link_to location.name,
            admin_organization_location_path(organization, location)
        end
      end
    end
  end

  form :partial => "form"
  # form do |f|
  #   f.inputs "Organization Details" do
  #     f.input :name
  #     f.input :description
  #   end

  #   # f.inputs "URLS" do
  #   #   organization.urls.each do |url|
  #   #     #text_field_tag "organization[urls][]", url
  #   #     f.input :urls, :name => "organization[urls][]", :input_html => { :value => url }
  #   #   end
  #   # end
  #   f.actions
  # end

end
