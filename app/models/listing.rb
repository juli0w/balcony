class Listing < ApplicationRecord
  serialize :items, Array

  def populate
    Listing.create({ name: "Oficina", items: [6199,6375,1261,1509,1343,1510,3939,75,1538,5793,1520,1523,5684,1264,1494,1,1495,3126,5,6,3110,5085,6341] })
  end
end
