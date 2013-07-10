class ProjectsController < ApplicationController
  load_and_authorize_resource :project

  def index
    @projects = @projects.unscoped if params[:q] && params[:q][:s]
    @q = @projects.search(params[:q])
    @projects = @q.result
    @projects = @projects.order('weight DESC') if params[:q].nil?
    @projects = @projects.page(params[:page]).per(Project::PER_PAGE)
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
    @project.photos.build
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
