module Api
  module V1
    class EventsController < ApplicationController
      include CustomErrors
      include Cacheable
      include PaginationHeaders

      skip_before_action :verify_authenticity_token

      before_action :set_event, only: %i[show update destroy]
      after_action :set_cache_control, only: :index

      def index
        events = get_events
        generate_pagination_headers(events)
        render json: events,
               each_serializer: EventsSerializer,
               status: 200
      end

      def show
        render json: @event,
               serializer: EventsSerializer,
               status: 200
      end

      def create
        @event = Event.new(event_params)
        if @event.save
          render json: @event,
                 serializer: EventsSerializer,
                 status: 200
        else
          render json: @event,
                 status: :unprocessable_entity,
                 serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      def update
        if @event.update(event_params)
          render json: @event,
                 serializer: EventsSerializer,
                 status: 200
        else
          render json: @event,
                 status: :unprocessable_entity,
                 serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      def destroy
        if @event.destroy
          render json: {}, status: :ok
        else
          render json: @event,
                 status: :unprocessable_entity,
                 serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      private

      def get_events
        events = Event.all
        events = events.events_in_month(params[:month]) if params[:month].present?
        events = events.where(organization_id: params[:organization_id]) if params[:organization_id].present?
        events.page(params[:page])
              .per(params[:per_page])
              .order('starting_at ASC')
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
          :admin_id
        )
      end

      def set_event
        @event = Event.find(params[:id])
      end
    end
  end
end
