class HomeController < ApplicationController
  def index
    @wallet_number = Wallet.all.select{|w| w.wallet_data(nil).length > 0 }.length
  end

end
