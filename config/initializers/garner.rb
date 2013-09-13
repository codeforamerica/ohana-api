require "garner"
require "garner/mixins/mongoid"

module Mongoid
  module Document
    include Garner::Mixins::Mongoid::Document
  end
end