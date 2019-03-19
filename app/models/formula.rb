require 'csv'
class Formula
  attr_accessor :tinta_pigmento, :tinta_embalagem, :tinta_base,
                :tinta_acabamento, :tinta_produto, :tinta_cor

  def initialize params
    self.tinta_pigmento = params[:tinta_pigmento]
    self.tinta_embalagem = params[:tinta_embalagem]
    self.tinta_base = params[:tinta_base]
    self.tinta_acabamento = params[:tinta_acabamento]
    self.tinta_produto = params[:tinta_produto]
    self.tinta_cor = params[:tinta_cor]
  end

  def import
    import!
  end

  def import!
    Fabricante.where(name: "Sherwin Williams", fabricante_id: 1).first_or_create
    Fabricante.where(name: "Resicolor", fabricante_id: 2).first_or_create

    Formula.import_tinta_pigmento self.tinta_pigmento
    Formula.import_tinta_embalagem self.tinta_embalagem
    Formula.import_tinta_base self.tinta_base
    Formula.import_tinta_produto self.tinta_produto
    Formula.import_tinta_acabamento self.tinta_acabamento
    Formula.import_tinta_cor self.tinta_cor
  end

private

def self.import_tinta_cor file
  puts 'Importando Cores'
  count = 0
  ActiveRecord::Base.transaction do
    CSV.foreach(file.tempfile, headers: true) do |row|
      tinta_cor_id = row[0].to_s
      codigo = row[1].to_s
      descricao = row[2].to_s
      tinta_acabamento_id = TintaAcabamento.find_by_tinta_acabamento_id(row[3].to_i).try(:id)
      tinta_base_id = TintaBase.find_by_tinta_base_id(row[4].to_s).id
      observacao = row[5].to_s
      quantidade = row[6].to_s
      formula = row[7].to_s
      fabricante_id = Fabricante.find_by_fabricante_id(row[8].to_i).try(:id)
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

      tinta_cor.save
    end
  end
end

  def self.import_tinta_acabamento file
    puts 'Importando Acabamentos'
    count = 0
    ActiveRecord::Base.transaction do
      CSV.foreach(file.tempfile, headers: true) do |row|
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
      CSV.foreach(file.tempfile, headers: true) do |row|
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
      CSV.foreach(file.tempfile, headers: true) do |row|
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
      CSV.foreach(file.tempfile, headers: true) do |row|
        tinta_embalagem_id = row[0].to_s
        descricao = row[1].to_s
        quantidade = row[2].to_s.gsub(",", ".")
        quantidade_old = row[3].to_s.gsub(",", ".")

        tinta_embalagem = TintaEmbalagem.where(tinta_embalagem_id: tinta_embalagem_id,
                                               descricao: descricao,
                                               quantidade: quantidade,
                                               quantidade_old: quantidade_old).first_or_create

      end
    end
  end

  def self.import_tinta_pigmento file
    puts 'Importando Pigmentos'
    count = 0
    ActiveRecord::Base.transaction do
      CSV.foreach(file.tempfile, headers: true) do |row|
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
