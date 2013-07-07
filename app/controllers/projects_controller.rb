class ProjectsController < ApplicationController
  load_resource :project

  def index
    @projects = @projects.unscoped if params[:q] && params[:q][:s]
    @q = @projects.search(params[:q])
    @projects = @q.result
  end

  def show
  end
end
