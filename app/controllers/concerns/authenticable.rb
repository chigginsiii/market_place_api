module Authenticable

  def current_user
    @current_user = User.find_by(auth_token: request.headers['Authorization'])
  end

  def authenticate_with_token!
    renders json: { errors: "Not authenticated" }, status: :unauthorized unless curent_user.present? 
  end

end
