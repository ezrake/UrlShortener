class Url < ApplicationRecord
  validates :short_url, uniqueness: true, length: {is: 8}
end
