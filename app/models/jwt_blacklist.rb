class JWTBlacklist < ActiveRecord::Base
  include Devise::JWT::RevocationStrategies::Blacklist

  self.table_name = 'jwt_blacklist'
end
