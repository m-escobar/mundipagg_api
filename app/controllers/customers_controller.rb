class CustomersController < ApplicationController
  before_action :login, only: [:main]


  def initialize #list 
    @json =  { "operacao": {
                  "tipo": "list",
                  "objeto": "card"
                },
               "assinatura": {
                  "assinatura_id": "sub_VdWEX2OCpfAGN32k",
                },
               "cliente": {
                  "cliente_id": "cus_wpjEBoBfGktyp3qB"
                }
             }
  end

  # def initialize #destroy subscription
  #   @json =  { "operacao": {
  #                 "tipo": "destroy",
  #                 "objeto": "subscription"
  #               },
  #               "assinatura": {
  #                 "assinatura_id": "sub_VdWEX2OCpfAGN32k",
  #               }
  #            }
  # end

  # def initialize #destroy card
  #   @json =  { "operacao": {
  #                 "tipo": "destroy",
  #                 "objeto": "card"
  #               },
  #               "cliente": {
  #                 "cliente_id": "cus_wpjEBoBfGktyp3qB"
  #               },
  #               "cartao": {
  #                 "cartao_id": "card_7yJjqggtZT3aw9gl",
  #               }
  #            }
  # end

  # def initialize #card update
  #   @json =  { "operacao": {
  #                 "tipo": "update"
  #               },
  #               "cliente": {
  #                 "cliente_id": "cus_wpjEBoBfGktyp3qB"
  #               },
  #               "cartao": {
  #                 "numero": "4000000000000010",
  #                 "expiracao_mes": 1,
  #                 "expiracao_ano": 2020,
  #                 "cvv": "351",
  #                 "cartao_id": "card_7yJjqggtZT3aw9gl",
  #                 # "endereco_id": "addr_RjnL4ERtjsaBZzoW"
  #               },
  #               "endereco": {
  #                 "rua": "Rua Victor",
  #                 "numero": "479",
  #                 "bairro": "Jardim Maralina",
  #                 "cep": "06704-505",
  #                 "cidade": "Cotia",
  #                 "estado": "SP",
  #                 "pais": "BR"
  #                   }
  #             }
  # end

  # def initialize #create
  #   @json =  { "operacao": {
  #               "tipo": "create"
  #               }, 
  
  #             "cliente": {
  #               # "cliente_id": "cus_YOUR_CUSTOMER_ID",
  #               "nome": "Mariana Santos",
  #               "email": "marionasantos@gmail.com"
  #             },
  #             "cartao": {
  #                 "numero": "4584441896453869",
  #                 "expiracao_mes": 12,
  #                 "expiracao_ano": 2019,
  #                 "cvv": "591"
  #             },
  #             "produtos": [
  #                 {
  #                     "tipo": "plano Teste 123",
  #                     "plano_id": "plan_w92xZgaSRPiAWE8N",
  #                     "nome": "plano Teste 123",
  #                     "descricao": "Assinatura Mensal",
  #                     "info_extrato": "Cobranca Mensal",
  #                     "metodo_pagamento": "credit_card",
  #                     "parcelas": 1,
  #                     "moeda": "BRL",
  #                     "tipo_intervalo": "month",
  #                     "intervalo": 1,
  #                     "tipo_cobranca": "prepaid",
  #                     "valor": 2540,
  #                     "periodo_teste": 7,
  #                     "quantidade": 1
  #                   }
  #               ],
  #             "endereco": {
  #                   "rua": "Rua Victor",
  #                   "numero": "479",
  #                   "bairro": "Jardim Maralina",
  #                   "cep": "06704-505",
  #                   "cidade": "Cotia",
  #                   "estado": "SP",
  #                   "pais": "BR"
  #                 }
  #         }
  # end

  def main
    temp = @json.to_json
    @hash = JSON.parse(temp, {:symbolize_names => true})
    unless @hash[:operacao][:tipo].nil? then
      @to_return = {}
      case @hash[:operacao][:tipo]
        when "list"
          op_list
        when "create"
          op_create
        when  "update"
          op_update
        when "destroy"
          op_destroy
        else to_return = {"error": "Invalid Operation"}
      end
    else 
      to_return = {"error": "Undefined Operation"}
    end

    if to_return.nil? 
      to_return = { "requested operation": @hash[:operacao][:tipo] }
      to_return.merge!(@error) unless @error.nil?
      to_return.merge!(@list) unless @list.nil?
      to_return.merge!(@destroy) unless @destroy.nil?
      to_return.merge!(@user) unless @user.nil?
      to_return.merge!(@card) unless @card.nil?
      to_return.merge!(@address) unless @address.nil?
      to_return.merge!(Hash[*@products]) unless @products.nil?
      to_return.merge!(@subscription) unless @subscriptions.nil?
    end

    @json_to_return = JSON.parse(to_return.to_json)
    render :json => @json_to_return
  end

  def op_list
    #list customer
    if @hash[:operacao][:objeto] == "customer" then
      list = MundiApi::ListCustomersResponse.new
      list = @customers_controller.get_customers

      if list.nil? then
        {"error": "No customers listed"}
      else
        list_hash = {"customers": "list"}
        list.data.each do |u|
          hash = { u.name => u.id }
          list_hash.merge!(hash)
        end
      end
      #list cards
    elsif @hash[:operacao][:objeto] == "card" then
      find_user
      return unless @error.nil?

      list = MundiApi::ListCardsResponse.new
      list = @customers_controller.get_cards(@user.id)

      if list.nil? then
        {"error": "No cards for this customer"}
      else
        list_hash = {"customers": "cards"}
        list.data.each do |u|
          hash = { u.name => u.id }
          list_hash.merge!(hash)
        end
      end
      #list subscriptions
    elsif @hash[:operacao][:objeto] == "subscription" then
      list = MundiApi::ListSubscriptionsResponse.new
      list = @subscriptions_controller.get_subscriptions

      if list.nil? then
        {"error": "No subscriptions for this customer"}
      else
        list_hash = {"subscription": "list"}
        x = 0
        list.data.each do |l|
          hash = { l.id => l.code, "customer_id_#{x}": l.customer.id }
          list_hash.merge!(hash)
          x += 1
        end
      end
    end
    @list = list_hash
  end
  
  def op_destroy
    if @hash[:operacao][:objeto] == "cartao" then
      #find user
      find_user
      return unless @error.nil?

      if @hash[:cartao][:cartao_id].nil? then
        @error = {"error": "Card ID to update not informed"}
        return
      end  
      destroy = destroy_card(@user.id, @hash[:cartao][:cartao_id])

    elsif @hash[:operacao][:objeto] == "subscription"
      destroy = destroy_subscription(@hash[:assinatura][:assinatura_id])
    end
    
    @destroy = destroy.nil? ? {"error": "Operatition error"} : destroy
  end


  def op_update
    #find user
    find_user
    return unless @error.nil? 

    #find address
    if @hash[:cartao][:endereco_id].nil? && @hash[:endereco].nil? then
      @error = {"error": "Card Address not informed"}
      return
    elsif !@hash[:cartao][:endereco_id].nil?
      address = @customers_controller.get_addresses(user.id, 1, 1)
    elsif !@hash[:endereco].nil?
      address = create_address(user.id, @hash[:endereco])
    else
        @error = {"error": "Card Address ID not informed"}
        return
    end

    #card update
    if @hash[:cartao].nil? then
      @error = {"error": "Card info not provided"}
      return
    end
    if @hash[:cartao][:numero].nil? then
      @error = {"error": "Card number not informed"}
      return
    end
    if @hash[:cartao][:expiracao_mes].nil? then
      @error = {"error": "Card month exp not informed"}
      return
    end
    if @hash[:cartao][:expiracao_ano].nil? then
      @error = {"error": "Card year exp not informed"}
      return
    end
    if @hash[:cartao][:cartao_id].nil? then
      @error = {"error": "Card ID to update not informed"}
      return
    end

    card =  MundiApi::UpdateCardRequest.new
    card = update_card(@user, @hash[:cartao], address.id)

    @card = card.nil? ? {"error": "Card updating error"} : card
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

  def find_user
    #find user
    if @hash[:cliente].nil? then
      @error = {"error": "Customer ID not informed"}
      return
    elsif @hash[:cliente][:cliente_id].nil? then
      @error = {"error": "Customer ID not informed"}
      return
    else
      @user = @customers_controller.get_customer(@hash[:cliente][:cliente_id])
    end
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

  def update_card(customer, card, address_id)
    request =  MundiApi::UpdateCardRequest.new
    request.holder_name = !card[:nome].nil? ? card[:nome] : customer.name
    request.exp_month = card[:expiracao_mes]
    request.exp_year = card[:expiracao_ano]
    request.billing_address_id = address_id
    card_id = card[:cartao_id]
    
    begin
      result = @customers_controller.update_card(customer.id, card_id, request)
    rescue => e
      result = nil
    end
    return result
  end

  def destroy_card(customer_id, card_id)
    begin
      result = @customers_controller.delete_card(customer_id, card_id)
    rescue => e
      result = nil
    end
    return result
  end
  
  def destroy_subscription(subscription_id)
    begin
      result = @subscriptions_controller.cancel_subscription(subscription_id)
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
