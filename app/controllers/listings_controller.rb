class ListingsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_vendedor!

  def index
    @listings = Listing.all
  end

  def show
    @listing = Listing.find(params[:id])

    @items = @listing.items.map {|l| Item.where(code: l) }
    render layout: nil
  end
end
