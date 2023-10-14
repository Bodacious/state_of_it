module FeatureGraph
  class DependencyTree
    require 'tsort'
    require 'active_support/core_ext/string'
    include TSort

    alias sorted_feature_names tsort
    private :tsort

    def initialize(dependencies)
      @dependencies = dependencies
      @store = Hash.new { |hash, key| hash[key] = Set.new }

      store_dependency_structure!
    end

    def sorted_features
      sorted_feature_names.map { Object.const_get("#{_1}_feature".classify) }
    end

    private

    attr_reader :dependencies, :store

    def store_dependency_structure!
      dependencies.each do |dependency|
        store[dependency.dependent]
        store[dependency.dependent].add(dependency.dependency)
      end
    end

    def tsort_each_node(&block)
      store.each_key(&block)
    end

    def tsort_each_child(node, &block)
      store.fetch(node).each(&block)
    end
  end
end
