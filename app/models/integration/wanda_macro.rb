class Integration::WandaMacro < Integration
  def initialize
      @file = Rails.root.join("public/files/wanda.csv")
  end

  def update
    n=0

    CSV.foreach(@file, headers: true,
                encoding: 'iso-8859-1:utf-8',
                col_sep: ';',
                row_sep: :auto) do |row|
      version = row[3]
      alternative = row[4]
      date = row[2]
      start_year = row[5]
      end_year = row[6]

      code = row[0]
      description = row[1]
      recipient = "900 ML"
      price = row[7].to_f

      if (price > 0)
        ink = Wanda::Ink.where(
          {
              description: description,
              code: code,
              price: price,
              recipient: recipient
          }
        ).first
        
        if ink
          ink.update({
            version: version,
            alternative: alternative,
            start_year: start_year,
            end_year: end_year,
            date: date
          })
        end
      end

      n+=1
      # break if n > 2140
    end
  end

  def read
    # Integration::WandaMacro.new.read

    n=0

    CSV.foreach(@file, headers: true,
                encoding: 'iso-8859-1:utf-8',
                col_sep: ';',
                row_sep: :auto) do |row|
        printf "."
        if (n > 300000)
          #   line = row.to_hash
            printf "#{n}"
          
            code = row[0]
            description = row[1]
            recipient = "900 ML"
            price = row[7].to_f

            if (price > 0)
              ink = Wanda::Ink.where(
                {
                    description: description,
                    code: code,
                    price: price,
                    recipient: recipient,
                    # product: product,
                    # base: base
                }
              ).first_or_create
            end
        end

        n+=1
        break if n > 2140
    end

    #   ProductBaseItem.populate!
  end
end