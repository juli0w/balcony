class Output < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  TYPES = {
    "Envelope" => 0,
    "Despesa" => 1,
    "Injeção" => 2,
    "Vale" => 3
  }

  def value
    self.read_attribute(:value) || 0
  end

  def type_name
    TYPES.key(self.output_type) || "Não informado"
  end
end