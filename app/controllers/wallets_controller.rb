class WalletsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:show, :destroy]
  require 'net/http'
  require 'json'

  def index
    @wallets = current_user.wallets.order(id: :desc)
    @wallets_data = Wallet.wallets_data(@wallets.map{|w| w.address}, params["currency"])
  end

  def show
    @wallet = Wallet.find params["id"]
    @wallet_data = @wallet.wallet_data(params["currency"])
    @balance = (Wallet.wallets_data([@wallet.address], params["currency"]).first["balance"].to_f)/10**18
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

  private
    def wallet_params
      params.require(:wallet).permit(:address)
    end

    def correct_user
      @wallet = current_user.wallets.find_by(id: params[:id])
      redirect_to wallets_path, notice: "You are not allowed to show/delete this wallet" if @wallet.nil?
    end
end