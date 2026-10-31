class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :menu_item, optional: true

  validates :description, presence: true, length: { maximum: 200 }
  validates :amount, numericality: { only_integer: true, greater_than: 0 }
  validates :spent_on, presence: true

  def menu_item_name
    menu_item&.name
  end
end
