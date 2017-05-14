class Thing < ApplicationRecord
  belongs_to :list
  before_create :set_sha

  def to_param
    sha
  end

private

  def set_sha
    self.sha = SecureRandom.hex
  end
end
