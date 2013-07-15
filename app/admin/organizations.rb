ActiveAdmin.register Organization do
  index do
    column :name
    column :agency
    column :street_address
    column :city
    column :keywords
    column :updated_at
    column "" do |organization|
      links = ''.html_safe
      links += link_to I18n.t('active_admin.view'), admin_organization_path(organization), :class => "member_link view_link"
      links += link_to I18n.t('active_admin.edit'), edit_admin_organization_path(organization), :class => "member_link edit_link"
      links
    end
  end

  filter :name
  filter :agency
  filter :street_address
  filter :city
  filter :keywords, :as => :string

  #form :partial => "form"
  form do |f|
    f.inputs "Organization Details" do
      f.input :agency
      f.input :city
      f.input :description
      f.input :eligibility_requirements
      f.input :fees
      f.input :how_to_apply
      f.input :name
      f.input :service_hours
      f.input :service_wait
      f.input :services_provided
      f.input :street_address
      f.input :target_group
      f.input :transportation_availability
      f.input :zipcode
    end
    f.actions
  end

end
