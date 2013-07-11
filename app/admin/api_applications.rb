ActiveAdmin.register ApiApplication do
  belongs_to :user
  navigation_menu :user

  form :partial => "form"

  index do
    column :name
    column :user

    column :main_url
    column :callback_url
    default_actions
  end

  filter :name, :as => :string

  # controller do
  #   def scoped_collection
  #     ApiApplication.includes(:user)
  #   end
  # end

  show :title => :name do
    panel "App Details" do
      attributes_table_for api_application do
        row("User") { link_to api_application.user.name, admin_user_path(api_application.user) }

        row("Name") { api_application.name }
        row("Main URL") { api_application.main_url }
        row("Callback URL") { api_application.callback_url }
      end
    end
  end
end
