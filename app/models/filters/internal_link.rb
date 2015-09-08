module Filters
  class InternalLink < HTML::Pipeline::Filter
    def call
      wiki_id = context[:wiki_id]
      return doc if wiki_id.blank?
      wiki = Wiki.find_by(id: wiki_id)
      doc.search('a').each do |a|
        next if a[:href].blank?
        next if a[:href] =~ /\A#/
        slug = a[:href].gsub(/\A.*\//, '')
        page = wiki.pages.find_by(slug: slug) if wiki.present?
        a.content = page.title if page.present?
      end
      doc
    end
  end
end
