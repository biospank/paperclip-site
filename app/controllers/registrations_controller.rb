class RegistrationsController < Devise::RegistrationsController

  protected

  def after_sign_up_path_for(resource)
    new_user_registration_url
  end

  def after_update_path_for(resource)
    edit_user_registration_url
  end

  def after_inactive_sign_up_path_for(resource)
    new_user_registration_url
  end
end
