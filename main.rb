# frozen_string_literal: true

$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')

require 'feature_graph'

class ClownLicenseFeature < FeatureGraph::Feature
  def apply_to(_user)
    puts 'applying clown license to user'
  end

  def applied_to?(_user)
    false
  end
end

class FunnyHatFeature < FeatureGraph::Feature
  depends_on :clown_license
  def apply_to(_user)
    puts 'applying funny hat to user'
  end
end

class SillySocksFeature < FeatureGraph::Feature
  depends_on :clown_license
  def apply_to(_user)
    puts 'applying silly socks to user'
  end
end

class SquirtingFlowerFeature < FeatureGraph::Feature
  depends_on :funny_hat
  def apply_to(_user)
    puts 'applying squirting flower to user'
  end
end

class HonkFeature < FeatureGraph::Feature
  depends_on :funny_hat
  def apply_to(_user)
    puts 'applying honk to user'
  end
end

class SmallCarFeature < FeatureGraph::Feature
  depends_on :clown_license
  def apply_to(_user)
    puts 'applying small car to user'
  end
end

user = Object.new
request_list = FeatureGraph::RequestList.new
request_list.add(:honk)
request_list.add(:squirting_flower)
request_list.add(:silly_socks)

puts FeatureGraph::DependencyTree.new(request_list).sorted_feature_names
