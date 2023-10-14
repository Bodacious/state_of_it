# frozen_string_literal: true

module FeatureGraph
  class Feature
    require 'active_support/core_ext/string'
    require_relative 'graph'
    require_relative 'dependency'
    require_relative 'dependency_tree'
    require_relative 'registry'
    class << self
      CLASS_NAME_SUFFIX = /Feature\Z/.freeze

      def inherited(subclass)
        super
        registry.register_feature(subclass.feature_name, subclass.name)
      end

      def registry
        Registry.singleton
      end

      def dependencies
        @dependencies ||= Set.new
      end

      def dependency_tree
        return @dependency_tree if defined?(@dependency_tree)

        @dependency_tree = DependencyTree.new(dependencies)
      end

      def depends_on(other_feature_name)
        remove_instance_variable(:@dependency_tree) if defined?(@dependency_tree)

        dependencies.add Dependency.new(dependent: feature_name,
                                        dependency: other_feature_name)
      end

      def feature_name
        name.gsub(CLASS_NAME_SUFFIX, '').underscore.to_sym
      end

      def apply_to(user, _feature_name)
        feature.new.apply_to(user)
      end
    end

    def apply_to(user)
      raise NotImplementedError, "Please define #{__method__} in #{self}"
    end

    def applied_to?(user)
      raise NotImplementedError, "Please define #{__method__} in #{self}"
    end
  end
end
