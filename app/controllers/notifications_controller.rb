class NotificationsController < ApplicationController
    before_action :verify_key
    skip_before_action :verify_authenticity_token, :only => [:add_users,:create_transaction_exchange,:get_saldo,:add_saldo,:update_user]
    def add_users #adicionar usuários originais para o banco
        @message = ""
        a = User.find_by_id_original(params["id_original"])
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
        a.tipo = params["type"]
        a.user_id = params["user_id"]
        #true = contabilizar crédito
        #false = subtrair crédito
        a.debit_credit = params["debit_credit"]
        
        a.amount = params['amount']
        if a.save
            @message << "transação salva."
        else
            @message << "transação não salva."
        end
    end
    def add_saldo #adicionar saldo aos usuários a partir de notificações de depósito enviadas da aplicação original
        returno = ""
        #validar comunicação
        if params["username"] != nil
            user = User.find_by_username(params["username"])
            if user != nil && String(user.id_original) == String(params["id_original"])
                a = Operation.new
                a.currency = params["currency"].upcase
                a.tipo = params["type"]
                a.user_id = params["id_original"]
                if a.tipo == "exchange_sell" or a.tipo == "withdrawal" or a.tipo == "exchange_buy"
                    a.debit_credit = false
                else
                    a.debit_credit = true
                end
                a.amount = params["amount"]
                a.save
                returno << a.id
            else
                returno << "usuario nao existe ou o id_original esta errado."
            end
        end
        render plain: "#{returno}"
    end
    def withdrawal_saldo #remover saldo dos usuários a partir de notificações de retiradas enviadas da aplicação original
    end
    def get_saldo
        saldo_brl = BigDecimal(0,10)
        saldo_btc = BigDecimal(0,10)
        saldo_ltc = BigDecimal(0,10)
        saldo_doge = BigDecimal(0,10)
        saldo_eth = BigDecimal(0,10)
        @message = ""
        if params["username"] != nil
            user = User.find_by_username(params["username"])
            if (user != nil && String(user.id_original) == String(params["id_original"]))
                k = Operation.where("user_id = :id_original", {id_original: user.id_original.to_s})
                if k.any? 
                    k.each do |l|
                        amount = BigDecimal(l.amount,8)
                        if l.currency == "BTC"
                            if l.debit_credit == true #somar
                                saldo_btc = saldo_btc + amount
                            elsif l.debit_credit == false #subtrair
                                saldo_btc = saldo_btc - amount
                            end
                        elsif l.currency == "LTC"
                            if l.debit_credit == true #somar
                                saldo_ltc = saldo_ltc + amount
                            elsif l.debit_credit == false #subtrair
                                saldo_ltc = saldo_ltc - amount
                            end
                        elsif l.currency == "DOGE"
                            if l.debit_credit == true #somar
                                saldo_doge = saldo_doge + amount
                            elsif l.debit_credit == false #subtrair
                                saldo_doge = saldo_doge - amount
                            end
                        elsif l.currency == "BRL"
                            if l.debit_credit == true #somar
                                saldo_brl = saldo_brl + amount
                            elsif l.debit_credit == false #subtrair
                                saldo_brl = saldo_brl - amount
                            end
                        elsif l.currency == "ETH"
                            if l.debit_credit == true #somar
                                saldo_eth = saldo_eth + amount
                            elsif l.debit_credit == false #subtrair
                                saldo_eth = saldo_eth - amount
                            end
                        end
                    end
                    render plain: "{'BRL' => #{saldo_brl.to_s}, 'BTC' => #{saldo_btc.to_s}, 'LTC' => #{saldo_ltc.to_s}, 'DOGE' => #{saldo_doge.to_s}, 'ETH' => #{saldo_eth.to_s}}"
                    return
                else
                    p "nenhuma operação para esse usuario"
                    render plain: "{'BRL' => 0, 'BTC' => 0, 'LTC' => 0, 'DOGE' => 0, 'ETH' => 0}"
                    return
                end
            else
                p "Saldo não validado. "
                render plain: "{'BRL' => 0, 'BTC' => 0, 'LTC' => 0, 'DOGE' => 0, 'ETH' => 0}"
                return
            end
        end
        p "Usuário genérico não relacionado em local algum"
        render plain: "{'BRL' => 0, 'BTC' => 0, 'LTC' => 0, 'DOGE' => 0, 'ETH' => 0}"
        return
    end
    def update_user
        @message = ""
        a = User.find_by_id_original(params["id_original"])
        if a == nil
            b = User.new
            b.username = params["username"]
            b.email = params["email"]
            b.id_original = params["id_original"]
            b.name = params["name"]
            b.save
            @message << "usuario #{b.username} adicionado.\n"
        else
            b = User.find_by_id_original(params["id_original"])
            b.username = params["username"]
            b.email = params["email"]
            b.id_original = params["id_original"]
            b.name = params["name"]
            b.save
            @message << "usuario #{a.username} ja existe, atualizado\n"
        end
    end
    
end
