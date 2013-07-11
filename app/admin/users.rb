ActiveAdmin.register User do

  index do
    column :name
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    column "Link to API Applications" do |user|
      link_to "API Applications", admin_user_api_applications_path(user)
    end
    default_actions
  end

  filter :email
  filter :name

  # sidebar "Link to all Applications", :only => :show do
  #   link_to "API Applications", admin_user_api_applications_path(user)
  # end

  show :title => :name do |user|
    attributes_table do
      row :name
      row :email
    end

    panel "API Applications" do
      table_for user.api_applications do |t|
        t.column("Name") do |api_application|
          link_to api_application.name,
            admin_user_api_application_path(user, api_application)
        end
        t.column("Main URL") { |api_application| api_application.main_url }
        t.column("Callback URL") { |api_application| api_application.callback_url }
      end
    end
  end

  form do |f|
    f.inputs "User Details" do
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
