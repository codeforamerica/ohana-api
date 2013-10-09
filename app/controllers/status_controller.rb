class StatusController < ApplicationController
  respond_to :json

  def get_status
    # DB checks
    test_location = Location.first
    test_category = Category.first

    if test_location.present? && test_category.present?
      status = "ok"
    else
      status = "DB returned blank location or category"
    end

    render json:
      {
        "status" => status,
        "updated" => Time.now.to_i
        "dependencies" => ["Mandrill","Mongolab","Redis To Go","MemCachier","Elasticsearch"]
      }
  end
end