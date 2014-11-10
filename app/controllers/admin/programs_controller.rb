class Admin
  class ProgramsController < ApplicationController
    before_action :authenticate_admin!
    layout 'admin'

    def index
      @programs = Kaminari.paginate_array(policy_scope(Program)).
                  page(params[:page]).per(params[:per_page])
    end

    def edit
      @program = Program.find(params[:id])

      authorize @program
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
      authorize @program
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

      if policy_scope(Organization).select { |org| org[0] == org_id.to_i }.present?
        @program.organization_id = org_id
      end
    end
  end
end
