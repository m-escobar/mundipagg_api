class CustomersController < ApplicationController
  before_action :login, only: [:main]
    
  def initialize
    @hash =  { "operacao": {
                "tipo": "create"
                }, 
  
              "cliente": {
                # "cliente_id": "cus_5MlXRjBFL4heWXxE",
                "nome": "Mariana Santos",
                "email": "marionasantos@gmail.com"
              },
              "cartao": {
                  "numero": "4584441896453869",
                  "expiracao_mes": 12,
                  "expiracao_ano": 2019,
                  "cvv": "591"
              },
              "produtos": [
                  {
                      "tipo": "plano Teste 123",
                      "plano_id": "plan_w92xZgaSRPiAWE8N",
                      "nome": "plano Teste 123",
                      "descricao": "Assinatura Mensal",
                      "info_extrato": "Cobranca Mensal",
                      "metodo_pagamento": "credit_card",
                      "parcelas": 1,
                      "moeda": "BRL",
                      "tipo_intervalo": "month",
                      "intervalo": 1,
                      "tipo_cobranca": "prepaid",
                      "valor": 2540,
                      "periodo_teste": 7,
                      "quantidade": 1
                    }
                ],
              "endereco": {
                    "rua": "Rua Victor",
                    "numero": "479",
                    "bairro": "Jardim Maralina",
                    "cep": "06704-505",
                    "cidade": "Cotia",
                    "estado": "SP",
                    "pais": "BR"
                  }
          }
  end

  def main
    unless @hash[:operacao][:tipo].nil? then
      @to_return = ""
      case @hash[:operacao][:tipo]
        when "list"
          op_list
        when "create"
          op_create
        when  "update"
          op_update
        when "destroy"
          op_destroy
        else @to_return = {"error": "Invalid Operation"}
      end
    else 
      @to_return = {"error": "Undefined Operation"}
    end

      raise
    return @to_return
  end

  def op_list
  end
  
  def op_create
    #customer
    user =  MundiApi::CreateCustomerRequest.new
    unless @hash[:cliente].nil?
      unless @hash[:cliente][:cliente_id].nil?
        user = @customers_controller.get_customer(@hash[:cliente][:cliente_id])
      else
        user = create_user(@hash[:cliente])
      end
      
      @user = user.nil? ? {"error": "User creation error"} : user
    end #end customer

    #cartao
    unless @hash[:cartao].nil? 
      card =  MundiApi::CreateCardRequest.new
      card = create_card(@user.id, @hash[:cartao])
      @card = card.nil? ? {"error": "Card creation error"} : card
    end #end cartao

    #address
    address =  MundiApi::CreateCustomerRequest.new
      unless @hash[:endereco].nil?
        unless @user.nil?
          address = create_address(@user.id, @hash[:endereco])
        else
            return {"error": "Undefined Customer"}
        end
      @address = address.nil? ? {"error": "Address creation error"} : address
    end #end address

    #product
    unless @hash[:produtos].nil? 
      @products = []
      @hash[:produtos].each do |produto|
        product = MundiApi::CreatePlanRequest.new
        product = create_plan(produto)
        if product.nil? 
          @products << {"error": "Plan creation error"}
        else
          @products << product
        end
      end
    end #end product

    #subscription
    unless @hash[:cliente].nil? && @hash[:cartao].nil? && @hash[:produtos].nil? 
      subscription = MundiApi::CreateSubscriptionRequest.new
      subscription = create_subscription(@user, @products, @card)
      @subscription = subscription.nil? ? {"error": "Subscription creation error"} : subscription
    end #end subscription
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
    @plans_controller = client.plans
  end

  def create_user(customer)
    request =  MundiApi::CreateCustomerRequest.new
    request.name = customer[:nome]
    request.email = customer[:email]
    request.type = 'individual'
    
    begin
      result = @customers_controller.create_customer(request)
    rescue => e
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
      result = nil
    end
    return result
  end

  def create_address(customer_id, address)
    request =  MundiApi::CreateAddressRequest.new
    request.line_1 = "#{address[:numero]}, #{address[:rua]}, #{address[:bairro]}"
    request.zip_code = "#{address[:cep]}"
    request.city = address[:cidade]
    request.state = address[:estado]
    request.country = address[:pais]

    begin
      result = @customers_controller.create_address(customer_id, request)
    rescue => e
      result = nil
    end
    return result
  end #end create_address

  def create_plan(produto)
    request = MundiApi::CreatePlanRequest.new
    request.name = produto[:nome]
    request.description = produto[:descricao]
    request.statement_descriptor = produto[:info_extrato]
    request.payment_methods = [produto[:metodo_pagamento]]
    request.installments = [produto[:parcelas]]
    request.currency = produto[:moeda]
    request.interval = produto[:tipo_intervalo]
    request.interval_count = produto[:intervalo]
    request.billing_type = produto[:tipo_cobranca]
    request.pricing_scheme = { "price": produto[:valor] }
    request.quantity = produto[:quantidade]
    request.trial_period_days = produto[:periodo_teste]

    begin
      result = @plans_controller.create_plan(request)
    rescue => e
      result = nil
    end
    return result
  end #end create_plan

  def create_subscription(customer, plan, card)
    request =  MundiApi::CreateSubscriptionRequest.new
    # request.plan_id = info[:produtos][0][:plano_id]
    # request.statement_descriptor = 'Cobranca Mensal'
    # request.description = 'Assinatura Mensal'
    # request.pricing_scheme = { "price": 2540 }
    # request.name = 'Plano Mensal'
    # request.quantity = 1
    # request.trial_period_days = 7
    # request.boleto_due_days=5
    # request.minimum_price = 10000

    request.payment_method = plan.first.payment_methods.first #"credit_card"
    request.currency = plan.first.currency #"BRL"
    request.interval = plan.first.interval #"month"
    request.interval_count = plan.first.interval_count #3
    request.billing_type = plan.first.billing_type # "prepaid"
    request.installments = plan.first.installments.first #3
    request.customer= {
        "name":  customer.name,
        "email": customer.email
    }
    request.card= {
        "holder_name": card.holder_name,
        "number": "4532464862385322",
        "exp_month": card.exp_month,
        "exp_year": card.exp_year,
        "cvv": "591"
    }
    request.items= [
        {
          "description": plan.first.items.first.name,
          "quantity": plan.first.items.first.quantity,
          "pricing_scheme": {
            "price": plan.first.items.first.pricing_scheme.price
          }
        }
    ]

    begin
      result = @subscriptions_controller.create_subscription(request)
    rescue => e
      result = nil
    end
    return result
  end #end create_subscription
end #end class
