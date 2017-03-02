require 'nokogiri'
class Efator
  attr_accessor :family, :group, :subgroup, :item

  def initialize params
    self.family = params[:family]
    self.group = params[:group]
    self.subgroup = params[:subgroup]
    self.item = params[:item]
  end

  def self.reset!
    Family.delete_all
    Group.delete_all
    Subgroup.delete_all
    Item.delete_all
  end

  def import
    Thread.new { import! }
  end

  def import!
    Efator.import_family self.family
    Efator.import_group self.group
    Efator.import_subgroup self.subgroup
    Efator.import_item self.item
  end

private

  def self.import_item file
    xml = Nokogiri::XML(File.open(file.tempfile))

    xml.xpath("itens/item").each do |i|

      # load or create the item
      item = Item.where(code: i['id']).first_or_create

      # get grupo, subgrupo and familia
      family   = Family.where(code: i.xpath("familia").text).first
      group    = Group.where(code: i.xpath("grupo").text).first
      subgroup = Subgroup.where(code: i.xpath("subgrupo").text).first

      # update item values
      item.name   = i.xpath("descricao").text
      item.family_id = family.id
      item.group_id = group.id
      item.subgroup_id = subgroup.id
      item.price  = i.xpath("precovenda").text
      item.active = (i.xpath("ativo").text == "true")

      item.save
    end
  end

  def self.import_family file
    xml = Nokogiri::XML(File.open(file.tempfile))
    xml.xpath("familias/familia").each do |item|
      Family.create(code: item['id'].to_i,
                    name: item.xpath("descricao").text)
    end
  end

  def self.import_group file
    xml = Nokogiri::XML(File.open(file.tempfile))
    xml.xpath("grupos/grupo").each do |item|
      family = Family.where(code: item.xpath("familia").text.to_i).first
      family.groups.create(code: item['id'].to_i,
                           name: item.xpath("descricao").text)
    end
  end

  def self.import_subgroup file
    xml = Nokogiri::XML(File.open(file.tempfile))
    xml.xpath("subgrupos/subgrupo").each do |item|
      Subgroup.create(code: item['id'].to_i,
                      name: item.xpath("descricao").text)
    end
  end
end
