class DemosController < ApplicationController

def create_plans
    # Configuration parameters and credentials
    basic_auth_user_name = ENV['Mundi_API'] # The username to use with basic authentication
    basic_auth_password = ('') # The password to use with basic authentication
    
    client = MundiApi::MundiApiClient.new(
        basic_auth_user_name: basic_auth_user_name,
        basic_auth_password: basic_auth_password
        )
        
    
    plans_controller = client.plans
    
    
    #Not in use but sintax is correct
    #-------------
    #Use to include an item
    # request.items = [{
    #   "name": "Mensal",  
    #   "quantity": 1,
    #   "pricing_scheme": {
    #     "price": 2540,  
    #     "scheme_type": "unit"
    #   }
    # }]
    #
    #-------------
    #To include billing_days
    # request.billing_days = [1, 20]  #dont set when using prepaid
    #-------------
    #To include Metadata
    # request.metadata = {
    #   "id": "my_plan_id"  
    # }
    #-------------
    #To include others
    # request.cycles = 1
    # request.minimum_price = 10000
    # request.shippable = false
    
    #Creating Montly Plan
    request = MundiApi::CreatePlanRequest.new
    request.name = 'Plano Mensal'
    request.description = 'Assinatura Mensal'
    request.statement_descriptor = 'Cobranca Mensal'
    request.payment_methods = ['credit_card']
    request.installments = [1]
    request.currency = 'BRL'
    request.interval = 'month'
    request.interval_count = 1
    request.billing_type = 'prepaid'
    request.pricing_scheme = { "price": 2540 }
    request.quantity = 1
    request.trial_period_days = 7
    @plan1 = plans_controller.create_plan(request)

    #Creating Semiannual Plan
    request = MundiApi::CreatePlanRequest.new
    request.name = 'Plano Semestral'
    request.description = 'Assinatura Semestral'
    request.statement_descriptor = 'Cobranca Semestral'
    request.payment_methods = ['credit_card']
    request.installments = [1]
    request.currency = 'BRL'
    request.interval = 'month'
    request.interval_count = 6
    request.billing_type = 'prepaid'
    request.pricing_scheme = { "price": 6990 }
    request.quantity = 1
    request.trial_period_days = 7
    @plan2 = plans_controller.create_plan(request)

    #Creating Annual Plan
    request = MundiApi::CreatePlanRequest.new
    request.name = 'Plano Anual'
    request.description = 'Assinatura Anual'
    request.statement_descriptor = 'Cobranca Anual'
    request.payment_methods = ['credit_card']
    request.installments = [1]
    request.currency = 'BRL'
    request.interval = 'year'
    request.interval_count = 1
    request.billing_type = 'prepaid'
    request.pricing_scheme = { "price": 23400 }
    request.quantity = 1
    request.trial_period_days = 7
    @plan3 = plans_controller.create_plan(request)
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

    page = 1
    size = 134

    @result = plans_controller.get_plans(page, size)
end
end
