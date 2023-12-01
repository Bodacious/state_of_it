module FeatureGraph
  class Registry
    class UndefinedFeatureError < StandardError
    end

    class FeatureNameAlreadyExistsError < StandardError
    end

    def self.singleton
      @singleton ||= new
    end

    attr_reader :store

    def initialize
      @store = {}
    end

    def register_feature(feature_name, feature_class_name)
      feature_class_name = feature_class_name.to_sym
      stored_class_name = store[feature_name]
      if stored_class_name && stored_class_name != feature_class_name
        raise FeatureNameAlreadyExistsError,
              "A feature named #{feature_name} is already defined"
      end

      store[feature_name] = feature_class_name
    end

    def feature_class_name(feature_name)
      store[feature_name] || raise(UndefinedFeatureError,
                                   "There's no feature defined as #{feature_name}")
    end
  end
end
