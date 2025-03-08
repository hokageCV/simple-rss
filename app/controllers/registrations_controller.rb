class RegistrationsController < ApplicationController
  allow_unauthenticated_access
  include FormHelper

  rate_limit to: 10,
    within: 3.minutes,
    only: :create,
    with: -> { redirect_to new_registration_url, alert: "Try again later." }

  def new
    @user = User.new
  end

  def create
    @user = User.new(safe_params)

    if @user.save
      start_new_session_for @user
      redirect_to after_authentication_url, notice: "Welcome!"
    else
      flash.now[:alert] =  @user.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    flash.now[:alert] = "This email is already taken. Please use a different one."
    render :new, status: :unprocessable_entity
  rescue ActiveRecord::NotNullViolation
    flash.now[:alert] = "A required field is missing. Please fill in all fields."
    render :new, status: :unprocessable_entity
  rescue ActiveRecord::InvalidForeignKey
    flash.now[:alert] = "There is an issue linking this user to another record. Please check related data."
    render :new, status: :unprocessable_entity
  rescue ActiveRecord::StatementInvalid => e
    Rails.logger.error("Database error: #{e.message}")
    flash.now[:alert] = "An unexpected error occurred. Please try again later."
    render :new, status: :unprocessable_entity
  end

  private

  def safe_params
    params.require(:user).permit(:name, :email_address, :password, :password_confirmation)
  end
end
