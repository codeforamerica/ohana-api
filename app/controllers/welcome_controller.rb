class WelcomeController < ApplicationController
  layout 'welcome'
  before_action :check_token

  def home
    @token = WelcomeToken.first
  end

  def upload
    token = WelcomeToken.first
    entity = params[:entity]
    status = 400

    if entity.present? and WelcomeToken::ENTITIES.include? entity
      begin
        importer_class = "#{entity.camelcase}Importer".constantize
        if params[:files].present? and params[:files].compact.present? and params[:files].compact.all?{|f| f.content_type == 'text/csv'}
          # see: http://stackoverflow.com/a/4612440/32816
          # Feed the content to the entity importer.
          files = params[:files].map{|f| f.tempfile.path }
          errors = importer_class.check_and_import_file(*files)

          if errors.blank?
            message = 'Successfully uploaded.'
            status = 200
          else
            message = errors
          end
        else
          message = 'Only CSV files are accepted.'
        end
      rescue NameError => e
        message = 'Not a valid entity.'
      end
    else
      message = 'Not a valid entity.'
    end

    render json: {status: status, message: message, entity: entity}, status: 200
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
