module FeatureGraph
  class DependencyTree
    require 'tsort'
    require 'active_support/core_ext/string'
    include TSort

    alias sorted_feature_names tsort
    private :tsort

    def initialize
      @store = Hash.new { |hash, key| hash[key] = Set.new }
    end

    def sorted_features
      sorted_feature_names.map { Object.const_get("#{_1}_feature".classify) }
    end

    def add(feature_name, dependencies)
      store[feature_name]
      store[feature_name] += dependencies.map(&:dependency)
    end

    def each(&block)
      sorted_features.each(&block)
    end

    private

    attr_reader :dependencies, :store

    def tsort_each_node(&block)
      store.each_key(&block)
    end

    def tsort_each_child(node, &block)
      store.fetch(node).each(&block)
    end
  end
end
