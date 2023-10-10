$LOAD_PATH << File.join(File.dirname(__FILE__),'lib')

require "feature_graph"
require 'active_support/core_ext/string'

class ClownLicenseFeature < FeatureGraph::Feature
  depends_on :clown_license
end

class FunnyHatFeature < FeatureGraph::Feature
  depends_on :clown_license
end

class SillySocksFeature < FeatureGraph::Feature
  depends_on :clown_license
end

class SquirtingFlowerFeature < FeatureGraph::Feature
  depends_on :funny_hat
end

class HonkFeature < FeatureGraph::Feature
  depends_on :funny_hat
end

puts FeatureGraph::Feature.graph.tsort