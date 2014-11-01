class Admin
  class OrganizationsController < ApplicationController
    before_action :authenticate_admin!
    layout 'admin'

    include Taggable

    def index
      @admin_decorator = AdminDecorator.new(current_admin)
      @all_orgs = @admin_decorator.orgs
      @orgs = Kaminari.paginate_array(@all_orgs).page(params[:page])

      respond_to do |format|
        format.html
        format.json do
          render json: @all_orgs.select { |org| org[1] =~ /#{params[:q]}/i }
        end
      end
    end

    def edit
      @admin_decorator = AdminDecorator.new(current_admin)
      @organization = Organization.find(params[:id])

      unless @admin_decorator.allowed_to_access_organization?(@organization)
        redirect_to admin_dashboard_path,
                    alert: "Sorry, you don't have access to that page."
      end
    end

    def update
      @organization = Organization.find(params[:id])

      shift_and_split_params(
        params[:organization], :accreditations, :funding_sources, :licenses)

      respond_to do |format|
        if @organization.update(params[:organization])
          format.html do
            redirect_to [:admin, @organization],
                        notice: 'Organization was successfully updated.'
          end
        else
          format.html { render :edit }
        end
      end
    end

    def new
      unless current_admin.super_admin?
        redirect_to admin_dashboard_path,
                    alert: "Sorry, you don't have access to that page."
      end

      @organization = Organization.new
    end

    def create
      shift_and_split_params(
        params[:organization], :accreditations, :funding_sources, :licenses)

      @organization = Organization.new(params[:organization])

      respond_to do |format|
        if @organization.save
          format.html do
            redirect_to admin_organizations_url,
                        notice: 'Organization was successfully created.'
          end
        else
          format.html { render :new }
        end
      end
    end

    def destroy
      organization = Organization.find(params[:id])
      organization.destroy
      respond_to do |format|
        format.html { redirect_to admin_organizations_path }
      end
    end

    def confirm_delete_organization
      @org_name = params[:org_name]
      @org_id = params[:org_id]
      respond_to do |format|
        format.html
        format.js
      end
    end
  end
end
