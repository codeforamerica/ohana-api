class WelcomeController < ApplicationController
  layout 'welcome'
  before_action :check_token

  def home
    @token = WelcomeToken.first
  end

  def sign_in_first_time
    admin = Admin.first
    # Only destroy the token in production.
    WelcomeToken.first.disable if Rails.env.production?
    sign_in_and_redirect :admin, admin
  end

  def start_over
    Category.destroy_all
    Organization.destroy_all
    conn = ActiveRecord::Base.connection
    conn.reset_pk_sequence!('organizations')
    conn.reset_pk_sequence!('services')
    conn.reset_pk_sequence!('programs')
    conn.reset_pk_sequence!('categories')
    conn.reset_pk_sequence!('locations')
    conn.reset_pk_sequence!('contacts')
    conn.reset_pk_sequence!('phones')

    redirect_to welcome_path(code: params[:code])
  end

  def upload
    token = WelcomeToken.first
    entity = params[:entity]
    status = 400

    if entity.present? and WelcomeToken::ENTITIES.include? entity
      begin
        importer_class = "#{entity.camelcase}Importer".constantize
        if params[:files].present? and params[:files].compact.present? and params[:files].compact.all?{|f| f.content_type == 'text/csv'}

          if params[:files].length > 1
            # Re-order the uploaded files for the location entity.
            f1 = params[:files].select{|f| f.original_filename.match('location') }
            f2 = params[:files].select{|f| f.original_filename.match('address') }
            params[:files] = [f1,f2].flatten
          end

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
      rescue RuntimeError => e
        message = 'File was empty.'
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
      elsif !token.is_active
        root_path
      elsif params[:code].blank?
        root_path
      elsif params[:code] != token.code
        root_path
      end

      redirect_to path if path
    end
end
