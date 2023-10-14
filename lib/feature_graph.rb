# frozen_string_literal: true

module FeatureGraph
  require_relative 'feature_graph/version'
  require_relative 'feature_graph/feature'

  class RequestList
    attr_reader :store

    def initialize
      @store = Set.new
    end

    delegate :to_a, :add, :remove, :each, to: :store
  end
end
