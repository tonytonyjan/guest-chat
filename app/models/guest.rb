class Guest < ActiveRecord::Base
  has_many :messages, dependent: :destroy
  after_initialize :init_name, unless: :name

  private
  def init_name
    self.name = FakeName.generate
  end
end
