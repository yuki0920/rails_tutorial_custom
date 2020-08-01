class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  http_basic_authenticate_with name: 'user', password: 'password'

  def index
    @users = User.all.map { |user| { id: user.id, name: user.name, email: user.email} }

    render json: @users
  end

  def show
    render json: @user
  end

  def create
    @user = User.new(user_params)

    if @user.save
      @user.send_activation_email

      render formats: :json, status: :created, notice: 'Successfully created.'
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy

    head :no_content
  end

  def update
    if @user.update(user_paramas)
      render formats: :json, status: :ok, notice: 'Successfully updated.'
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
