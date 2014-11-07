class Admin
  class ServiceContactsController < ApplicationController
    before_action :authenticate_admin!
    layout 'admin'

    def edit
      @service = Service.find(params[:service_id])
      @contact = Contact.find(params[:id])
      @admin_decorator = AdminDecorator.new(current_admin)

      unless @admin_decorator.allowed_to_access_location?(@service.location)
        redirect_to admin_dashboard_path,
                    alert: "Sorry, you don't have access to that page."
      end
    end

    def update
      @contact = Contact.find(params[:id])
      @service = Service.find(params[:service_id])

      if @contact.update(params[:contact])
        flash[:notice] = 'Contact was successfully updated.'
        redirect_to [:admin, @service.location, @service, @contact]
      else
        render :edit
      end
    end

    def new
      @admin_decorator = AdminDecorator.new(current_admin)
      @service = Service.find(params[:service_id])

      unless @admin_decorator.allowed_to_access_location?(@service.location)
        redirect_to admin_dashboard_path,
                    alert: "Sorry, you don't have access to that page."
      end

      @contact = Contact.new
    end

    def create
      @service = Service.find(params[:service_id])
      @contact = @service.contacts.new(params[:contact])

      if @contact.save
        flash[:notice] = "Contact '#{@contact.name}' was successfully created."
        redirect_to admin_location_service_path(@service.location, @service)
      else
        render :new
      end
    end

    def destroy
      contact = Contact.find(params[:id])
      contact.destroy
      redirect_to admin_location_service_path(contact.service.location, contact.service),
                  notice: "Contact '#{contact.name}' was successfully deleted."
    end
  end
end
