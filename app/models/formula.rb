require 'csv'
class Formula
  attr_accessor :tinta_pigmento, :tinta_embalagem, :tinta_base,
                :tinta_acabamento, :tinta_produto, :tinta_cor,
                :tinta_base_item, :tinta_pigmento_item

  def initialize params
    self.tinta_pigmento = params[:tinta_pigmento]
    self.tinta_embalagem = params[:tinta_embalagem]
    self.tinta_base = params[:tinta_base]
    self.tinta_acabamento = params[:tinta_acabamento]
    self.tinta_produto = params[:tinta_produto]
    self.tinta_cor = params[:tinta_cor]
    self.tinta_base_item = params[:tinta_base_item]
    self.tinta_pigmento_item = params[:tinta_pigmento_item]
  end

  def import
    import!
  end

  def import!
    Fabricante.where(name: "Sherwin Williams", fabricante_id: 1).first_or_create
    Fabricante.where(name: "Resicolor", fabricante_id: 2).first_or_create

    Formula.import_tinta_pigmento self.tinta_pigmento if self.tinta_pigmento
    Formula.import_tinta_embalagem self.tinta_embalagem if self.tinta_embalagem
    Formula.import_tinta_base self.tinta_base if self.tinta_base
    Formula.import_tinta_produto self.tinta_produto if self.tinta_produto
    Formula.import_tinta_acabamento self.tinta_acabamento if self.tinta_acabamento
    Formula.import_tinta_cor self.tinta_cor if self.tinta_cor
    Formula.import_tinta_acabamento_base_item self.tinta_base_item if self.tinta_base_item
    Formula.import_tinta_pigmento_item self.tinta_pigmento_item if self.tinta_pigmento_item

    Formula.update_base_prices!
    # Formula.update_resicolor_2018!
  end

private

  def self.update_resicolor_2018
    tinta_produto = TintaProduto.first_or_create(descricao: "RESICOLOR 2018", fabricante_id: 2)
    Rformula.where(line: "A - COLEÇAO RESICOLOR 2018").each do |rformula|
      t_a_d = TintaAcabamento.where('descricao LIKE ?', "%#{TintaAcabamento::INTEGRATION[rformula.rproduct.code]}%").first.descricao

      TintaAcabamento.where(descricao: t_a_d,
                            tinta_produto_id: tinta_produto.id)

                c = []
                q = []

                c[0] = rformula.c1
                q[0] = rformula.q1

                c[1] = rformula.c2
                q[1] = rformula.q2

                c[2] = rformula.c3
                q[2] = rformula.q3

                c[3] = rformula.c4
                q[3] = rformula.q4

                c[4] = rformula.c5
                q[4] = rformula.q5

                c[5] = rformula.c6
                q[5] = rformula.q6

      # # #
        formula = "[#{TintaPigmento.find_by_codigo(c[0]).tinta_pigmento_id}:#{q[0]}]"
        (1..5).each do |n|
          unless c[n].blank?
            formula << ";[#{TintaPigmento.find_by_codigo(c[n]).tinta_pigmento_id}:#{q[n]}]"
          end
        end
      # # #

      TintaCor.first_or_create({
          codigo: rformula.color.split(" - ")[0]
        })
    end
  end

  def self.update_base_prices!
    Rbase.all.each do |rbase|
      TintaPigmento.where(codigo: rbase.code).first.update(price: rbase.price)
    end
  end

  def self.import_tinta_acabamento_base_item file
    puts 'Importando Acabamento Base Item'
    count = 0
    ActiveRecord::Base.transaction do
      CSV.foreach(file.tempfile, headers: true, col_sep: ';') do |row|
        tinta_acabamento_id = TintaAcabamento.find_by_tinta_acabamento_id(row[0].to_i).id
        tinta_base_id = TintaBase.find_by_tinta_base_id(row[1].to_i).id
        tinta_embalagem_id = TintaEmbalagem.find_by_tinta_embalagem_id(row[2].to_i).id
        codigo_numerico = row[3].to_s
        item_id = Item.find_by_code(codigo_numerico.to_i).try(:id)

        tinta_acabamento_base_item = TintaAcabamentoBaseItem.where(
              tinta_acabamento_id: tinta_acabamento_id,
              tinta_base_id: tinta_base_id,
              tinta_embalagem_id: tinta_embalagem_id
        ).first_or_create

        tinta_acabamento_base_item.update(item_id: item_id)
      end
    end
  end

  def self.import_tinta_pigmento_item file
    puts 'Importando Pigmento Item'
    count = 0
    ActiveRecord::Base.transaction do
      CSV.foreach(file.tempfile, headers: true, col_sep: ';') do |row|
        tinta_pigmento_item_id = row[0].to_s
        tinta_pigmento_id = TintaPigmento.find_by_tinta_pigmento_id(row[1].to_i).id
        codigo_numerico = row[2].to_s
        item_id = Item.find_by_code(codigo_numerico.to_i).try(:id)

        tinta_pigmento_item = TintaPigmentoItem.where(tinta_pigmento_item_id: tinta_pigmento_item_id).first_or_create

        tinta_pigmento_item.update(tinta_pigmento_id: tinta_pigmento_id,
                                   codigo_numerico: codigo_numerico,
                                   item_id: item_id)

      end
    end
  end

  def self.import_tinta_cor file
    puts 'Importando Cores'
    count = 0
    # ActiveRecord::Base.transaction do
      CSV.foreach(file.tempfile, headers: true, quote_char: "\"", col_sep: ';') do |row|
        # count += 1
        # break if count > 150200

        tinta_cor_id = row[0].to_s
        codigo = row[1].to_s
        descricao = row[2].to_s
        tinta_acabamento_id = TintaAcabamento.find_by_tinta_acabamento_id(row[3].to_i).try(:id)
        tinta_base_id = TintaBase.find_by_tinta_base_id(row[4].to_s).try(:id)
        observacao = row[5].to_s
        quantidade = row[6].to_s
        formula = row[7].to_s
        fabricante_id = Fabricante.find_by_fabricante_id(row[8].to_s).try(:id)
        integracao_old = row[9].to_s
        quantidade_old = row[10].to_s

        tinta_cor = TintaCor.where(tinta_cor_id: tinta_cor_id,
                                   codigo: codigo).first_or_create

        tinta_cor.descricao = descricao
        tinta_cor.tinta_acabamento_id = tinta_acabamento_id
        tinta_cor.tinta_base_id = tinta_base_id
        tinta_cor.observacao = observacao
        tinta_cor.quantidade = quantidade
        tinta_cor.formula = formula
        tinta_cor.fabricante_id = fabricante_id
        tinta_cor.integracao_old = integracao_old
        tinta_cor.quantidade_old = quantidade_old

        embalagem_id = {900 => 1, 1 => 1, 4 => 2, 20 => 3, 10000 => 3}[quantidade.to_i]
        tinta_cor.tinta_embalagem = TintaEmbalagem.where(tinta_embalagem_id: embalagem_id).first_or_create

        tinta_cor.quantidade_old = quantidade_old

        tinta_cor.save
      end
    # end
  end

  def self.import_tinta_acabamento file
    puts 'Importando Acabamentos'
    count = 0
    ActiveRecord::Base.transaction do
      CSV.foreach(file.tempfile, headers: true, col_sep: ';') do |row|
        tinta_acabamento_id = row[0].to_s
        descricao = row[1].to_s
        tinta_produto_id = TintaProduto.find_by_tinta_produto_id(row[2].to_i).try(:id)
        integracao_old = row[3].to_s

        tinta_acabamento = TintaAcabamento.where(tinta_acabamento_id: tinta_acabamento_id,
                                                 descricao: descricao,
                                                 tinta_produto_id: tinta_produto_id,
                                                 itnegracao_old: integracao_old).first_or_create

      end
    end
  end

  def self.import_tinta_produto file
    puts 'Importando Produtos'
    count = 0
    ActiveRecord::Base.transaction do
      CSV.foreach(file.tempfile, headers: true, col_sep: ';') do |row|
        tinta_produto_id = row[0].to_s
        descricao = row[1].to_s
        integracao_old = row[2].to_s
        fabricante_id = Fabricante.find_by_fabricante_id(row[3].to_i).try(:id)

        tinta_produto = TintaProduto.where(tinta_produto_id: tinta_produto_id,
                                           descricao: descricao,
                                           integracao_id: integracao_old,
                                           fabricante_id: fabricante_id).first_or_create

      end
    end
  end

  def self.import_tinta_base file
    puts 'Importando Bases'
    count = 0
    ActiveRecord::Base.transaction do
      CSV.foreach(file.tempfile, headers: true, col_sep: ';') do |row|
        tinta_base_id = row[0].to_s
        descricao = row[1].to_s
        integracao_old = row[2].to_s
        fabricante_id = Fabricante.find_by_fabricante_id(row[3].to_i).try(:id)

        tinta_embalagem = TintaBase.where(tinta_base_id: tinta_base_id,
                                          descricao: descricao,
                                          integracao_old: integracao_old,
                                          fabricante_id: fabricante_id).first_or_create

      end
    end
  end

  def self.import_tinta_embalagem file
    puts 'Importando Embalagens'
    count = 0
    ActiveRecord::Base.transaction do
      CSV.foreach(file.tempfile, headers: true, col_sep: ';') do |row|
        tinta_embalagem_id = row[0].to_s
        descricao = row[1].to_s
        quantidade = row[2].to_s.gsub(",", ".")
        quantidade_old = row[3].to_s.gsub(",", ".")

        tinta_embalagem = TintaEmbalagem.where(tinta_embalagem_id: tinta_embalagem_id).first_or_create

        tinta_embalagem.descricao = descricao
        tinta_embalagem.quantidade = quantidade
        tinta_embalagem.quantidade_old = quantidade_old
        tinta_embalagem.save
      end
    end
  end

  def self.import_tinta_pigmento file
    puts 'Importando Pigmentos'
    count = 0
    ActiveRecord::Base.transaction do
      CSV.foreach(file.tempfile, headers: true, col_sep: ';') do |row|
        tinta_pigmento_id = row[0].to_s
        codigo = row[1].to_s
        descricao = row[2].to_s
        integracao_id = row[3].to_s
        fabricante_id = Fabricante.find_by_fabricante_id(row[4].to_i).try(:id)

        # q1 = row[12].to_s.gsub(",", ".")

        tinta_pigmento = TintaPigmento.where(tinta_pigmento_id: tinta_pigmento_id,
                                             codigo: codigo,
                                             descricao: descricao,
                                             fabricante_id: fabricante_id,
                                             integracao_old: integracao_id).first_or_create

        # tinta_pigmento.save
      end
    end
  end
end
