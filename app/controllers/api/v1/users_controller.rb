class Api::V1::UsersController < ApplicationController
  def index
    @users = User.all.map { |user| { id: user.id, name: user.name, email: user.email} }

    render json: @users
  end

  def show
    @user = User.find(params[:id])

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
    @user = User.find(params[:id])

    @user.destroy

    head :no_content
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_paramas)
      render formats: :json, status: :ok, notice: 'Successfully updated.'
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
