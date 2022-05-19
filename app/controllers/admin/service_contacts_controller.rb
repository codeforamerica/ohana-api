class Admin
  class ServiceContactsController < ApplicationController
    before_action :authenticate_admin!
    layout 'admin'

    def edit
      @service = service_from_params
      @contact = Contact.find(params[:id])

      authorize @service.location
    end

    def update
      @contact = Contact.find(params[:id])
      @service = service_from_params
      location = @service.location

      authorize location

      if @contact.update(contact_params)
        flash[:notice] = t('admin.notices.contact_updated')
        redirect_to [:admin, location, @service, @contact]
      else
        render :edit
      end
    end

    def new
      @service = service_from_params

      authorize @service.location

      @contact = Contact.new
    end

    def create
      @service = service_from_params
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

    def service_from_params
      Service.find(params[:service_id])
    end
  end
end
