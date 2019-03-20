class WalletsController < ApplicationController
  before_action :authenticate_user!
  require 'net/http'
  require 'json'

  def index
    @wallets = current_user.wallets
    @wallets_data = wallets_data(@wallets.map{|w| w.address})
    @transactions_numbers = @wallets.map do |wallet|
        [wallet.address, wallet_data(wallet.address).length]
    end.to_h
  end

  def show
    @wallet = Wallet.find params["id"]
    @wallet_data = wallet_data(@wallet.address)
    @balance = (wallets_data([@wallet.address]).first["balance"].to_f)/10**18
  end

  def new
  end

  def create
    begin
      c = Wallet.new(wallet_params)
      c.user = current_user
      c.save!
    rescue => e
        flash[:danger] = "save failure"
    end

    redirect_to wallets_path
  end

  def destroy
    Wallet.destroy(params[:id])
    redirect_to wallets_path
  end

  def wallets_data(wallets_addresses)
    url = "https://api.etherscan.io/api?module=account&action=balancemulti&address=" + wallets_addresses.join(',') + "&tag=latest"
    uri = URI(url)
    response = Net::HTTP.get(uri)

    result = JSON.parse(response).try(:[], "result")
    if params["currency"] == "PLN"
        result.each do |transaction|
            transaction["balance"] = transaction["balance"].to_f * 516.87
        end
    end
    result
  end

  def wallet_data(wallet_address)
    url = "http://api.etherscan.io/api?module=account&action=txlist&address=" + wallet_address + "&startblock=0&endblock=99999999&sort=asc"
    uri = URI(url)
    response = Net::HTTP.get(uri)

    result = JSON.parse(response).try(:[], "result")

    if params["currency"] == "PLN"
        result.each do |transaction|
            transaction["value"] = transaction["value"].to_f * 516.87
            transaction["gas"] = transaction["gas"].to_f * 516.87
        end
    end
    
    result
end

  private
    def wallet_params
      params.require(:wallet).permit(:address)
    end
end