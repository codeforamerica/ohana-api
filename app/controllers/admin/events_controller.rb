class Admin
  class EventsController < ApplicationController
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
      @events = @events.page(params[:page])
                       .per(params[:per_page])
    end

    def show; end

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

    def destroy
      event = Event.find(params[:id])
      event.destroy
      redirect_to admin_events_path
    end
  end
end
