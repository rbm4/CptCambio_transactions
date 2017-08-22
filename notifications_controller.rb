class NotificationsController < ApplicationController
    def add_users #adicionar usuários originais para o banco
        p params
    end
    def create_transaction #registrar 1 entrada e 1 saída de transação entre os usuários dependendo do tipo de transação
    end
    def add_saldo #adicionar saldo aos usuários a partir de notificações de depósito enviadas da aplicação original
    end
    def withdrawal_saldo #remover saldo dos usuários a partir de notificações de retiradas enviadas da aplicação original
    end
end
