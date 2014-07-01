class Room < ActiveRecord::Base
  has_many :messages, dependent: :destroy
  after_initialize :gen_slug, unless: :slug

  def to_param
    slug
  end

  private
  def gen_slug
    self.slug = SecureRandom.hex(4)
  end
end
