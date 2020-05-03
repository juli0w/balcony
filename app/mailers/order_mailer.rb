class OrderMailer < ApplicationMailer
    def new_order
        # @order = Order.find(params[:order_id])

        mail(to: ["julioabudal@gmail.com", "bizumultas@gmail.com"], subject: "Novo pedido!")
    end
end
