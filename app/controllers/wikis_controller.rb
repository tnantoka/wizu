class WikisController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wiki, only: %i(show edit update destroy tree search activities)
  authorize_resource

  def show
    redirect_to page_path(@wiki) and return unless @wiki.wiki?
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
    redirect_to edit_page_path(@wiki) and return unless @wiki.wiki?
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

  def search
    @pages = params[:q].present? ? @wiki.subtree.search(params[:q]).recent.page(params[:page]).per(10) : Page.none
  end

  def activities
    @activities = @wiki.activities.reorder(created_at: :desc).includes(:item).page(params[:page]).per(10)
  end

  private
    def wiki_params
      params.require(:wiki).permit(:title, :content, :slug, :secret)
    end
end
