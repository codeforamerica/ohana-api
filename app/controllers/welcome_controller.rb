class WelcomeController < ApplicationController
  layout 'welcome'
  before_action :check_token

  def home
    @token = WelcomeToken.first
  end

  def upload
    token = WelcomeToken.first
    message = 'Not a valid entity.'
    status = 400

    if params[:entity].present? and WelcomeToken::ENTITIES.include? params[:entity]
      importer_class = "#{params[:entity].titleize}Importer".constantize

      # Feed the content to the entity importer.
      importer = importer_class.new(params[:file]).tap(&:import)
      errors = []
      importer.errors.each { |e| errors << e } unless importer.valid?
      
      if importer.valid?
        message = 'Success.'
        status = 200
      else
        message = errors
        status = 400
      end
    end

    render json: {message: message}, status: status
  end

  private
    def check_token
      token = WelcomeToken.first

      path = if token.blank?
        token = WelcomeToken.create
        welcome_path(code: token.code)
      elsif params[:code].blank?
        root_path
      elsif params[:code] != token.code
        root_path
      end

      redirect_to path if path
    end
end
