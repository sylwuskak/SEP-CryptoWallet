class Wallet < ApplicationRecord
    belongs_to :user
    validates :address, presence: true

    def wallet_data(currency) 
        url = "http://api.etherscan.io/api?module=account&action=txlist&address=" + self.address + "&startblock=0&endblock=99999999&sort=asc"
        uri = URI(url)
        response = Net::HTTP.get(uri)

        result = JSON.parse(response).try(:[], "result")

        if currency == "PLN"
            result.each do |transaction|
                transaction["value"] = transaction["value"].to_f * 516.87
                transaction["gas"] = transaction["gas"].to_f * 516.87
            end
        end
        
        result
    end

    def self.wallets_data(wallets_addresses, currency)
        url = "https://api.etherscan.io/api?module=account&action=balancemulti&address=" + wallets_addresses.join(',') + "&tag=latest"
        uri = URI(url)
        response = Net::HTTP.get(uri)
    
        result = JSON.parse(response).try(:[], "result")
        if currency == "PLN"
            result.each do |transaction|
                transaction["balance"] = transaction["balance"].to_f * 516.87
            end
        end
        result
      end
end
