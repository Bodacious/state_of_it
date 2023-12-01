# frozen_string_literal: true

module FeatureGraph
  require_relative 'feature_graph/version'
  require_relative 'feature_graph/feature'

  module FeatureClassable
    def feature_name=(value)
      @feature_name = value
    end

    def feature_name
      @feature_name
    end

    def feature
      return @feature if defined?(@feature)

      @feature = feature_class.new
    end

    private

    delegate :feature_class_name,
             to: :'FeatureGraph::Registry.singleton'

    def feature_class(feature_name)
      Object.const_get(
        feature_class_name(feature_name)
      )
    end
  end

  class StateRemovalRequest
    include FeatureClassable
    attr_reader :model

    def initialize(feature_name, model)
      self.feature_name = feature_name
      @model = model
    end

    def process!
      return unless feature.applied_to?(model)

      feature.remove_from(model)
    end
  end
  class StateAdditionRequest
    include FeatureClassable
    attr_reader :model

    def initialize(feature_name, model)
      self.feature_name = feature_name
      @model = model
    end

    def process!
      return if feature.applied_to?(model)

      feature.apply_to(model)
    end
  end

  class StateChangeRequest
    include FeatureClassable

    attr_reader :errors, :requested_additions, :requested_removals, :model

    attr_accessor :processed, :success

    def initialize(requested_changes = {}, model:)
      @requested_additions = requested_changes.select { |_k, value| value }.keys
      @requested_removals = requested_changes.reject { |_k, value| value }.keys
      @model = model
      @success = nil
      @processed = false
      @errors = {}
    end

    def success?
      raise 'Not attempted yet' unless processed?

      success
    end

    def processed?
      !!processed
    end

    def process!
      self.processed = true
      requested_removals_tree.each { StateRemovalRequest.new(_1, model).process! }
      requested_additions_tree.each { StateAdditionRequest.new(_1, model).process! }
      self.success = true
    end

    def requested_removals_tree
      []
    end

    def requested_additions_tree
      requested_additions
        .each_with_object(DependencyTree.new) do |feature_name, tree|
        f_class = Object.const_get(
          feature_class_name(feature_name)
        )
        tree.add(f_class.feature_name, f_class.dependencies)
      end
    end
  end
end
