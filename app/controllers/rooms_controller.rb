class RoomsController < ApplicationController
  def index
    @rooms = Room.all
  end

  def new
    @room = current_user.room.new
  end

  def show
    @room = Room.find_by id: params[:id]
    if @room.present?
      if !current_user.is_admin?
        if !(current_user.room.id == @room.id)
          flash[:danger] = "Something wrong"
          redirect_to root_path
        else
          @messages = @room.messages.includes(:user).order(created_at: :asc)
        end
      end
    else 
      flash[:danger] = "Your room isn't exist"
      redirect_to root_path
    end
  end

  def create
    @room = current_user.room.new room_params

    if @room.save
      flash[:success] = "Room is created"
      redirect_to root_url
    else
      flash.now[:danger] = "Something wrong"
      render :new
    end
  end

  private

  def room_params
    params.require(:room).permit :name, :image
  end
end
