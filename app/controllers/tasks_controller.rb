class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:show, :new,  :edit, :update, :destroy]
  def index
    if logged_in?
      @task = current_user.tasks.build
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
    end
  end

  def show
    if logged_in?
    @task = Task.find(params[:id])
    end
  end

  def new
    if logged_in?
    @task = Task.new
    end
  end

  def create
    if logged_in?
    # @task = Task.new(task_params)
    @task = current_user.tasks.build(task_params)
    end
    if @task.save
      flash[:success] = 'Task が正常に作成されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task が作成されませんでした'
      render :new
    end
  end

  def edit
    if logged_in?
    @task = Task.find(params[:id])
    end
  end

  def update
    if logged_in?
    @task = Task.find(params[:id])
    end
    if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end

  def destroy
    if logged_in?
   # @task = Task.find(params[:id])
    @task.destroy
    end
    
    flash[:success] = 'Task は正常に削除されました'
    redirect_to tasks_url
  end
  
  private
  
  def task_params
    params.require(:task).permit(:content, :status)
  end

  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end
