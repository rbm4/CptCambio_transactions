class NotificationsController < ApplicationController
    skip_before_action :verify_authenticity_token, :only => [:add_users,:create_transaction_exchange]
    def add_users #adicionar usuários originais para o banco
        @message = ""
        a = User.find_by_username(params["username"])
        if a == nil
            b = User.new
            b.username = params["username"]
            b.id_original = params["id_original"]
            b.email = params["email"]
            b.name = params["name"]
            b.save
            @message << "usuario #{b.username} adicionado.\n"
        else
            @message << "usuario #{a.username} ja existe\n"
        end
        
    end
    def create_transaction_exchange 
    #registrar 1 entrada e 1 saída de transação entre os usuários dependendo do tipo de transação da exchange, 
    #deverá adicionar saldo para um usuário, tirar de outro e registrar a quantidade de valor em taxas arrecadado
        @message = ""
        #validar se a requisição vem da aplicação principal
        a = Operation.new
        a.currency = params["currency"]
        a.type = params["type"]
        a.user_id = params["user_id"]
        if params["debit_credit"] == true #true = contabilizar crédito
            a.debit_credit = "sum"
        elsif params["debit_credit"] == false #false = descontar crédito
            a.debit_credit = "sub"
        end
        a.amount = params['amount']
        if a.save
            @message << "transação salva."
        else
            @message << "transação não salva."
        end
    end
    def add_saldo #adicionar saldo aos usuários a partir de notificações de depósito enviadas da aplicação original
    end
    def withdrawal_saldo #remover saldo dos usuários a partir de notificações de retiradas enviadas da aplicação original
    end
end
