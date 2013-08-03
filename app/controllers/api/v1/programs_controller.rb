module Api
  module V1
    class ProgramsController < ApiController

      after_filter only: [:index] { paginate(:progs) }
      caches :index, :show, :caches_for => 5.minutes

      def index
        # org = Organization.find(params[:organization_id])
        # expose org.programs.page(params[:page]).per(30)
        @progs = Program.page(params[:page]).per(30)
        expose @progs
      end

      def show
        # org = Organization.find(params[:organization_id])
        # expose Program.where(:organization_id.in => org.id)
        # expose org.programs.find(params[:id])
        expose Program.find(params[:id])
      end

    end
  end
end