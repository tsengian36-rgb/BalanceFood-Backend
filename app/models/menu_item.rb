class MenuItem < ApplicationRecord
  belongs_to :restaurant
  has_many :expenses, dependent: :nullify

  validates :name, presence: true, length: { maximum: 120 }
  validates :price, numericality: { only_integer: true, greater_than: 0 }

  def restaurant_name
    restaurant&.name
  end
end
