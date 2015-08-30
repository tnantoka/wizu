class WikisController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wiki, only: %i(show edit update destroy tree)

  def show
  end

  def new
    @wiki = Wiki.new
    @wiki.set_slug
  end

  def create
    @wiki = current_user.wikis.new(wiki_params)
    if @wiki.save
      redirect_to @wiki, notice: t('flash.application.created', resource_name: Wiki.model_name.human)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @wiki.update(wiki_params)
      redirect_to @wiki, notice: t('flash.application.updated', resource_name: Wiki.model_name.human)
    else
      render :edit
    end
  end

  def destroy
    @wiki.destroy!
    redirect_to :dashboard, notice: t('flash.application.destroyed', resource_name: Wiki.model_name.human)
  end

  def tree
  end

  private
    def wiki_params
      params.require(:wiki).permit(:title, :content, :slug)
    end
end
