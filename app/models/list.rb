class List < ApplicationRecord
  belongs_to :user
  before_create :set_sha

  scope :visible, -> { where(:visible => true) }
  scope :hidden, -> { where(:visible => false) }

  def to_param
    sha
  end

private

  def set_sha
    self.sha = SecureRandom.hex
  end
end
