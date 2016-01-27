class OnlyAuthorsAuthorization < ActiveAdmin::AuthorizationAdapter

  def authorized?(action, subject = nil)
    puts action.to_s
    case subject
    when normalized(User)
      # Only let the author update and delete posts
      if action == :read || action == :destroy
        true
      else
        false
      end
    else
      true
    end
    # return true
  end

end
