class ApplicationController < ActionController::Base

#   protect_from_forgery
#   before_action :cors_preflight_check #:current_user, 
#   after_action :cors_set_access_control_headers

# # For all responses in this controller, return the CORS access control headers.
# def cors_set_access_control_headers
#     headers['Access-Control-Allow-Origin'] = 'text/plain*'
#     headers['Access-Control-Allow-Origin'] = 'application/json'
#     headers['Access-Control-Allow-Origin'] = '*'
#     headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
#     headers['Access-Control-Allow-Headers'] = '*'
#     headers['Access-Control-Max-Age'] = "1728000"
# end

# def cors_preflight_check
#     if request.method == :options
#         headers['Access-Control-Allow-Origin'] = '*'
#         headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
#         headers['Access-Control-Request-Method'] = '*'
#         headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
#         headers['Access-Control-Max-Age'] = '1728000'
#         # render :json => '', :content_type => 'application/json'
#         # render :text => '', :content_type => 'text/plain'
# #     end
# end

# private
#   # get the user currently logged in
#   def current_user
#     @current_user ||= User.find(session[:user_id]) if session[:user_id]
#   end
#   helper_method :current_user
end
