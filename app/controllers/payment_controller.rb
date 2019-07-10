class PaymentController < ApplicationController
  before_action :login, only: [:index, :create_user]

  def main
  end

  private
  def login
    # Configuration parameters and credentials
    basic_auth_user_name = ENV['Mundi_API'] # The username to use with basic authentication
    basic_auth_password = ('') # The password to use with basic authentication

    client = MundiApi::MundiApiClient.new(
      basic_auth_user_name: basic_auth_user_name,
      basic_auth_password: basic_auth_password
    )
    @customers_controller = client.customers
  end
end
