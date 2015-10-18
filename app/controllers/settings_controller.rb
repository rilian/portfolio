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
    if @setting.update_attributes(setting_params)
      redirect_to setting_path(@setting)
    else
      render :edit
    end
  end

  def destroy
    @setting.destroy
    redirect_to settings_path
  end

private

  def setting_params
    params.require(:setting).permit(
      :env, :host, :title, :copyright_holder, :contact_text,
      :contact_text_ua, :facebook_account, :instagram_account, :flickr_user_id, :linkedin_account,
      :description, :google_analytics_account
    )
  end
end
