RailsAdmin.config do |config|
  config.authorize_with :cancan

  # config.actions do
  #   # root actions
  #   dashboard do
  #     statistics false
  #   end
  #   # collection actions
  #   index # mandatory
  #   new
  #   export
  #   history_index
  #   bulk_delete
  #   # member actions
  #   show
  #   edit
  #   delete
  #   history_show
  #   show_in_app
  #   nested_set do
  #     visible do
  #       %w(Page).include? bindings[:abstract_model].category
  #     end
  #   end
  # end

  config.model 'Organization' do
    weight -1

    list do
      field :name
      field :locations
      field :updated_at
    end

    edit do
      field :name
    end

    create do
      field :name
      field :locations do
        visible false
      end
    end
  end

  config.model 'Service' do
    weight -1

    list do
      #field :name
      field :location
      field :updated_at
    end

    edit do
      field :location do
        read_only true
      end
      field :name
      field :description
      # field :schedules do
      #   partial "open"
      # end
      field :schedules
      field :audience
      field :eligibility
      field :fees
      field :funding_sources
      field :how_to_apply
      field :service_areas
      field :urls
      field :wait

      field :keywords
      field :categories
    end
  end

  config.model 'Contact' do
    list do
      field :name
      field :title
      field :location
    end
  end

  config.model 'Location' do
    list do
      field :name
      field :organization
      field :kind
      field :updated_at
    end

    edit do
      field :organization do
        read_only true
      end
      field :name
      field :kind do
        partial "kind"
      end
      field :description, :text do
        html_attributes rows: 20, cols: 50
      end
      field :short_desc, :text
      field :address do
        help 'Location must have at least one address type'
      end
      field :mail_address do
        help 'Location must have at least one address type'
      end
      field :contacts
      field :hours
      field :ask_for
      field :emails
      field :faxes
      field :phones
      field :languages
      field :urls

      field :transportation
      field :accessibility do
        render do
          bindings[:form].select("accessibility",
            bindings[:object].accessibility_enum, {}, { :multiple => true })
        end
        #partial "checkbox"
      end

      # field :languages do
      #   render do
      #     bindings[:form].select("languages", bindings[:object].languages_enum, {}, { :multiple => true })
      #   end
      # end
    end
  end

  config.model 'Address' do
    object_label_method do
      :street
    end
  end

  config.model 'MailAddress' do
    object_label_method do
      :street
    end
  end

  config.model 'Category' do
    object_label_method do
      :name
    end
    list do
      field :name
    end
    edit do
      field :name
    end
  end

  config.model 'Schedule' do
    object_label_method do
      :day_name
    end
    edit do
      field :open do
        partial "open"
      end

      field :close do
        partial "close"
      end
    end
  end
end