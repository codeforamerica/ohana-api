class Admin
  class EventsController < ApplicationController
    include ErrorSerializer

    before_action :authenticate_admin!
    layout 'admin'

    def index
      @events = if params[:filter] == 'featured'
                  Kaminari.paginate_array(
                    policy_scope(
                      Event.where(is_featured: true)
                    )
                  )
                else
                  Kaminari.paginate_array(policy_scope(Event))
                end
      params[:page] = 1 if @events.count < Kaminari.config.default_per_page
      @events = @events.page(params[:page])
                       .per(params[:per_page])
    end

    def show
      @event = Event.find(params[:id])
    end

    def edit
      @event = Event.find(params[:id])

      authorize @event
    end

    def update
      @event = Event.find(params[:id])

      if @event.update(params[:event])
        redirect_to [:admin, @event],
                    notice: 'Event was successfully updated.'
      else
        render :edit
      end
    end

    def featured
      @event = Event.find(params[:id])
      if @event.update(is_featured: params[:event][:is_featured])
        render json: {}, status: :ok
      else
        render json: ErrorSerializer.serialize(@event.errors),
               status: :unprocessable_entity
      end
    end

    def destroy
      event = Event.find(params[:id])
      event.destroy
      redirect_to admin_events_path
    end
  end
end
