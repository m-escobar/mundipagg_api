class PaymentController < ApplicationController
    def index
        # Configuration parameters and credentials
        basic_auth_user_name = ('pk_test_zD9Jq9IoaSx1JVOk') # The username to use with basic authentication
        basic_auth_password = ('sk_test_RYwm6wBcMjt387nb') # The password to use with basic authentication


        client = MundiApi::MundiApiClient.new(
          basic_auth_user_name: basic_auth_user_name,
          basic_auth_password: basic_auth_password
        )

        
        customers_controller = client.customers
        
        
        request = MundiApi::CreateCustomerRequest.new
        
        request.name = 'Marcelo Escobar'
        request.email = 'marceloescobar.s@gmail.com'
        request.type = 'indivudual'

        result = customers_controller.create_customer(request)
        


raise
      end

end
