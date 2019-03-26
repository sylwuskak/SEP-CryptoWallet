class Transaction include ActiveModel::Model
    attr_accessor :from, :to, :value, :gas, :timeStamp
end

