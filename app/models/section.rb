class Section < ApplicationRecord
  has_many :clients

  def self.rebuild
    Section.delete_all
    Section.create(name: "Revenda")
    Section.create(name: "Consumidor")
  end
end
