class TintasController < ApplicationController
    before_action :authenticate_user!
    before_action :set_client
    before_action :set_cart_variables, only: [:wanda, :sw]

    def wanda
        if params[:color].blank?
            @inks = []
        else
            @inks = Wanda::Ink

            @inks = @inks.where(version: params[:version]) unless params[:version].blank?
            @inks = @inks.where(alternative: params[:alternative]) unless params[:alternative].blank?
            @inks = @inks.where(start_year: params[:start_year]) unless params[:start_year].blank?
            @inks = @inks.where(end_year: params[:end_year]) unless params[:end_year].blank?

            @inks = @inks.search(params[:color])

            @inks = @inks.select { |i| i.price > 0 }.first(30)
        end
    end

    def sw
        if params[:color].blank?
            @inks = []
        else
            @inks = Ink.search(params[:color])

            @inks = @inks.
                where(sw_recipient_id: params[:sw_recipient_id]) unless params[:sw_recipient_id].blank?

            @inks = @inks.
                where(sw_product_id: params[:sw_product_id]) unless params[:sw_product_id].blank?
        
            @inks = @inks.select { |i| i.price > 0 }.first(30)
        end

        # render text: @inks
    end

private

    def set_client
        if current_user.client?
            client = Client.where(company: current_user.username).first_or_create(section: Section.last, name: current_user.username)
            session[:client] = client.id
        end
    
        if session[:client].blank?
            session[:client] = Client.where(company: current_user.username).first_or_create(section: Section.last, name: current_user.username).id
        end

        @client = Client.find(session[:client])
    end
  end
  