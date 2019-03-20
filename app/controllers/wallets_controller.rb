class WalletsController < ApplicationController
  before_action :authenticate_user!
  require 'net/http'
  require 'json'

  def index
    @wallets = current_user.wallets
    @wallets_data = wallets_data(@wallets.map{|w| w.address})
  end

  def show
    @wallet = Wallet.find params["id"]
    @wallet_data = wallet_data(@wallet.address)
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

  end

  def wallets_data(wallets_addresses)
    url = "https://api.etherscan.io/api?module=account&action=balancemulti&address=" + wallets_addresses.join(',') + "&tag=latest"
    uri = URI(url)
    response = Net::HTTP.get(uri)

    JSON.parse(response).try(:[], "result")
  end

  def wallet_data(wallet_address)
    url = "http://api.etherscan.io/api?module=account&action=txlist&address=" + wallet_address + "&startblock=0&endblock=99999999&sort=asc"
    uri = URI(url)
    response = Net::HTTP.get(uri)

    # byebug

    JSON.parse(response).try(:[], "result")
end

  private
    def wallet_params
      params.require(:wallet).permit(:address)
    end
end