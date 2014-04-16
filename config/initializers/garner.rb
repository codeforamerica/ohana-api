# require "garner"
# require "garner/mixins/rack"

# # Monkey patch to cache headers until this is built into Garner
# # https://github.com/artsy/garner/issues/54
# module Garner
#   module Cache
#     class Identity
#       TRACKED_HEADERS = %w{ Link X-Total-Count X-Total-Pages X-Current-Page X-Next-Page X-Previous-Page }

#       alias_method :_fetch, :fetch
#       def fetch(&block)
#         if @key_hash[:tracked_grape_headers]
#           result, headers = _fetch do
#             result = yield
#             headers = @ruby_context.header.slice(*TRACKED_HEADERS) if @ruby_context.respond_to?(:header)
#             [result, headers]
#           end

#           (headers || {}).each do |key, value|
#             @ruby_context.header(key, value) if @ruby_context.respond_to?(:header)
#           end

#           result
#         else
#           _fetch(&block)
#         end
#       end

#     end
#   end
# end

# module Garner
#   module Mixins
#     module Rack

#       alias_method :_garner, :garner
#       def garner(&block)
#         response, headers = _garner.key({ tracked_grape_headers: true }, &block)
#       end

#     end
#   end
# end