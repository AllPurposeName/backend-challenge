class UsersController < ApplicationController

  def show
    user      = User.find_by(id: params[:id])
    blueprint = UserBlueprint.render(user, view: :normal)

    render json: blueprint, status: 200
  end

  def index
    users     = User.all
    blueprint = UserBlueprint.render(users, view: :compact)

    render json: blueprint, status: 200
  end

  def create
    user = UserService.create!(
      name: strong_params[:name],
      personal_website: strong_params[:personal_website]
    )
    blueprint = UserBlueprint.render(user, view: :normal)

    render json: blueprint, status: 201
  rescue ApiError::BasicError => error
    render json: ErrorBlueprint.render(error), status: error.http_status_code
  end

  def find_experts
    user = User.find_by(id: strong_find_experts_params[:id])

    expert = ExpertFinderService.find_expert(desired_expertise: strong_find_experts_params[:expertise], user: user)

    render json: UserBlueprint.render(user, options: expert, view: :extended), status: 200
  rescue ApiError::BasicError => error
    render json: ErrorBlueprint.render(error), status: error.http_status_code
  end

  def strong_params
    params.permit(:name, :personal_website)
  end

  def strong_find_experts_params
    params.permit(:id, :expertise)
  end
end
