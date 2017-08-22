class NotificationsController < ApplicationController
    skip_before_action :verify_authenticity_token, :only => [:add_users]
    def add_users #adicionar usuários originais para o banco
        a = User.find_by_name(params["name"])
        if a == nil
            b = User.new
            b.username = params["username"]
            b.id_original = params["id_original"]
            b.email = params["email"]
            b.name = params["name"]
            b.save
            p "usuario #{b.username} adicionado."
        else
            p "usuario #{a.username} ja existe"
        end
        render "/"
    end
    def create_transaction #registrar 1 entrada e 1 saída de transação entre os usuários dependendo do tipo de transação
    end
    def add_saldo #adicionar saldo aos usuários a partir de notificações de depósito enviadas da aplicação original
    end
    def withdrawal_saldo #remover saldo dos usuários a partir de notificações de retiradas enviadas da aplicação original
    end
end
