class CustomersController < ApplicationController
    before_action :login, only: [:main]
    
    def initialize
        @hash =  { "cliente": {
                    "nome": "Maria Santos",
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
                        "tipo": "plano mensal",
                        "plano_id": "plan_JNYkzeDU56tKRdLM"
                    }
                ]
            }
    end

    def main
      #customer
      unless @hash[:cliente].nil? 
        user =  MundiApi::CreateCustomerRequest.new
        user = create_user(@hash[:cliente])
        if user.nil?
          return {"error": "User creation error"}
        else 
          @user = user
        end
      end
      
      #cartao
      unless @hash[:cartao].nil? 
        card =  MundiApi::CreateCardRequest.new
        card = create_card(user.id, @hash[:cartao])
        if card.nil?
          return {"error": "Card creation error"}
        else 
          @card = card
        end
      end

      unless @hash[:produto].nil? 
        subscription = MundiApi::CreateSubscriptionRequest.new
        subscription = create_subscription(user.id, @hash)
        if subscription.nil?
          return {"error": "Subscription creation error"}
        else 
          @subscription = subscription
        end
      end
    end
  
    def create_user(client)
      request =  MundiApi::CreateCustomerRequest.new
      request.name = client[:nome]
      request.email = client[:email]
      request.type = 'individual'

      begin
        result = @customers_controller.create_customer(request)
      rescue => e
        # This is the same as rescuing StandardError
        result = nil
      end
      
      return result
    end
  
    def create_card(customer_id, card)
      request =  MundiApi::CreateCardRequest.new
      request.holder_name = !card[:nome].nil? ? card[:nome] : @hash[:cliente][:nome]
      request.number = card[:numero]
      request.exp_month = card[:expiracao_mes]
      request.exp_year = card[:expiracao_ano]
      request.cvv = card[:cvv]
      
      begin
        result = @customers_controller.create_card(customer_id, request)
      rescue => e
        # This is the same as rescuing StandardError
        result = nil
      end
      return result
    end
 
    def create_subscription(client)
      request =  MundiApi::CreateSubscriptionRequest.new
      request.name = client[:nome]
      request.email = client[:email]
      request.type = 'individual'

      begin
        result = subscriptions_controller.create_subscription(request)
      rescue => e
        # This is the same as rescuing StandardError
        result = nil
      end
      
      return result
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
