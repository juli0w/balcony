class Item < ApplicationRecord
  belongs_to :group
  belongs_to :family
  belongs_to :subgroup

  include SearchCop

  search_scope :search do
    attributes :name
    attributes :family => ["family.name"]
    attributes :group => ["group.name"]
    attributes :subgroup => ["subgroup.name"]
  end
end
