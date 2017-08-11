class Client < ApplicationRecord
  has_many :orders
  belongs_to :section

  include SearchCop

  search_scope :search do
    attributes :id
    attributes :name
    attributes :email
  end
end
