class Admin
  class ContactsController < ApplicationController
    before_action :authenticate_admin!
    layout 'admin'

    def edit
      @location = Location.find(params[:location_id])
      @contact = Contact.find(params[:id])
      @admin_decorator = AdminDecorator.new(current_admin)

      unless @admin_decorator.allowed_to_access_location?(@location)
        redirect_to admin_dashboard_path,
                    alert: "Sorry, you don't have access to that page."
      end
    end

    def update
      @contact = Contact.find(params[:id])
      @location = Location.find(params[:location_id])

      respond_to do |format|
        if @contact.update(params[:contact])
          format.html do
            redirect_to [:admin, @location, @contact],
                        notice: 'Contact was successfully updated.'
          end
        else
          format.html { render :edit }
        end
      end
    end

    def new
      @admin_decorator = AdminDecorator.new(current_admin)
      @location = Location.find(params[:location_id])

      unless @admin_decorator.allowed_to_access_location?(@location)
        redirect_to admin_dashboard_path,
                    alert: "Sorry, you don't have access to that page."
      end

      @contact = Contact.new
    end

    def create
      @location = Location.find(params[:location_id])
      @contact = @location.contacts.new(params[:contact])

      respond_to do |format|
        if @contact.save
          format.html do
            redirect_to admin_location_path(@location),
                        notice: "Contact '#{@contact.name}' was successfully created."
          end
        else
          format.html { render :new }
        end
      end
    end

    def destroy
      contact = Contact.find(params[:id])
      contact.destroy
      respond_to do |format|
        format.html do
          redirect_to admin_location_path(contact.location),
                      notice: "Contact '#{contact.name}' was successfully deleted."
        end
      end
    end
  end
end
