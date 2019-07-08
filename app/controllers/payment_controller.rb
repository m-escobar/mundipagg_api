class PaymentController < ApplicationController
    def index
        # Configuration parameters and credentials
        basic_auth_user_name = ENV['Mundi_API'] # The username to use with basic authentication
        basic_auth_password = ('') # The password to use with basic authentication


        client = MundiApi::MundiApiClient.new(
          basic_auth_user_name: basic_auth_user_name,
          basic_auth_password: basic_auth_password
        )

        
        customers_controller = client.customers
        
        
        request = MundiApi::CreateCustomerRequest.new
        
        request.name = 'Marcelo Escobar S'
        request.email = 'marceloescobar@gmail.com'
        request.type = 'individual'

        result = customers_controller.create_customer(request)
        
raise
      end

end
