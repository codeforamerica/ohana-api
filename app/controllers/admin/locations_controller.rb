class Admin
  class LocationsController < ApplicationController
    before_action :authenticate_admin!
    layout 'admin'

    def index
      if current_admin.super_admin?
        @locations = Location.page(params[:page]).per(params[:per_page]).
                             order('created_at DESC')
      else
        @locations = perform_search
        @org = @locations.includes(:organization).first.organization if @locations.present?
      end
    end

    def new
      @location = Location.new
    end

    def edit
      @location = Location.find(params[:id])
    end

    def update
      @location = Location.find(params[:id])

      respond_to do |format|
        if @location.update(params[:location])
          format.html do
            redirect_to @location,
                        notice: 'Location was successfully updated.'
          end
        else
          format.html { render :edit }
        end
      end
    end

    def create
      @location = Location.new(params[:location])

      respond_to do |format|
        if @location.save
          format.html do
            redirect_to @location,
                        notice: 'Location was successfully created.'
          end
        else
          format.html { render :new }
        end
      end
    end

    def destroy
      location = Location.find(params[:id])
      location.destroy
      respond_to do |format|
        format.html { redirect_to admin_locations_path }
      end
    end

    private

    def domain
      current_admin.email.split('@').last
    end

    def user_allowed_access_to_location?(location)
      if current_admin_has_generic_email?
        emails_match_user_email?(location) || admins_match_user_email?(location)
      else
        emails_match_domain?(location) || urls_match_domain?(location)
      end
    end

    def urls_match_domain?(location)
      return false unless location[:urls].present?
      location.urls.select { |url| url.include?(domain) }.length > 0
    end

    def emails_match_domain?(location)
      return false unless location[:emails].present?
      location.emails.select { |email| email.include?(domain) }.length > 0
    end

    def emails_match_user_email?(location)
      return false unless location[:emails].present?
      location.emails.select { |email| email == current_admin.email }.length > 0
    end

    def admins_match_user_email?(location)
      return false unless location[:admin_emails].present?
      location.admin_emails.select { |email| email == current_admin.email }.length > 0
    end

    def current_admin_has_generic_email?
      generic_domains = SETTINGS[:generic_domains]
      generic_domains.include?(domain)
    end

    def perform_search
      if current_admin_has_generic_email?
        Location.text_search(email: current_admin.email)
      else
        Location.text_search(domain: domain)
      end
    end
  end
end
