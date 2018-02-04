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

      authorize @program

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
      org = @program.organization

      authorize @program if org.present?

      if @program.save
        redirect_to admin_programs_url,
                    notice: 'Program was successfully created.'
      else
        render :new
      end
    end

    def destroy
      program = Program.find(params[:id])
      authorize program
      program.destroy
      redirect_to admin_programs_url
    end

    private

    def program_params
      params.require(:program).permit(:alternate_name, :name, :organization_id)
    end
  end
end
