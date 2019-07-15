class CustomersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def main
    hash = params

    unless hash[:operacao].nil?
      unless hash[:operacao][:tipo].nil? then
        @api_key = hash[:operacao][:api_key]
        login
          case hash[:operacao][:tipo]
            when "list"
              op_list(hash)
            when "create"
              op_create(hash)
            when  "update"
              op_update(hash)
            when "destroy"
              op_destroy(hash)
            else to_return = { "message": "Invalid Operation" }
          end
      else 
        to_return = { "message": "Undefined Operation" }
      end
    else
      to_return = { "message": "Parameters not informed" }
    end
    
    if to_return.nil?
      to_return = {"message": "resp", "requested operation": hash[:operacao][:tipo]}
      to_return.merge!(@error) unless @error.nil?
      to_return.merge!(@list) unless @list.nil?
      to_return.merge!(@destroy) unless @destroy.nil?
      to_return.merge!(@user) unless @user.nil?
      to_return.merge!(@card) unless @card.nil?
      to_return.merge!(@address) unless @address.nil?
      to_return.merge!(Hash[*@products]) unless @products.nil?
      to_return.merge!(@subscription) unless @subscriptions.nil?
    end

    json_to_return = JSON.parse(to_return.to_json)
    render :json => json_to_return
  end

private
  def op_list(op)
    #list customer
    if op[:operacao][:objeto] == "customer" then
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
    elsif op[:operacao][:objeto] == "card" then
      find_user(op[:cliente])
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
    elsif op[:operacao][:objeto] == "subscription" then
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
  
  def op_create(op)
    #customer
    user =  MundiApi::CreateCustomerRequest.new
    unless op[:cliente].nil?
      unless op[:cliente][:cliente_id].nil?
        user = @customers_controller.get_customer(op[:cliente][:cliente_id])
      else
        user = create_user(op[:cliente])
      end
      
      @user = user.nil? ? {"error": "User creation error"} : user
    end #end customer

    #cartao
    unless op[:cartao].nil?
      if @user.nil?
        find_user(op[:cliente])
        return unless @error.nil? 
      end
      if op[:cartao][:endereco_id].nil?
        unless op[:endereco].nil?
          address = create_address(@user.id, op[:endereco])
          return unless @error.nil?
          address_id = address.id
        end
      else
        address_id = op[:cartao][:endereco_id]
      end

      card = MundiApi::CreateCardRequest.new
      card = create_card(@user, op[:cartao], address_id)
      if card.nil? then
        @error =  {"error": "Card creation error"}
      else
          @card = card
          token = { "n": op[:cartao][:numero], "c": op[:cartao][:cvv] }
      end
    end #end cartao

    #address
    address =  MundiApi::CreateCustomerRequest.new
    unless op[:endereco].nil?
      unless @user.nil?
        address = create_address(@user.id, op[:endereco])
      else
        @error = {"error": "Undefined Customer"}
        return
      end
      @address = address.nil? ? {"error": "Address creation error"} : address
    end #end address

    #product
    unless op[:produtos].nil? 
      @products = []
      op[:produtos].each do |produto|
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
    unless op[:cliente].nil? || op[:cartao].nil? || op[:produtos].nil? 
      unless @user.nil? || @products.nil? || @card.nil?
        subscription = MundiApi::CreateSubscriptionRequest.new
        subscription = create_subscription(@user, @products, @card, token)
        if subscription.nil? then
          @error = { "error": "Subscription creation error" }
        else 
          @subscription = subscription
        end
      end
    end #end subscription
  end #end op_create

  def op_update(op)
    find_user(op[:cliente])
    return unless @error.nil? 

    #find address
    if op[:cartao].nil? then
      @error = {"error": "Card not informed"}
      return
    elsif op[:cartao][:endereco_id].nil? && op[:endereco].nil? then
      @error = {"error": "Card Address not informed"}
      return
    elsif !op[:cartao][:endereco_id].nil?
      address = @customers_controller.get_addresses(@user.id)
    elsif !op[:endereco].nil?
      address = create_address(@user.id, op[:endereco])
      if address.nil? then
        @error = { "error": "Address parameters missing"  }
        return if address.nil?
      end
    else
        @error = {"error": "Card Address ID not informed"}
        return
    end

    #card update
    if op[:cartao].nil? then
      @error = {"error": "Card info not provided"}
      return
    end
    if op[:cartao][:expiracao_mes].nil? then
      @error = {"error": "Card month exp date not informed"}
      return
    end
    if op[:cartao][:expiracao_ano].nil? then
      @error = {"error": "Card year exp date not informed"}
      return
    end
    if op[:cartao][:cartao_id].nil? then
      @error = {"error": "Card ID to update not informed"}
      return
    end

    card =  MundiApi::UpdateCardRequest.new
    card = update_card(@user, op[:cartao], address.id)

    @card = card.nil? ? {"error": "Card updating error"} : card
  end #end op_update

  def op_destroy(op)
    if op[:operacao][:objeto] == "card" then
      find_user(op[:cliente])
      return unless @error.nil?
      
      if op[:cartao].nil? then
        @error = {"error": "Card to destroy not informed"}
        return
      elsif op[:cartao][:cartao_id].nil? then
        @error = {"error": "Card ID to destroy not informed"}
        return
      end
      destroy = destroy_card(@user.id, op[:cartao][:cartao_id])

    elsif op[:operacao][:objeto] == "subscription"
      destroy = destroy_subscription(op[:assinatura][:assinatura_id])
    end
    
    @destroy = destroy.nil? ? {"error": "Destroy operation error"} : destroy
  end #end op_destroy

  def login
    # Configuration parameters and credentials
    if @api_key.nil?
      #To be used locally with .env file or at Heroku (or other) with 
      #secret_key configured at Settings#Config_Vars
      basic_auth_user_name = ENV['Mundi_API'] # The username to use with basic authentication
    else
      #To be used online getting Secret_key from Json
      basic_auth_user_name = (@api_key)
    end
    basic_auth_password = '' # The password to use with basic authentication

    client = MundiApi::MundiApiClient.new(
      basic_auth_user_name: basic_auth_user_name,
      basic_auth_password: basic_auth_password
    )
    
    @customers_controller = client.customers
    @subscriptions_controller = client.subscriptions
    @plans_controller = client.plans
  end

  def find_user(customer)
    #find user
    if customer.nil? then
      @error = {"error": "Customer not informed"}
      return
    elsif customer[:cliente_id].nil? then
      @error = {"error": "Customer ID not informed"}
      return
    else
      @user = @customers_controller.get_customer(customer[:cliente_id])
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
  
  def create_card(user, card, address_id)
    request =  MundiApi::CreateCardRequest.new
    request.holder_name = !card[:nome].nil? ? card[:nome] : user.name
    request.number = card[:numero]
    request.exp_month = card[:expiracao_mes]
    request.exp_year = card[:expiracao_ano]
    request.cvv = card[:cvv]
    request.billing_address_id = address_id
    
    begin
      result = @customers_controller.create_card(user.id, request)
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

  def create_subscription(customer, plan, card, token)
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
        "number": token[:n], #"4532464862385322",
        "exp_month": card.exp_month,
        "exp_year": card.exp_year,
        "cvv": token[:c]
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

  def destroy_subscription(subscription_id)
    begin
      result = @subscriptions_controller.cancel_subscription(subscription_id)
    rescue => e
      result = nil
    end
    return result
  end #end destroy subscription
end #end class
