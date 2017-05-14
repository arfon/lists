class List < ApplicationRecord
  belongs_to :user
  before_create :set_sha, :check_properties

  scope :visible, -> { where(:visible => true) }
  scope :hidden, -> { where(:visible => false) }

  def to_param
    sha
  end

private

  # TODO: Do whatever sanity checks we want to on the list properties here. For
  # example, we might want to limit the number of properties a user can define
  # for a list
  #
  # Returns a boolean
  def check_properties
    true
  end

  def set_sha
    self.sha = SecureRandom.hex
  end
end
