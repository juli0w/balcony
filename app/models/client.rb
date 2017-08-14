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
    attributes :district
    attributes :section => ["section.name"]
  end
end
