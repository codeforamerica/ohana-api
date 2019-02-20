class Admin
  class OrganizationsController < ApplicationController
    before_action :authenticate_admin!
    layout 'admin'

    include Taggable

    def index
      @all_orgs = policy_scope(fitler_organizations)
      @orgs = Kaminari.paginate_array(@all_orgs).page(params[:page])

      respond_to do |format|
        format.html
        format.json do
          render json: @all_orgs.select { |org| org[1] =~ /#{params[:q]}/i }
        end
      end
    end

    def show
      @organization = Organization.find(params[:id])
    end

    def edit
      @organization = Organization.find(params[:id])

      authorize @organization
    end

    def update
      @organization = Organization.find(params[:id])

      preprocess_organization_params

      if @organization.update(params[:organization])
        check_approval_status
        redirect_to [:admin, @organization],
                    notice: 'Organization was successfully updated.'
      else
        render :edit
      end
    end

    def new
      @organization = Organization.new
      authorize @organization
    end

    def create
      preprocess_organization_params

      @organization = Organization.new(params[:organization])

      if @organization.save
        redirect_to admin_organizations_url,
                    notice: 'Organization was successfully created.'
      else
        render :new
      end
    end

    def destroy
      organization = Organization.find(params[:id])
      organization.destroy
      redirect_to admin_organizations_path
    end

    private

    def preprocess_organization_params
      shift_and_split_params(params[:organization], :accreditations, :licenses)
    end

    def fitler_organizations
      organizations = Organization.all
      if params[:filter_by_approval_status].present? && params[:filter_by_approval_status] != 'all'
        organizations = organizations.where(approval_status: params[:filter_by_approval_status])
      end

      if params[:filter_by_published].present? && params[:filter_by_published] != 'all'
        organizations = organizations.where(is_published: params[:filter_by_published])
      end

      organizations
    end

    def check_approval_status
      if @organization.approval_status == 'approved'
        OrganizationApprovementMailer.notify(@organization).deliver_now
      end
    end
  end
end
