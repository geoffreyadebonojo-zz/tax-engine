class User < ApplicationRecord
  validates_uniqueness_of :uuid
  before_create :generate_uuid
  serialize :tax_brackets, Array

  def generate_uuid
    self.uuid = SecureRandom.hex(10) if uuid.nil? # so we can specify a custom uuid, if we want
  end
end
