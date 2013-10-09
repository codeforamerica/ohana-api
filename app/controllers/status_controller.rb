class StatusController < ApplicationController
  respond_to :json

  def get_status
    render json:
      {
        "status" => "ok",
        "updated" => Time.now.to_i
      }
  end
end