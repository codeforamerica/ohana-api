ActiveAdmin.register Location do
  belongs_to :organization

  navigation_menu :organization

  index do
    column :name
    column :street
    column :city
    default_actions
  end

  filter :name
  filter :street
  filter :city
  filter :keywords, :as => :string

  form do |f|
    f.inputs "Location Details" do
      f.input :name
      f.input :description
      f.input :hours
    end
    f.inputs "Address" do
      f.input :street
      f.input :po_box
      f.input :city
      f.input :zipcode
    end
    f.inputs "Languages" do
      f.input :languages, :as => :check_boxes
    end
    f.actions
  end

  # The create and update actions need to be modified so
  # that the Organization's _keywords field gets updated.
  # I think this is a bug with the mongoid_search gem which I've
  # reported here: https://github.com/mauriciozaffari/mongoid_search/issues/65
  controller do
    def create
      @organization = Organization.find(params[:organization_id])
      @location = @organization.locations.new(params[:location])
      if @location.save
        @location.organization.save
        redirect_to admin_organization_location_path(@organization, @location)
      else
        render :new
      end
    end

    def update
      @organization = Organization.find(params[:organization_id])
      @location = @organization.locations.find(params[:id])
      if @location.update_attributes(params[:location])
        @location.organization.save
        redirect_to admin_organization_location_path(@organization, @location)
      else
        render :edit
      end
    end
  end

  show :title => :name do
    panel "Location Details" do
      attributes_table_for location do
        row("Organization") { link_to location.organization.name, admin_organization_path(location.organization) }
        row("Description") { location.description }
        row("Name") { location.name }
        row("Street Address") { location.street }
        row("P.O. Box") { location.po_box }
        row("City") { location.city }
        row("Zipcode") { location.zipcode }
        row("Phones") { location.phones }
        row("Faxes") { location.faxes }
        row("Emails") { location.emails }
        row("Hours") { location.hours }
        row("Keywords") { location.keywords }
        row("URLs") { location.urls }
        row("Languages") do
          location.languages.order_by(:name => :asc).each {
            |l| li l.name.capitalize }
        end
      end
    end
    #panel "Languages" do
      # table_for location.languages do |t|
      #   t.column("") { |language| language.name.capitalize }
      # end
    #end
  end
end