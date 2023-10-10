module FeatureGraph
  require 'feature_graph/version'
  # require 'feature_graph/base'
  # require 'delegate'
  require 'tsort'
  require 'debug'
  class Graph
    include TSort

    def initialize
      @store = Hash.new { |hash, key| hash[key] = Set.new }
    end

    def tsort_each_node(&block)
      store.each_key(&block)
    end

    def tsort_each_child(node, &block)
      store.fetch(node).each(&block)
    end

    def register_feature(feature_name)
      store[feature_name]
      self
    end

    def register_dependency(feature_name, dependent_feature_name)
      register_feature(feature_name)
      store[feature_name].add(dependent_feature_name)
      self
    end

    def inspect
      store.inspect
    end

    private

    attr_reader :store
  end
  class Feature
    def self.graph
      @@graph ||= Graph.new
    end
    def self.depends_on(other_feature_name)
      graph.register_dependency(self.feature_name, other_feature_name)
    end
    def self.feature_name
      self.name.gsub(/Feature$/, '').to_s.underscore.to_sym
    end
  end
end