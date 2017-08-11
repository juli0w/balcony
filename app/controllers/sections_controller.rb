class SectionsController < ApplicationController
  before_filter :set_section, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def index
    @sections = Section.all
  end

  def show
  end

  def new
    @section = Section.new
  end

  def create
    @section = Section.new(section_params)

    if @section.save
      redirect_to sections_path, notice: "Ramo criado com sucesso"
    else
      flash.now[:alert] = "Por favor verifique os campos."
      render :new
    end
  end

  def edit
  end

  def update
    if @section.update(section_params)
      flash[:success] = "Salvo com sucesso!"
      redirect_to sections_path
    else
      flash.now[:alert] = "Por favor verifique os campos."
      render :edit
    end
  end

  def destroy
    @section.delete

    flash[:success] = "Ramo removido"
    redirect_to sections_path
  end

private

  def set_section
    @section = Section.find(params[:id])
  end

  def section_params
    params.require(:section).permit(:name)
  end
end
