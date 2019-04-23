require 'roo'
require 'uri'
require 'csv'

class Resicolor
  attr_accessor :file, :formula

  def initialize params, formula=nil
    self.file = params
    self.formula = formula
  end

  def self.reset!
  end

  def import
    import!
  end

private

  def import!
    if file
      workbook = Roo::Spreadsheet.open(file.tempfile, extension: :xlsx)

      worksheets = workbook.sheets
      puts "Found #{worksheets.count} worksheets"

      import_colorants(workbook.sheet(0))
      import_products (workbook.sheet(1))
    end

    import_formulas(formula) if formula
  end

  def import_colorants worksheet
    puts "Updating colorants"
    worksheet.each_row_streaming(pad_cells: true, offset: 1) do |row|
      code    = row[0].to_s
      name    = row[1].to_s
      density = row[2].value
      rgb     = row[4].to_s

      if code != "ColorantCode"
        puts "#{code}: #{name} - #{density}[#{row[2].to_s}]"
        rbase = Rbase.where(code: code).first_or_create
        rbase.name    = name
        rbase.density = density
        rbase.rgb     = rgb
        puts rbase.save
      end
    end
  end

  def import_products worksheet
    puts "Updating products"
    worksheet.each_row_streaming(pad_cells: true, offset: 1) do |row|
      code    = row[0].to_s
      base    = row[2].to_s
      density = row[4].value
      can     = row[5].to_s

      if code != "Product Code"
        puts "#{code}: #{base} - #{density} - #{can}"
        rproduct = Rproduct.where(code: code, base: base ,can: can).first_or_create
        rproduct.density = density
        rproduct.save
      end
    end
  end

  def import_formulas formula
    puts 'Opening formulas'
    count = 0
    ActiveRecord::Base.transaction do
      CSV.foreach(formula.tempfile, headers: true) do |row|
        # return if (count+=1) >= 1550

        line  = row[0].to_s
        pcode = row[4].to_s
        base  = row[6].to_s
        color = row[8].to_s

        c = []
        q = []

        c[0] = row[11].to_s
        q[0] = row[12].to_s.gsub(",", ".")

        c[1] = row[13].to_s
        q[1] = row[14].to_s.gsub(",", ".")

        c[2] = row[15].to_s
        q[2] = row[16].to_s.gsub(",", ".")

        c[3] = row[17].to_s
        q[3] = row[18].to_s.gsub(",", ".")

        c[4] = row[19].to_s
        q[4] = row[20].to_s.gsub(",", ".")

        c[5] = row[21].to_s
        q[5] = row[22].to_s.gsub(",", ".")

        rgb   = row[23].to_s
        notes = row[26].to_s

        tinta_produto = TintaProduto.where(fabricante_id: 2, descricao: line.split(' - ')[1]).first_or_create
        tacabamento = TintaAcabamento.where('descricao LIKE ?', "%#{TintaAcabamento::INTEGRATION[pcode]}%").first

        tinta_acabamento = TintaAcabamento.where(descricao: tacabamento.descricao, fabricante_id: 2,
                                                 tinta_produto_id: tinta_produto.id).first_or_create

        tinta_cor = TintaCor.where({
            fabricante_id: 2,
            descricao: color.split(" - ")[0],
            tinta_acabamento_id: tinta_acabamento.id
          }).first_or_create

        if tinta_cor
          formula = "[#{TintaPigmento.find_by_codigo(c[0]).tinta_pigmento_id}:#{q[0]}]"
          (1..5).each do |n|
            unless c[n].blank?
              formula << ";[#{TintaPigmento.find_by_codigo(c[n]).tinta_pigmento_id}:#{q[n]}]"
            end
          end

          tinta_cor.update({
            formula: formula
          })
        end

        # rproduct = Rproduct.find_by_code(pcode)
        # rformula = Rformula.where(line: line, base: base, color: color, rproduct_id: rproduct.id).first_or_create
        #
        # rformula.rcolor = Rcolor.where(name: color).first_or_create
        # rformula.rline  = Rline.where(name: line).first_or_create
        #
        # rformula.c1 = c1
        # rformula.q1 = q1
        #
        # rformula.c2 = c2
        # rformula.q2 = q2
        #
        # rformula.c3 = c3
        # rformula.q3 = q3
        #
        # rformula.c4 = c4
        # rformula.q4 = q4
        #
        # rformula.c5 = c5
        # rformula.q5 = q5
        #
        # rformula.c6 = c6
        # rformula.q6 = q6
        #
        # rformula.rgb   = rgb
        # rformula.notes = notes
        # rformula.save
      end
    end
  end


  # def import_formulas formula
  #   puts "Updating formulas"
  #   count = 0
  #   worksheet.each_row_streaming(pad_cells: true, offset: 1) do |row|
  #     return if (count+=1) == 100
  #     line  = row[0].to_s
  #     pcode = row[4].to_s
  #     base  = row[6].to_s
  #     color = row[8].to_s
  #
  #     c1 = row[11].to_s
  #     q1 = row[12].to_s
  #
  #     c2 = row[13].to_s
  #     q2 = row[14].to_s
  #
  #     c3 = row[15].to_s
  #     q3 = row[16].to_s
  #
  #     c4 = row[17].to_s
  #     q4 = row[18].to_s
  #
  #     c5 = row[19].to_s
  #     q5 = row[20].to_s
  #
  #     c6 = row[21].to_s
  #     q6 = row[22].to_s
  #
  #     rgb   = row[23].to_s
  #     notes = row[26].to_s
  #
  #     puts "#{line} #{base} #{color}"
  #     rproduct = Rproduct.find_by_code(pcode)
  #     rformula = Rformula.where(line: line, base: base, color: color, rproduct_id: rproduct.id).first_or_create
  #     rformula.c1 = c1
  #     rformula.q1 = q1
  #
  #     rformula.c2 = c2
  #     rformula.q2 = q2
  #
  #     rformula.c3 = c3
  #     rformula.q3 = q3
  #
  #     rformula.c4 = c4
  #     rformula.q4 = q4
  #
  #     rformula.c5 = c5
  #     rformula.q5 = q5
  #
  #     rformula.c6 = c6
  #     rformula.q6 = q6
  #
  #     rformula.rgb   = rgb
  #     rformula.notes = notes
  #     rformula.save
  #   end
  # end
end
