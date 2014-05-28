module Requests
  # This module allows you to use 'json' within specs as a shortcut for
  # 'JSON.parse(response.body)'
  module JsonHelpers
    def json
      @json ||= JSON.parse(response.body)
    end
  end
end
