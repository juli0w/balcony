class Item < ApplicationRecord
  mount_uploader :image, ImageUploader

  # default_scope { where(active: true) }

  belongs_to :group, optional: true
  belongs_to :family, optional: true
  belongs_to :subgroup, optional: true

  include SearchCop

  search_scope :search do
    attributes :name
    attributes :code
    attributes :family => ["family.name"]
    attributes :group => ["group.name"]
    attributes :subgroup => ["subgroup.name"]
  end

  def final_price
    virtual_price.to_f > 0 ? virtual_price : price
  end
end
