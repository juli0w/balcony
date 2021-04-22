class Nfe
    require 'nokogiri'

    attr_accessor :nfe

    def self.import! nfe, stock_id
        return if nfe.blank?

        return openNfe(nfe, stock_id)
    end

    def self.openNfe nfe, stock_id
        xml = Nokogiri::XML(File.open(nfe.tempfile))
        x=[]

        # empresa = xml.css("xFant").text
        nf = xml.css("nNF").text

        xml.css("det").each do |node|
            node.css("prod").each do |a|
                barcode = a.css("cEAN").text
                quantity = a.css("qCom").text
                item = a.css("xProd").text

                @i = Item.where(barcode: barcode).first

                if @i.blank?
                    x << "#{item} (EAN #{barcode})"
                else
                    @stock_change = StockChange.first_or_create({
                        quantity: quantity.to_d.abs,
                        item_id: @i.id,
                        stock_id: stock_id,
                        state: "in",
                        observation: "AUTO: Importação NFE - #{nf}"
                    }).push!
                end
            end
        end

        return x
    end
end