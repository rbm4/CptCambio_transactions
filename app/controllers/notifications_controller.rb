class NotificationsController < ApplicationController
    before_action :verify_key
    skip_before_action :verify_authenticity_token, :only => [:add_users,:create_transaction_exchange,:get_saldo,:add_saldo,:update_user]
    def add_users #adicionar usuários originais para o banco
        @message = ""
        a = User.find_by_id_original(@params["id_original"])
        if a == nil
            b = User.new
            b.username = @params["username"]
            b.id_original = @params["id_original"]
            b.email = @params["email"]
            b.name = @params["name"]
            b.save
            @message << "usuario #{b.username} adicionado.\n"
        else
            @message << "usuario #{a.username} ja existe\n"
            render status: 409
        end
        
    end
    def create_transaction_exchange 
        #registrar 1 entrada e 1 saída de transação entre os usuários dependendo do tipo de transação da exchange, 
        #deverá adicionar saldo para um usuário, tirar de outro e registrar a quantidade de valor em taxas arrecadado
        @message = ""
        #validar se a requisição vem da aplicação principal
        a = Operation.new
        a.currency = @params["currency"]
        a.tipo = @params["type"]
        if @params["user_id"].nil?
            a.auser_id = @params["auser_id"]
        else
            a.user_id = @params["user_id"]
        end
        
        #true = contabilizar crédito
        #false = subtrair crédito
        a.debit_credit = @params["debit_credit"]
        
        a.amount = @params['amount']
        if a.save
            @message << "transação salva."
        else
            @message << "transação não salva."
        end
    end
    def add_saldo #adicionar saldo aos usuários a partir de notificações de depósito enviadas da aplicação original
        begin
            returno = ""
            #validar comunicação
            user = User.find_by_email(@params["email"])
            if user != nil 
                a = user.operation.new
                a.currency = @params["currency"].upcase
                a.tipo = @params["type"]
                if a.tipo == "exchange_sell" or a.tipo == "withdrawal" or a.tipo == "exchange_buy"
                    a.debit_credit = false
                else
                    a.debit_credit = true
                end
                a.amount = @params["amount"]
                a.save
                returno << a.id
                render plain: "{'status' => 'ok', 'id' => #{a.id}}"
            else
                p returno << "usuario nao existe ou o id_original esta errado."
                render plain: "{'status' => 'usuario invalido'}"
            end
        rescue
            p 'Something went wrong'
            render plain: "{'status' => 'Something went wrong'}"
        end
    end
    def withdrawal_saldo #remover saldo dos usuários a partir de notificações de retiradas enviadas da aplicação original
    end
    def get_saldo
        begin
            saldo_brl = BigDecimal(0,10)
            saldo_xmr = BigDecimal(0,10)
            saldo_bch = BigDecimal(0,10)
            saldo_btc = BigDecimal(0,10)
            saldo_dash = BigDecimal(0,10)
            saldo_ltc = BigDecimal(0,10)
            saldo_doge = BigDecimal(0,10)
            saldo_eth = BigDecimal(0,10)
            saldo_dgb = BigDecimal(0,10)
            saldo_zec = BigDecimal(0,10)
            @message = ""
            user = User.find_by_id_original(@params["id_original"])
            if !user.nil?
                k = user.operation.all
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
                        elsif l.currency == "XMR"
                            if l.debit_credit == true #somar
                                saldo_xmr = saldo_xmr + amount
                            elsif l.debit_credit == false #subtrair
                                saldo_xmr = saldo_xmr - amount
                            end
                        elsif l.currency == "BCH"
                            if l.debit_credit == true #somar
                                saldo_bch = saldo_bch + amount
                            elsif l.debit_credit == false #subtrair
                                saldo_bch = saldo_bch - amount
                            end
                        elsif l.currency == "DASH"
                            if l.debit_credit == true #somar
                                saldo_dash = saldo_dash + amount
                            elsif l.debit_credit == false #subtrair
                                saldo_dash = saldo_dash - amount
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
                        elsif l.currency == "DGB"
                            if l.debit_credit == true #somar
                                saldo_dgb = saldo_dgb + amount
                            elsif l.debit_credit == false #subtrair
                                saldo_dgb = saldo_dgb - amount
                            end
                        elsif l.currency == "ZEC"
                            if l.debit_credit == true #somar
                                saldo_zec = saldo_zec + amount
                            elsif l.debit_credit == false #subtrair
                                saldo_zec = saldo_zec - amount
                            end
                        end
                    end
                    render plain: "{'BRL' => '#{saldo_brl.to_s}', 'BTC' => '#{saldo_btc.to_s}', 'LTC' => '#{saldo_ltc.to_s}', 'DOGE' => '#{saldo_doge.to_s}', 'ETH' => '#{saldo_eth.to_s}', 'BCH' => '#{saldo_bch.to_s}', 'XMR' => '#{saldo_xmr.to_s}', 'DASH' => '#{saldo_dash.to_s}', 'DGB' => '#{saldo_dgb.to_s}', 'ZEC' => '#{saldo_zec.to_s}'}"
                    return
                else
                    p "nenhuma operação para esse usuario"
                    render plain: "{'BRL' => 0.0, 'BTC' => 0.0, 'LTC' => 0.0, 'DOGE' => 0.0, 'ETH' => 0.0, 'XMR' => 0.0, 'DASH' => 0.0, 'BCH' => 0.0, 'DGB' => 0.0, 'ZEC' => 0.0}"
                    return
                end
            else
                p "Saldo não validado. "
                render plain: "{'BRL' => 0.0, 'BTC' => 0.0, 'LTC' => 0.0, 'DOGE' => 0.0, 'ETH' => 0.0, 'XMR' => 0.0, 'DASH' => 0.0, 'BCH' => 0.0, 'DGB' => 0.0, 'ZEC' => 0.0}"
                return
            end
            
            p "Usuário genérico não relacionado em local algum"
            render plain: "{'BRL' => 0.0, 'BTC' => 0.0, 'LTC' => 0.0, 'DOGE' => 0.0, 'ETH' => 0.0, 'XMR' => 0.0, 'DASH' => 0.0, 'BCH' => 0.0, 'DGB' => 0.0, 'ZEC' => 0.0}"
            return
        rescue
            render plain: "{'status' => 'something went wrong'}"
        end
    end
    def update_user
        @message = ""
        a = User.find_by_id_original(@params["id_original"])
        if a == nil
            b = User.new
            b.username = @params["username"]
            b.email = @params["email"]
            b.id_original = @params["id_original"]
            b.name = @params["name"]
            b.save
            @message << "usuario #{b.username} adicionado.\n"
        else
            b = User.find_by_id_original(@params["id_original"])
            b.username = @params["username"]
            b.email = @params["email"]
            b.id_original = @params["id_original"]
            b.name = @params["name"]
            b.save
            @message << "usuario #{a.username} ja existe, atualizado\n"
        end
    end
    
end