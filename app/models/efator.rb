require 'nokogiri'
class Efator
  attr_accessor :family, :group, :subgroup, :item

  def self.remove_duplicates
    Family.find_each do |sg|
      if sg
        original = Family.where.not(code: nil).where(name: sg.name).first

        if original
          Group.joins(:family).where('families.name = ?', original.name).update_all(family_id: original.id)
          Item.joins(:family).where('families.name = ?', original.name).update_all(family_id: original.id)
          Family.where(code: nil).where(name: sg.name).destroy_all
        end
      end
    end

    # Item.all.each do |i|

    Item.where(code: nil).each do |i|
      
      # itens = Item.where({ code: nil, name: i.name })
      
      # if itens.any?
      itens = Item.where.not(code: nil).where(name: i.name)
        original = itens.first
        if original
        OrderItem.joins(:item).where('items.name = ?', original.name).update_all(item_id: original.id)
        StockItem.joins(:item).where('items.name = ?', original.name).update_all(item_id: original.id)
        ProductBaseItem.joins(:item).where('items.name = ?', original.name).update_all(item_id: original.id)
        Dye.joins(:item).where('items.name = ?', original.name).update_all(item_id: original.id)
        TintaAcabamentoBaseItem.joins(:item).where('items.name = ?', original.name).update_all(item_id: original.id)
        TintaPigmentoItem.joins(:item).where('items.name = ?', original.name).update_all(item_id: original.id)
        Rproduct.joins(:item).where('items.name = ?', original.name).update_all(item_id: original.id)
        Rintegration.joins(:item).where('items.name = ?', original.name).update_all(item_id: original.id)
        StockChange.joins(:item).where('items.name = ?', original.name).update_all(item_id: original.id)
        
        end
        begin
          Item.where({ code: nil, name: i.name }).destroy_all
        rescue
        end
    end

    Group.all.each do |sg|
      original = Group.where.not(code: nil).where(name: sg.name).first

      Item.joins(:group).where('groups.name = ?', original.name).update_all(group_id: original.id)
      sg.destroy if sg.code == nil
    end
  end

  def initialize params
    self.family = params[:family]
    self.group = params[:group]
    self.subgroup = params[:subgroup]
    self.item = params[:item]
  end

  def self.reset!
    # OrderItem.delete_all
    # Order.delete_all
    # Item.delete_all
    # Subgroup.delete_all
    # Group.delete_all
    # Family.delete_all
  end

  def self.import_images
    Dir.glob("#{Rails.root}/public/imagens/*").map do |file|
      item = Item.where(code: File.basename(file).to_i).first

      if item
        item.image = Pathname.new(file).open
        item.save
      end
    end
  end

  def import
    import!
  end

  def import!
    Efator.import_family self.family
    Efator.import_group self.group
    Efator.import_subgroup self.subgroup
    Efator.import_item self.item
  end

private

  def self.import_item file
    return if file.blank?
    xml = Nokogiri::XML(File.open(file.tempfile))

    xml.xpath("itens/item").each do |i|

      # load or create the item
      item = Item.where(code: i.xpath("codigo").text.to_i).first_or_create

      # if i.xpath("codigo").text == "5476"
      #   Rails.logger.info "----------------------------------"
      #   Rails.logger.info item.id
      #   Rails.logger.info item.name
      #   Rails.logger.info i.xpath("precovenda").text
      #   Rails.logger.info item.price.to_s
      #   Rails.logger.info "----------------------------------"
      # else
      #  next
      # end

      # get grupo, subgrupo and familia
      family   = Family.where(code: i.xpath("familia").text).first
      group    = Group.where(code: i.xpath("grupo").text).first
      subgroup = Subgroup.where(code: i.xpath("subgrupo").text).first

      # update item values
      item.name      = i.xpath("descricao").text
      item.family_id = family.try(:id)
      item.group_id  = group.try(:id)
      item.subgroup_id = subgroup.try(:id)
      item.price  = i.xpath("precovenda").text
      item.active = (i.xpath("ativo").text == "true")

      item.save
    end
  end

  def self.import_family file
    xml = Nokogiri::XML(File.open(file.tempfile))
    xml.xpath("familias/familia").each do |item|
      Family.first_or_create(code: item['id'].to_i,
                    name: item.xpath("descricao").text)
    end
  end

  def self.import_group file
    xml = Nokogiri::XML(File.open(file.tempfile))
    xml.xpath("grupos/grupo").each do |item|
      Group.where(code: item['id'].to_i).
            first_or_create(name: item.xpath("descricao").text)
    end
  end

  def self.import_subgroup file
    xml = Nokogiri::XML(File.open(file.tempfile))
    xml.xpath("subgrupos/subgrupo").each do |item|
      Subgroup.where(code: item['id'].to_i).
               first_or_create(name: item.xpath("descricao").text)
    end
  end
end
