class Url < ApplicationRecord
  has_many :click_stats, dependent: :destroy
  validates :short_url, uniqueness: true, length: { is: 8 }
  before_save :set_expires_at

  private

  def set_expires_at
    self.expires_at = Time.now + 24.hours
  end
end
