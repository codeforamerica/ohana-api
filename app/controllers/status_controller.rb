class StatusController < ApplicationController
  respond_to :json

  def get_status
    # DB checks
    test_location = Location.first
    test_category = Category.first

    # Search check
    test_search = Location.search(:keyword => "food")

    if test_location.nil? || test_category.nil?
      status = "DB did not return location or category"
    elsif test_search.count == 0
      status = "Search returned no results"
    else
      status = "ok"
    end

    render json:
      {
        "status" => status,
        "updated" => Time.now.to_i,
        "dependencies" => ["Mandrill","Mongolab","Redis To Go","MemCachier","Elasticsearch"]
      }
  end
end