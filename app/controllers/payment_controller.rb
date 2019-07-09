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
    
    request.name = 'Sandra Escobar S'
    request.email = 's.escobar@gmail.com'
    request.type = 'individual'

    result = customers_controller.create_customer(request)
    raise
  end

  def create_all_plans
    # Configuration parameters and credentials
    basic_auth_user_name = ENV['Mundi_API'] # The username to use with basic authentication
    basic_auth_password = ('') # The password to use with basic authentication


    client = MundiApi::MundiApiClient.new(
      basic_auth_user_name: basic_auth_user_name,
      basic_auth_password: basic_auth_password
    )

    plans_controller = client.plans

    request = MundiApi::CreatePlanRequest.new
    
    request.name = 'Plana'
    request.description = 'Assinatura Mensal'
    request.statement_descriptor = 'teste'
    request.items = [{
      "name": "Bodybuilding",
      "quantity": 1,
      "pricing_scheme": {
        "price": 18990,
        "scheme_type": "unit"
      }
    }]
    request.shippable = false
    request.payment_methods = ['credit_card']
    request.installments = [1]
    request.currency = 'BRL'
    request.interval = 'month'
    request.interval_count = 1
    request.billing_days = [1, 20]
    request.billing_type = 'exact_day'
    request.pricing_scheme = { "price": 18990 }
    request.metadata = {
      "id": "my_plan_id"
    }
    request.minimum_price = 10000
    request.cycles = 1
    request.quantity = 1
    request.trial_period_days = 7

    raise
    result = plans_controller.create_plan(request)
    raise
  end

  def get_plans
    # Configuration parameters and credentials
    basic_auth_user_name = ENV['Mundi_API'] # The username to use with basic authentication
    basic_auth_password = ('') # The password to use with basic authentication

    client = MundiApi::MundiApiClient.new(
      basic_auth_user_name: basic_auth_user_name,
      basic_auth_password: basic_auth_password
    )

    plans_controller = client.plans

    request = MundiApi::GetPlanResponse.new

    page = 134
    size = 134


    result = plans_controller.get_plans(page, size)
raise
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

    result = customers_controller.create_address(customer_id, request)
  raise
  end
end
