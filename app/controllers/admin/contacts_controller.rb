class Admin
  class ContactsController < ApplicationController
    before_action :authenticate_admin!
    layout 'admin'

    def edit
      @location = Location.find(params[:location_id])
      @contact = Contact.find(params[:id])

      authorize @location
    end

    def update
      @contact = Contact.find(params[:id])
      @location = Location.find(params[:location_id])

      authorize @location

      if @contact.update(contact_params)
        flash[:notice] = 'Contact was successfully updated.'
        redirect_to [:admin, @location, @contact]
      else
        render :edit
      end
    end

    def new
      @location = Location.find(params[:location_id])

      authorize @location

      @contact = Contact.new
    end

    def create
      @location = Location.find(params[:location_id])
      @contact = @location.contacts.new(contact_params)

      authorize @location

      if @contact.save
        flash[:notice] = "Contact '#{@contact.name}' was successfully created."
        redirect_to admin_location_url(@location)
      else
        render :new
      end
    end

    def destroy
      contact = Contact.find(params[:id])
      location = contact.location

      authorize location

      contact.destroy
      redirect_to admin_location_url(location),
                  notice: "Contact '#{contact.name}' was successfully deleted."
    end

    private

    def contact_params
      params.require(:contact).permit(
        :department, :email, :name, :title,
        phones_attributes: %i[
          country_prefix department extension number number_type
          vanity_number id _destroy
        ]
      )
    end
  end
end
