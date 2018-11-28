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
      density = row[2].to_s.to_d
      rgb     = row[4].to_s

      if code != "ColorantCode"
        puts "#{code}: #{name} - #{rgb}"
        rbase = Rbase.where(code: code).first_or_create
        rbase.name    = name
        rbase.density = density
        rbase.rgb     = rgb
        rbase.save
      end
    end
  end

  def import_products worksheet
    puts "Updating products"
    worksheet.each_row_streaming(pad_cells: true, offset: 1) do |row|
      code    = row[0].to_s
      base    = row[2].to_s
      density = row[4].to_s.to_d
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

        c1 = row[11].to_s
        q1 = row[12].to_s

        c2 = row[13].to_s
        q2 = row[14].to_s

        c3 = row[15].to_s
        q3 = row[16].to_s

        c4 = row[17].to_s
        q4 = row[18].to_s

        c5 = row[19].to_s
        q5 = row[20].to_s

        c6 = row[21].to_s
        q6 = row[22].to_s

        rgb   = row[23].to_s
        notes = row[26].to_s


        puts "#{line} #{base} #{color}"
        rproduct = Rproduct.find_by_code(pcode)
        rformula = Rformula.where(line: line, base: base, color: color, rproduct_id: rproduct.id).first_or_create

        rformula.rcolor = Rcolor.where(name: color).first_or_create
        rformula.rline  = Rline.where(name: line).first_or_create

        rformula.c1 = c1
        rformula.q1 = q1.to_d

        rformula.c2 = c2
        rformula.q2 = q2

        rformula.c3 = c3
        rformula.q3 = q3

        rformula.c4 = c4
        rformula.q4 = q4

        rformula.c5 = c5
        rformula.q5 = q5

        rformula.c6 = c6
        rformula.q6 = q6

        rformula.rgb   = rgb
        rformula.notes = notes
        rformula.save
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
