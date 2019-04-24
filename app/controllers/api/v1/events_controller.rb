module Api
  module V1
    class EventsController < Api::V1::BaseController
      include Cacheable
      include PaginationHeaders
      include ErrorSerializer

      before_action :authenticate_api_user!, except: %i[index show]
      after_action :set_cache_control, only: :index

      def index
        events = fetch_events
        generate_pagination_headers(events)
        render json: events,
               each_serializer: EventsSerializer,
               status: 200
      end

      def show
        render json: event,
               serializer: EventsSerializer,
               status: 200
      end

      def create
        @event = Event.new(event_params)
        @event.posted_at = DateTime.now
        @event.user_id = current_api_user.id
        if @event.save
          render json: @event, serializer: EventsSerializer, status: 200
        else
          render json: ErrorSerializer.serialize(@event.errors),
                 status: :unprocessable_entity
        end
      end

      def update
        event.street_2, event.external_url = nil
        if event.update(event_params)
          render json: event,
                 serializer: EventsSerializer,
                 status: 200
        else
          render json: ErrorSerializer.serialize(@event.errors),
                 status: :unprocessable_entity
        end
      end

      def destroy
        if event.destroy
          render json: {}, status: :ok
        else
          render json: ErrorSerializer.serialize(@event.errors),
                 status: :unprocessable_entity
        end
      end

      private

      def event
        @event ||= Event.find(params[:id])
      end

      def fetch_events
        events = Event.includes(:organization).includes(:user)
        events = events.events_in_month(DateTime.strptime(params[:month], '%m')) if params[:month].present?
        events = events.where(is_featured: true) if params[:featured].present?
        events = events.where('starting_at >= ?', DateTime.parse(params[:starting_after])) if params[:starting_after].present?
        events = events.where('ending_at <= ?', DateTime.parse(params[:ending_before])) if params[:ending_before].present?
        events = events.where(organization_id: params[:organization_id]) if params[:organization_id].present?
        events.page(params[:page]).per(params[:per_page]).order('starting_at ASC')
      end

      def event_params
        params.require(:event).permit(
          :title,
          :posted_at,
          :starting_at,
          :ending_at,
          :street_1,
          :street_2,
          :city,
          :state_abbr,
          :zip,
          :phone,
          :external_url,
          :organization_id,
          :body,
          :is_all_day
        )
      end
    end
  end
end
