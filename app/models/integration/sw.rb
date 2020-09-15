class Integration::Sw < Integration
    def initialize
        @file = Rails.root.join("public/files/SW.txt")
    end

    def read
        # Integration::Sw.new.read

        n=0
        CSV.foreach(@file, headers: true,
                    encoding: 'iso-8859-1:utf-8',
                    col_sep: ';',
                    row_sep: :auto) do |row|
            if (n > 1000000)     
                line = row.to_hash
                
                dye_name     = line["CORANTE"]
                dye          = Dye.where(name: dye_name).first_or_create

                product_name = line["PRODUTO"]
                product      = SwProduct.where(name: product_name).first_or_create

                base_name    = line["BASE"]
                base         = SwBase.where(name: base_name).first_or_create

                capacity     = line["CAPACIDADE"]
                recipient    = SwRecipient.where(name: line["EMBALAGEM"],
                                                capacity: capacity).first_or_create
                    
                    ink = Ink.where(collection: line["COLECAO"],
                                    code: line["COD_COR"],
                                    name: line["NOME_COR"],
                                    message: line["MSG_AVISO"],
                                    sw_product: product,
                                    sw_base: base,
                                    sw_recipient: recipient).first_or_create
                        
                quantity     = line["MLS"]
                ink.dye_inks.where(dye: dye, quantity: quantity).first_or_create

            end

            n+=1
            # break if n > 4000
        end

        ProductBaseItem.populate!
    end
end