class ProjectsController < ApplicationController
  load_resource :project

  def index
    @projects = @projects.unscoped if params[:q] && params[:q][:s]
    @q = @projects.search(params[:q])
    @projects = @q.result
  end

  def show
  end

  def new
  end

  def create
    if @project.save
      redirect_to projects_path
    else
      render :edit
    end
  end

  def edit
  end

  def update
    if @project.update_attributes(params[:project])
      redirect_to project_path(@project)
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path
  end
end
