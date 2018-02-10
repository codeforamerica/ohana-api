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
    @api_application = current_user.api_applications.new(api_application_params)

    if @api_application.save
      redirect_to edit_api_application_url(@api_application),
                  notice: 'Application was successfully created.'
    else
      render :new
    end
  end

  # PUT /api_applications/1
  def update
    @api_application = current_user.api_applications.find(params[:id])

    if @api_application.update_attributes(api_application_params)
      redirect_to edit_api_application_url(@api_application),
                  notice: 'Application was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /api_applications/1
  def destroy
    api_application = current_user.api_applications.find(params[:id])
    api_application.destroy
    redirect_to api_applications_url,
                notice: 'Application was successfully deleted.'
  end

  private

  def api_application_params
    params.require(:api_application).permit(:name, :main_url, :callback_url)
  end
end
