module Filters
  class EmbedPage < HTML::Pipeline::TextFilter
    def call
      @text.gsub(/!!\[\]\(.*\/p\/(\w+?)\)/i) do |match|
        slug = $1
        wiki_id = context[:wiki_id]
        page_slug = context[:page_slug]
        format = context[:format]
        wiki = Wiki.find_by(id: wiki_id)
        page = wiki.pages.find_by(slug: slug) if wiki.present? && page_slug != slug
        return match if page.blank?
        %|# [#{page.title}](/p/#{page.slug})\n\n#{page.render(format: format, wiki_id: wiki_id)}\n|
      end
    end
  end
end
