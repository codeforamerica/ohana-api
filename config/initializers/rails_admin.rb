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
  # end

  config.model 'Organization' do
    weight -1

    list do
      field :name
      field :programs
    end

    edit do
      field :name
    end

    create do
      field :name
      field :programs do
        visible false
      end
    end
  end

  config.model 'Program' do
    weight -1

    list do
      field :name
      field :organization
    end

    edit do
      field :organization
      field :name
      field :description, :text do
        html_attributes rows: 20, cols: 50
      end
      field :short_desc, :text
      field :audience
      field :description
      field :eligibility
      field :fees
      field :how_to_apply
      field :funding_sources
      field :urls
    end
  end

  config.model 'Contact' do
    list do
      field :name
      field :title
      field :program
    end
  end

  config.model 'Location' do
    object_label_method do
      :full_address
    end

    list do
      field :full_address
      field :program
    end

    edit do
      field :program
      field :address do
        help 'Location must have at least one address type'
      end
      field :mail_address do
        help 'Location must have at least one address type'
      end
      field :hours
      field :wait
      field :transportation
      field :ask_for
      field :emails
      field :faxes
      field :phones
      field :service_areas
      field :keywords
      field :languages

      field :category

      # field :accessibility do
      #   render do
      #     bindings[:form].check_box("accessibility",
      #       bindings[:object].accessibility_enum, [], { :multiple => true })
      #   end
      #   #partial "checkbox"
      # end

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
    visible false
  end
end