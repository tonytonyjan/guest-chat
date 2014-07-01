class Room < ActiveRecord::Base
  has_many :messages
  after_initialize :gen_slug, if: :new_record?

  def to_param
    slug
  end

  private
  def gen_slug
    self.slug = SecureRandom.hex(4)
  end
end
