# frozen_string_literal: true

module FeatureGraph
  class Graph
    require 'tsort'
    require 'active_support/core_ext/string'
    include TSort

    alias sorted_feature_names tsort
    private :tsort

    # class << self
    #   def singleton
    #     @singleton ||= new
    #   end
    # end

    def initialize(feature)
      @store = feature.dependency_tree
    end

    def sorted_features
      sorted_feature_names.map { Object.const_get("#{_1}_feature".classify) }
    end

    def tsort_each_node(&block)
      store.each_key(&block)
    end

    def tsort_each_child(node, &block)
      store.fetch(node).each(&block)
    end

    def register_feature(feature_name, class_name = nil)
      class_name ||= "#{feature_name}_#{feature}".classify
      store[feature_name][:class_name] = class_name
      self
    end

    def register_dependency(feature_name, dependent_feature_name)
      register_feature(feature_name)
      store[feature_name][:dependencies].push(dependent_feature_name)
      self
    end

    def inspect
      store.inspect
    end

    private

    attr_reader :store
  end
end
