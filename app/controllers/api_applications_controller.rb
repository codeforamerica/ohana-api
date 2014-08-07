class ApiApplicationsController < ApplicationController
  before_action :authenticate_user!

  # GET /api_applications
  def index
    @api_applications = current_user.api_applications
  end

  # GET /api_applications/new
  def new
    @api_application = current_user.api_applications.new
  end

  # GET /api_applications/1/edit
  def edit
    @api_application = current_user.api_applications.find(params[:id])
  end

  # POST /api_applications
  def create
    @api_application = current_user.api_applications.new(params[:api_application])

    respond_to do |format|
      if @api_application.save
        format.html do
          redirect_to @api_application,
                      notice: 'Application was successfully created.'
        end
      else
        format.html { render :new }
      end
    end
  end

  # PUT /api_applications/1
  def update
    @api_application = current_user.api_applications.find(params[:id])

    respond_to do |format|
      if @api_application.update_attributes(params[:api_application])
        format.html do
          redirect_to @api_application,
                      notice: 'Application was successfully updated.'
        end
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /api_applications/1
  def destroy
    @api_application = current_user.api_applications.find(params[:id])
    @api_application.destroy

    respond_to do |format|
      format.html { redirect_to api_applications_url }
    end
  end
end
