class CollaborationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wiki, only: %i(index create)
  before_action :set_collaboration, only: %i(destroy)
  authorize_resource :wiki
  authorize_resource

  def index
    @collaborations = @wiki.collaborations.includes(:user)
    @collaboration = Collaboration.new
    @users = User.where.not(id: [current_user.id] + @collaborations.pluck(:user_id))
  end

  def create
    @collaboration = @wiki.collaborations.find_or_create_by(user_id: collaboration_params[:user_id])
    redirect_to wiki_collaborations_path(@wiki), notice: t('flash.application.created', resource_name: Collaboration.model_name.human)
  end

  def destroy
    @collaboration.destroy!
    redirect_to wiki_collaborations_path(@wiki), notice: t('flash.application.destroyed', resource_name: Collaboration.model_name.human)
  end

  private
    def collaboration_params
      params.require(:collaboration).permit(:user_id)
    end

    def set_collaboration
      @collaboration = Collaboration.find(params[:id])
      @wiki ||= @collaboration.wiki
    end
end
