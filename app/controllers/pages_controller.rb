class PagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wiki, only: %i(new create)
  before_action :set_page, only: %i(show edit update destroy histories)
  authorize_resource :wiki
  authorize_resource

  def show
    redirect_to wiki_path(@page) and return if @page.wiki?
    respond_to do |format|
      format.html {
        if params[:format].present?
          render text: @page.render(link_filters: [::Filters::InternalLink, ::Filters::RemoveFragment]), content_type: 'text/plain'
        end
      }
      format.md { render text: @page.render(format: :md) }
    end
  end

  def new
    @page = Page.new
    @parent = Page.find_by(id: params[:parent_id])
    @page.parent_id = @parent
  end

  def create
    @page = current_user.pages.new(page_params)
    if @page.save
      redirect_to @page, notice: t('flash.application.created', resource_name: Page.model_name.human)
    else
      render :new
    end
  end

  def edit
    redirect_to edit_wiki_path(@page) and return if @page.wiki?
  end

  def update
    if @page.update(page_params)
      redirect_to @page, notice: t('flash.application.updated', resource_name: Page.model_name.human)
    else
      render :edit
    end
  end

  def destroy
    parent = @page.parent
    @page.destroy!
    redirect_to (parent.wiki? ? wiki_path(parent) : parent), notice: t('flash.application.destroyed', resource_name: Page.model_name.human)
  end

  def histories
    @versions = @page.versions.reorder(created_at: :desc).includes(:item).page(params[:page]).per(5)

    # @pages = [@page] + @versions.to_a.map { |v| v.reify } # Doesn't work?
    @pages = []
    prev = params[:page].to_i > 1 ? @versions.take.reify : @page
    begin
      @pages << prev
    end while prev = prev.previous_version
    @pages << Page.new
  end

  private
    def set_page
      @page = Page.find_by!(slug: params[:id])
      @wiki ||= @page.wiki
    end
end
