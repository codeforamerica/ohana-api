class Admin
  class OrganizationContactsController < ApplicationController
    before_action :authenticate_admin!
    layout 'admin'

    def edit
      @organization = Organization.find(params[:organization_id])
      @contact = Contact.find(params[:id])
      @admin_decorator = AdminDecorator.new(current_admin)

      unless @admin_decorator.allowed_to_access_organization?(@organization)
        redirect_to admin_dashboard_path,
                    alert: "Sorry, you don't have access to that page."
      end
    end

    def update
      @contact = Contact.find(params[:id])
      @organization = Organization.find(params[:organization_id])

      if @contact.update(params[:contact])
        flash[:notice] = 'Contact was successfully updated.'
        redirect_to [:admin, @organization, @contact]
      else
        render :edit
      end
    end

    def new
      @admin_decorator = AdminDecorator.new(current_admin)
      @organization = Organization.find(params[:organization_id])

      unless @admin_decorator.allowed_to_access_organization?(@organization)
        redirect_to admin_dashboard_path,
                    alert: "Sorry, you don't have access to that page."
      end

      @contact = Contact.new
    end

    def create
      @organization = Organization.find(params[:organization_id])
      @contact = @organization.contacts.new(params[:contact])

      if @contact.save
        flash[:notice] = "Contact '#{@contact.name}' was successfully created."
        redirect_to admin_organization_path(@organization)
      else
        render :new
      end
    end

    def destroy
      contact = Contact.find(params[:id])
      contact.destroy
      redirect_to admin_organization_path(contact.organization),
                  notice: "Contact '#{contact.name}' was successfully deleted."
    end
  end
end
