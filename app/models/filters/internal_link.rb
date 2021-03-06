module Filters
  class InternalLink < HTML::Pipeline::Filter
    def call
      wiki_id = context[:wiki_id]
      wiki = Wiki.find_by(id: wiki_id)
      return doc if wiki.blank?
      doc.search('a').each do |a|
        href = a[:href]
        next if href.blank?
        next if href =~ /\A#/
        slug = href.gsub(/\A.*\//, '')
        page = wiki.pages.find_by(slug: slug)
        if page.present?
          a.content = page.title
          a[:href] = href.gsub(/\A.*\/\/.*?\//, '/')
          a[:title] = href
        end
      end
      doc
    end
  end
end
