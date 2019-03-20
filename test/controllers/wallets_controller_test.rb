require 'test_helper'

class WalletsControllerTest < ActionDispatch::IntegrationTest
    test "can not reach new page without sign in" do
        get "/wallets/new"
        assert_response :redirect
    end

    test "can reach new page after sign in" do 
        post "/users", params: {user: {email: "example@example.com", password: "password", password_confirmation: "password"}}

        assert_response :redirect
        follow_redirect!

        get "/wallets/new"
        assert_response :success
    end


end