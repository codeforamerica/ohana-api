class Admin
  class ServiceContactsController < ApplicationController
    before_action :authenticate_admin!
    layout 'admin'

    def edit
      @service = Service.find(params[:service_id])
      @contact = Contact.find(params[:id])

      authorize @service.location
    end

    def update
      @contact = Contact.find(params[:id])
      @service = Service.find(params[:service_id])
      location = @service.location

      authorize location

      if @contact.update(contact_params)
        flash[:notice] = 'Contact was successfully updated.'
        redirect_to [:admin, location, @service, @contact]
      else
        render :edit
      end
    end

    def new
      @service = Service.find(params[:service_id])

      authorize @service.location

      @contact = Contact.new
    end

    def create
      @service = Service.find(params[:service_id])
      @contact = @service.contacts.new(contact_params)
      location = @service.location

      authorize location

      if @contact.save
        redirect_to admin_location_service_url(location, @service),
                    notice: "Contact '#{@contact.name}' was successfully created."
      else
        render :new
      end
    end

    def destroy
      contact = Contact.find(params[:id])
      service = contact.service
      location = service.location

      authorize location

      contact.destroy
      redirect_to admin_location_service_url(location, service),
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
