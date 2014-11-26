class Guest < ActiveRecord::Base
  has_many :messages, dependent: :destroy
  after_initialize :init_name, unless: :name
  validates :role, inclusion: {in: %w[teacher assistant student]}, allow_blank: true

  def exec command
    argv = command.split
    cmd = argv.shift
    if cmd == 'role'.freeze && argv.first
      update role: argv.first
    else
      false
    end
  end

  private
  def init_name
    self.name = FakeName.generate
  end
end
