class CustomerController < ApplicationController
    before_action :login, only: [:main, :create_user]

    def initialize
        @hash =  { "cliente": {
                    "nome": "Mario Santos",
                    "email": "mariosantos@gmail.com"
                },
                "cartao": {
                    "numero": "4584441896453869",
                    "expiracao_mes": 12,
                    "expiracao_ano": 2019,
                    "cvv": "591"
                },
                "produtos": [
                    {
                        "tipo:" "plano mensal",
                        "plano_id": "plan_JNYkzeDU56tKRdLM"
                    }
                ]
            }
    end

    def main    
        @result = @customers_controller.get_customers
    end
  
    def create_user
      request.name = 'Sandra Escobar S'
      request.email = 's.escobar@gmail.com'
      request.type = 'individual'
  
      raise
      @result = @customers_controller.create_customer(request)
    end
  
    def create_address
      # Configuration parameters and credentials
      basic_auth_user_name = ENV['Mundi_API'] # The username to use with basic authentication
      basic_auth_password = ('') # The password to use with basic authentication
  
      client = MundiApi::MundiApiClient.new(
        basic_auth_user_name: basic_auth_user_name,
        basic_auth_password: basic_auth_password
      )
  
      customers_controller = client.customers
      
      customer_id = 'cus_5MlXRjBFL4heWXxE'
      request =  MundiApi::CreateAddressRequest.new
      request.street = 'Rua Victor'
      request.number = '479'
      request.neighborhood  = 'vila dalva'
      request.zip_code = '06704-505'
      request.city = 'Cotia'
      request.state = 'SP'
      request.country = 'BR'
  
      $result = customers_controller.create_address(customer_id, request)
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
