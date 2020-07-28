# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :logged_in_user
  before_action :room_auth, only: :show

  def index
    @rooms = current_user.rooms.page(params[:page])
  end

  def create
    unless invite_user = User.at_nickname_user(params[:nickname])
      flash[:info] = 'ユーザーが見つかりません。'
      return redirect_to rooms_path
    end

    unless current_user.mutual_followers?(invite_user)
      flash[:info] = '相互フォロワーのみ使えます。'
      return redirect_to rooms_path
    end

    if room = current_user.invite_room_exist?(invite_user)
      flash[:info] = 'すでに作成されたroomへ移動しました。'
      return redirect_to room_path room
    end

    room = Room.create!
    room.create_room(current_user, invite_user)

    redirect_to room_path room
  end

  def show
    @room = Room.find(params[:id])
    @mesage = Message.new
  end

  private

  def room_auth
    redirect_to room_path unless current_user.rooms.find(params[:id])
  end
end
