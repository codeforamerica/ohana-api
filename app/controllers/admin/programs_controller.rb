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

      if @program.update(program_params)
        redirect_to [:admin, @program],
                    notice: 'Program was successfully updated.'
      else
        render :edit
      end
    end

    def new
      @program = Program.new
      authorize @program
    end

    def create
      @program = Program.new(program_params)

      add_org_to_program_if_authorized

      if @program.save
        redirect_to admin_programs_url,
                    notice: 'Program was successfully created.'
      else
        render :new
      end
    end

    def destroy
      program = Program.find(params[:id])
      program.destroy
      redirect_to admin_programs_path
    end

    private

    def add_org_to_program_if_authorized
      org_id = program_params[:organization_id]

      if policy_scope(Organization).select { |org| org[0] == org_id.to_i }.present?
        @program.organization_id = org_id
      end
    end

    def program_params
      params.require(:program).permit(:alternate_name, :name, :organization_id)
    end
  end
end
