class PaymentController < ApplicationController
    def index
        # Configuration parameters and credentials
        basic_auth_user_name = 'pk_test_dpqm6W4Fo3uDe95n' # The username to use with basic authentication
        basic_auth_password = 'sk_test_ldXjepulPivN39QD' # The password to use with basic authentication
        

        client = MundiApi::MundiApiClient.new(
          basic_auth_user_name: basic_auth_user_name,
          basic_auth_password: basic_auth_password
        )
        raise
    end
end
