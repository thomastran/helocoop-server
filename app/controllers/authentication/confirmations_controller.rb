class Authentication::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  def new
    super
    puts "new"
  end

  # POST /resource/confirmation
  def create
    super
    puts "create"
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    super
    puts "show"
  end

  # protected

  # The path used after resending confirmation instructions.
  def after_resending_confirmation_instructions_path_for(resource_name)
    super(resource_name)
    puts "after_resending_confirmation_instructions_path_for"
  end

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    super(resource_name, resource)
    puts "after_confirmation_path_for"
  end
end
