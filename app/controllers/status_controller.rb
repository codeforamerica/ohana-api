class StatusController < ApplicationController
  respond_to :json

  def check_status
    if test_location.nil? || test_category.nil?
      status = 'DB did not return location or category'
    elsif test_search.count == 0
      status = 'Search returned no results'
    else
      status = 'ok'
    end

    render json:
      {
        'status' => status,
        'updated' => Time.now.to_i,
        'dependencies' => DEPENDENCIES
      }
  end

  def test_location
    Location.first
  end

  def test_category
    Category.first
  end

  def test_search
    Location.text_search(keyword: 'food')
  end

  DEPENDENCIES = [
    'Mandrill',
    'Postgres',
    'Redis To Go',
    'MemCachier'
  ]
end
