class UsersController < ApplicationController
  def create
    user = UserService.create!(
      name: strong_params[:name],
      personal_website: strong_params[:personal_website]
    )
    blueprint = UserBlueprint.render(user)

    render json: blueprint, status: 201
  rescue ApiError::BasicError => error
    render json: ErrorBlueprint.render(error), status: error.http_status_code
  end

  def strong_params
    params.permit(:name, :personal_website)
  end
end
