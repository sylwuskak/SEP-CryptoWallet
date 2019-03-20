require 'test_helper'

class WalletTest < ActiveSupport::TestCase
  test "creation failure without user" do
    w = Wallet.new
    w.address = '0xEc690940081E780ae3310C88eb3f4C75622988eC'
    assert_not w.save
  end
  
  test "create wallet" do
    u = User.create!(
      email: "test@exaple.com",
      password: "password"
    )
    
    w = Wallet.new
    w.address = '0xEc690940081E780ae3310C88eb3f4C75622988eC'
    w.user = u
    assert w.save
  end

  test "creation failure without address" do 
    u = User.create!(
      email: "test@exaple.com",
      password: "password"
    )

    w = Wallet.new
    w.user = u
    assert_not w.save
  end
end