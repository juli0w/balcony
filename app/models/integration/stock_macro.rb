class StockMacro
  def self.uncheck stock_id
    StockCount.where(stock_id: stock_id).update(checked: false)
  end
  def self.reset stock_id
    stock = Stock.find(stock_id)

    Item.all.first(333).each do |item|
      # s = StockItem.where(stock_id: stock_id, item_id: item.id).first_or_create

      quantity = stock.of_item(item.id)

      new_output = 0 - quantity.to_f

      if quantity > 0
        type = "out"
        q = quantity
      else
        type = "in"
        q = new_output
      end

      n = StockChange.create(
        state: type,
        quantity: q,
        stock_id: stock_id,
        item_id: item.id,
        observation: "Reset do estoque [Automático]"
      )

      n.push!
      
      puts "#{stock_id}: #{item.name} [#{quantity} -> #{new_output}]"
      
      
    end
  end
end