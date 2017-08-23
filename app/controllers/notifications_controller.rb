class NotificationsController < ApplicationController
    skip_before_action :verify_authenticity_token, :only => [:add_users,:create_transaction_exchange,:get_saldo]
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
    def get_saldo
        p "get saldo"
        saldo_brl = BigDecimal(0,10)
        saldo_btc = BigDecimal(0,10)
        saldo_ltc = BigDecimal(0,10)
        saldo_doge = BigDecimal(0,10)
        @message = ""
        if params["username"] != nil
            p "usuario => #{params["username"]}"
            user = User.find_by_username(params["username"])
            p user
            if String(user.id_original) == params["id_original"].to_s
                p "usuario existe"
                k = Operation.where("user_id = :id_original", {id_original: user.id_original.to_s})
                p "verificando operações"
                p k.any?
                if k.any? 
                    p "k é não nulo"
                    k.each do |l|
                        if l.currency == "btc"
                            if l.debit_credit == true #somar
                                saldo_btc = saldo_btc + l.amount
                            elsif l.debit_credit == false #subtrair
                                saldo_btc = saldo_btc - l.amount
                            end
                        elsif l.currency == "ltc"
                            if l.debit_credit == true #somar
                                saldo_ltc = saldo_ltc + l.amount
                            elsif l.debit_credit == false #subtrair
                                saldo_ltc = saldo_ltc - l.amount
                            end
                        elsif l.currency == "doge"
                            if l.debit_credit == true #somar
                                saldo_doge = saldo_doge + l.amount
                            elsif l.debit_credit == false #subtrair
                                saldo_doge = saldo_doge - l.amount
                            end
                        elsif l.currency == "brl"
                            if l.debit_credit == true #somar
                                saldo_brl = saldo_brl + l.amount
                            elsif l.debit_credit == false #subtrair
                                saldo_brl = saldo_brl - l.amount
                            end
                        end
                    end
                    render plain: "{'BRL' => #{saldo_brl.to_s}, 'BTC' => #{saldo_btc.to_s}, 'LTC' => #{saldo_ltc.to_s}, 'DOGE' => #{saldo_doge.to_s}}"
                else
                    @messages << "{'BRL' => 0, 'BTC' => 0, 'LTC' => 0, 'DOGE' => 0}"
                    p "nenhuma operação para esse usuario"
                    render plain: @messages
                end
            else
                
                @messages << "Saldo não validado."
            end
        end
    end
end
