module FeatureGraph
  class FeatureNameToClassRepository
    require 'active_support/core_ext/string'
    def initialize(feature_name, class_name = nil)
      @feature_name = feature_name.to_sym
      @class_name = class_name || "#{feature_name}_feature".classify
    end
  end
end
