class Admin
  class ProgramsController < ApplicationController
    before_action :authenticate_admin!
    layout 'admin'

    def index
      @admin_decorator = AdminDecorator.new(current_admin)
      @programs = Kaminari.paginate_array(@admin_decorator.programs).
                          page(params[:page]).per(params[:per_page])
    end

    def edit
      @admin_decorator = AdminDecorator.new(current_admin)
      @program = Program.find(params[:id])

      unless @admin_decorator.allowed_to_access_program?(@program)
        redirect_to admin_dashboard_path,
                    alert: "Sorry, you don't have access to that page."
      end
    end

    def update
      @program = Program.find(params[:id])

      respond_to do |format|
        if @program.update(params[:program])
          format.html do
            redirect_to [:admin, @program],
                        notice: 'Program was successfully updated.'
          end
        else
          format.html { render :edit }
        end
      end
    end

    def new
      @program = Program.new
      @admin_decorator = AdminDecorator.new(current_admin)
      @orgs = @admin_decorator.orgs

      unless @orgs.present?
        redirect_to admin_dashboard_path,
                    alert: "Sorry, you don't have access to that page."
      end
    end

    def create
      @program = Program.new(params[:program])

      add_org_to_program_if_authorized

      respond_to do |format|
        if @program.save
          format.html do
            redirect_to admin_programs_url,
                        notice: 'Program was successfully created.'
          end
        else
          format.html { render :new }
        end
      end
    end

    def destroy
      program = Program.find(params[:id])
      program.destroy
      respond_to do |format|
        format.html { redirect_to admin_programs_path }
      end
    end

    def confirm_delete_program
      @program_name = params[:program_name]
      @program_id = params[:program_id]
      respond_to do |format|
        format.html
        format.js
      end
    end

    private

    def add_org_to_program_if_authorized
      org_id = params[:program][:organization_id]

      @orgs = AdminDecorator.new(current_admin).orgs

      if @orgs.select { |org| org[0] == org_id.to_i }.present?
        @program.organization_id = org_id
      end
    end
  end
end
