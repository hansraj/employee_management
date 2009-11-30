# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  #include UserInfo
  layout "Home"
  before_filter :authorize, :except => :login
  filter_parameter_logging :password
  
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_timesheet_session_id'
 
  private

    # Set the notice if a parameter is given, then redirect back
    # to the current controller's +index+ action
    def redirect_to_index(msg = nil)         #:doc:
       if msg
         puts msg
        end
        redirect_to(:controller => 'time_sheets') 
    end

    # The #authorize method is used as a <tt>before_hook</tt> in
    # controllers that contain administration actions. If the
    # session does not contain a valid user, the method
    # redirects to the LoginController.login.
    def authorize                            #:doc:
      unless session[:user_id]
        flash[:notice] = "Please log in"
         redirect_to(:controller => "login", :action => "login")
      end
    end
    
  def encode(password)
        Digest::SHA1.hexdigest(password)
    end
  
   def checkadmin                            #:doc:
      if(session[:user_id]!=nil)
      unless session[:rolename] == "admin"
        flash[:notice] = "You are not authorized to view this page"
         redirect_to(:controller => 'time_sheets') 
       end
       else
       redirect_to(:controller => "login", :action => "login")
       end
   end
   def rescue_action_in_public(exception)
      case exception
      when ActiveRecord::RecordNotFound, ActionController::UnknownAction
      render(:file => "#{RAILS_ROOT}/public/404.html",
      :status => "404 Not Found")
      else
      render(:file => "#{RAILS_ROOT}/public/500.html",
      :status => "500 Error")
      SystemNotifier.deliver_exception_notification(
      self, request, exception)
      end
  end

end
