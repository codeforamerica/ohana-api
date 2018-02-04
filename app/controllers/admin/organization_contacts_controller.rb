class Admin
  class OrganizationContactsController < ApplicationController
    before_action :authenticate_admin!
    layout 'admin'

    def edit
      @organization = Organization.find(params[:organization_id])
      @contact = Contact.find(params[:id])

      authorize @contact
    end

    def update
      @contact = Contact.find(params[:id])
      @organization = Organization.find(params[:organization_id])

      authorize @contact

      if @contact.update(contact_params)
        flash[:notice] = 'Contact was successfully updated.'
        redirect_to [:admin, @organization, @contact]
      else
        render :edit
      end
    end

    def new
      @organization = Organization.find(params[:organization_id])

      authorize @organization

      @contact = Contact.new
    end

    def create
      @organization = Organization.find(params[:organization_id])
      @contact = @organization.contacts.new(contact_params)

      authorize @contact

      if @contact.save
        flash[:notice] = "Contact '#{@contact.name}' was successfully created."
        redirect_to admin_organization_url(@organization)
      else
        render :new
      end
    end

    def destroy
      contact = Contact.find(params[:id])
      authorize contact

      contact.destroy
      redirect_to admin_organization_url(contact.organization),
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
