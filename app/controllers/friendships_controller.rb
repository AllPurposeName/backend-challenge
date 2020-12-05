class FriendshipsController < ApplicationController
  def create
    friendship = FriendshipService.create!(
      user_id: strong_params[:user_id],
      friend_id: strong_params[:friend_id]
    )
    blueprint = FriendshipBlueprint.render(friendship)

    render json: blueprint, status: 201
  rescue ApiError::BasicError => error
    render json: ErrorBlueprint.render(error), status: error.http_status_code
  end

  def strong_params
    params.permit(:user_id, :friend_id)
  end
end

