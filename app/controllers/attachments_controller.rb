class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wiki, only: %i(index create)
  before_action :set_attachment, only: %i(show destroy)

  def index
    @attachments = @wiki.attachments.recent.page(params[:page]).per(20)
  end

  def show
    data = Paperclip.io_adapters.for(@attachment.data).read
    send_data data, type: @attachment.data_content_type, disposition: 'inline'
  end

  def create
    @attachment = current_user.attachments.new(attachment_params)
    
    if @attachment.save
      render json: @attachment.to_builder.target!
    else
      render json: @attachment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @attachment.destroy!
    redirect_to wiki_attachments_path(@wiki), notice: t('flash.application.destroyed', resource_name: Attachment.model_name.human)
  end

  private
    def attachment_params
      params.require(:attachment).permit(:data, :page_id)
    end

    def set_attachment
      @attachment = Attachment.find_by!(slug: params[:id])
      @wiki ||= @attachment.page.root
    end
end
