class Api::V1::UsersController < ApplicationController
    before_action :verify_key, only: [:create], raise: false
    before_action :authenticate_request, only: [:show,:saldos], raise: false
    skip_before_action :verify_authenticity_token
    
    def show
        user = Auser.find(params[:id])
        
        render(json: user)
    end
    def create #função de API para tratar os users vindos do PayPortal
        user = Auser.new(email: @params['email'], password: @params['password'], name: @params['name'])
        if user.save
            render(json: user, status: :ok)
        else
            render(text: string, status: 406)
        end
    end
    def saldos
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
            saldo_xrp = BigDecimal(0,10)
            @message = ""
            user = Auser.find_by_email(params["email"])
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
                        elsif l.currency == "XRP"
                            if l.debit_credit == true #somar
                                saldo_xrp = saldo_xrp + amount
                            elsif l.debit_credit == false #subtrair
                                saldo_xrp = saldo_xrp - amount
                            end
                        elsif l.currency == "ZEC"
                            if l.debit_credit == true #somar
                                saldo_zec = saldo_zec + amount
                            elsif l.debit_credit == false #subtrair
                                saldo_zec = saldo_zec - amount
                            end
                        elsif l.currency == "DGB"
                            if l.debit_credit == true #somar
                                saldo_dgb = saldo_dgb + amount
                            elsif l.debit_credit == false #subtrair
                                saldo_dgb = saldo_dgb - amount
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
                        end
                    end
                    render plain: "{'BRL' => '#{saldo_brl.to_s}', 'BTC' => '#{saldo_btc.to_s}', 'LTC' => '#{saldo_ltc.to_s}', 'DOGE' => '#{saldo_doge.to_s}', 'ETH' => '#{saldo_eth.to_s}', 'BCH' => '#{saldo_bch.to_s}', 'XMR' => '#{saldo_xmr.to_s}', 'DASH' => '#{saldo_dash.to_s}'}"
                    return
                else
                    p "nenhuma operação para esse usuario"
                    render plain: "{'BRL' => 0.0, 'BTC' => 0.0, 'LTC' => 0.0, 'DOGE' => 0.0, 'ETH' => 0.0, 'XMR' => 0.0, 'DASH' => 0.0, 'BCH' => 0.0}"
                    return
                end
            else
                p "Saldo não validado. "
                render plain: "{'BRL' => 0.0, 'BTC' => 0.0, 'LTC' => 0.0, 'DOGE' => 0.0, 'ETH' => 0.0, 'XMR' => 0.0, 'DASH' => 0.0, 'BCH' => 0.0}"
                return
            end
            
            p "Usuário genérico não relacionado em local algum"
            render plain: "{'BRL' => 0.0, 'BTC' => 0.0, 'LTC' => 0.0, 'DOGE' => 0.0, 'ETH' => 0.0, 'XMR' => 0.0, 'DASH' => 0.0, 'BCH' => 0.0}"
            return
        rescue
            render plain: "{'status' => 'something went wrong'}"
        end
    end
end