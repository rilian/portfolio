class SettingsController < ApplicationController
  load_and_authorize_resource :setting

  def index
  end

  def show
  end

  def new
  end

  def create
    if @setting.save
      redirect_to settings_path
    else
      render :edit
    end
  end

  def edit
  end

  def update
    if @setting.update_attributes(params[:setting])
      redirect_to setting_path(@setting)
    else
      render :edit
    end
  end

  def destroy
    @setting.destroy
    redirect_to settings_path
  end
end
