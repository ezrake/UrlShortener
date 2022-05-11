class Url < ApplicationRecord
  validates :short_url, uniqueness: true
end
