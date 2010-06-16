module Mixtures
  class Record < ActiveRecord::Base
    belongs_to :dataset
  end
end