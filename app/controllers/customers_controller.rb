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
                        "plano_id": "plan_w92xZgaSRPiAWE8N"
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

      #cria endereço
      create_address

      #produto
      unless @hash[:produtos].nil? 
        subscription = MundiApi::CreateSubscriptionRequest.new
        subscription = create_subscription(user.id, @hash)
        if subscription.nil?
          return {"error": "Subscription creation error"}
        else 
          @subscription = subscription
        end
        raise
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
 
    def create_subscription(client, info)
      request =  MundiApi::CreateSubscriptionRequest.new
# raise
      # request.customer = @user
#      request.customer_id = @user.id
#       request.card = @card
#       request.plan_id = info[:produtos][0][:plano_id]
#       request.payment_method = 'credit_card'
#       request.billing_type = 'prepaid'
#       request.statement_descriptor = 'Cobranca Mensal'
#       request.description = 'Assinatura Mensal'
#       request.currency = 'BRL'
#       request.interval = 'month'
#       request.interval_count = 1
#       request.pricing_scheme = { "price": 2540 }
#       request.items = 
# request.name = 'Plano Mensal'
#     request.installments = [1]
#     request.quantity = 1
#     request.trial_period_days = 7

    request.payment_method = "credit_card"
    request.currency= "BRL"
    request.interval= "month"
    request.interval_count= 3
    request.billing_type= "prepaid"
    request.installments= 3
    request.gateway_affiliation_id= "C56A4180-65AA-42EC-A945-5FD21DEC0538"
    request.minimum_price= 10000
    request.boleto_due_days=5
    request.customer= {
        "name": "Tony Stark",
        "email": "tonystark@avengers.com"
    }
    request.card = @card.id
    # request.card= {
    #     "holder_name": "Tony Stark",
    #     "number": "4532464862385322",
    #     "exp_month": 1,
    #     "exp_year": 26,
    #     "cvv": "903",
    #     "billing_address": {
    #         "line_1": "375, Av. General Justo, Centro",
    #         "line_2": "8th floor",
    #         "zip_code": "20021130",
    #         "city": "Rio de Janeiro",
    #         "state": "RJ",
    #         "country": "BR"
    #     }
    #   }
    request.items= [
        {
            "description": "Bodybuilding",
            "quantity": 1,
            "pricing_scheme": {
                "price": 18990
            }
        },
        {
            "description": "Registration",
            "quantity": 1,
            "cycles": 1,
            "pricing_scheme": {
                "price": 5990
            }
        }
    ]
      

      raise
      begin
        result = @subscriptions_controller.create_subscription(request)
      rescue => e
        # This is the same as rescuing StandardError
        result = nil
      end
      return result
    end
 
    def create_address
      request =  MundiApi::CreateAddressRequest.new
      request.street = 'Rua Victor'
      request.number = '479'
      request.neighborhood  = 'vila dalva'
      request.zip_code = '06704-505'
      request.city = 'Cotia'
      request.state = 'SP'
      request.country = 'BR'
  
      @address = @customers_controller.create_address(@user.id, request)
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
      @subscriptions_controller = client.subscriptions
    end
end    
