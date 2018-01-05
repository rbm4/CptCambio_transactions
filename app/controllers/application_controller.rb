class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :teste_ping
  helper_method :verify_key
  
  def verify_key
    decipher = OpenSSL::Cipher::AES.new(128, :CBC)
    decipher.decrypt
    decipher.key = ENV["CIPHER_RANDOM"]
    decipher.iv = ENV["CIPHER_IV"]
    
    plain = decipher.update(params[:message]) + decipher.final
    @params = eval(plain)
    if @params['key'] == ENV["TRANSACTION_KEY"]
      true
    else
      false
    end
  end
  
  def teste_ping
    #uri = URI('https://cpttransactions.herokuapp.com/add_users')
    #req = Net::HTTP::Post.new(uri)
    #req.set_form_data('from' => '2005-01-01', 'to' => '2005-03-31')
    #req.use_ssl = true

    #res = Net::HTTP.start(uri.hostname, uri.port) do |http|
    #  http.request(req)
    #end
    #p res.body
    
    
  end
end
