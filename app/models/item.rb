class Item < ApplicationRecord
  mount_uploader :image, ImageUploader

  default_scope { where(active: true) }

  belongs_to :group
  belongs_to :family
  belongs_to :subgroup

  include SearchCop

  search_scope :search do
    attributes :name
    attributes :code
    attributes :family => ["family.name"]
    attributes :group => ["group.name"]
    attributes :subgroup => ["subgroup.name"]
  end
end
