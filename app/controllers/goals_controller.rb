class GoalsController < ApplicationController
  before_action :set_goal, only: [:show, :edit, :update, :destroy]
  before_action :set_title, only: [:index, :new, :edit]
  before_action :set_categories, only: [:new, :edit, :create, :update]

  def index
    @goals = current_user.goals.all
  end

  def show
  end

  def new
    @goal = current_user.goals.new
  end

  def edit
  end

  def create
    @goal = current_user.goals.new(goal_params)
    @goal.duration = params[:goal][:hours].to_i * 60 + params[:goal][:minutes].to_i

    if @goal.save
      redirect_to goals_path, success: t('.success')
    else
      render :new
    end
  end

  def update
    hours_to_minutes = params[:goal][:hours].to_i * 60
    minutes = params[:goal][:minutes].to_i
    total_duration = hours_to_minutes + minutes

    if @goal.update(goal_params.merge(duration: total_duration))
      redirect_to goals_path, success: t('.success')
    else
      render :edit
    end
  end

  def destroy
    @goal.destroy!
    redirect_to goals_url, success: t('.success')
  end

  private

  def goal_params
    params.require(:goal).permit(:schedule, :category_id)
  end

  def set_goal
    @goal = current_user.goals.find(params[:id])
  end

  def set_categories
    @categories = current_user.categories.all
  end

  def set_title
    @page_title = t('.title')
  end
end
