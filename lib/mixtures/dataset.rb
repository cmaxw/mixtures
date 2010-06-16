module Mixtures
  class Dataset < ActiveRecord::Base
    has_many :records
  end
end