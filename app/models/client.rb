class Client < ApplicationRecord
  has_many :orders

  include SearchCop

  search_scope :search do
    attributes :name
    attributes :email
  end
end
