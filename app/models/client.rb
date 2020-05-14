class Client < ApplicationRecord
  has_many :orders
  belongs_to :section

  include SearchCop

  search_scope :search do
    attributes :id
    attributes :name
    attributes :company
    attributes :email
    attributes :city
    attributes :section => ["section.name"]
  end

  def name
    read_attribute(:name) || "<sem nome>"
  end

  def points date
    orders.where("created_at > ?", date).sum(&:calculate_total)
  end
end
