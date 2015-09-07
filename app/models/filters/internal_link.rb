module Filters
  class InternalLink < HTML::Pipeline::Filter
    def call
      doc.search('a').each do |a|
        next if a[:href].blank?
        next if a[:href] =~ /\A#/
        slug = a[:href].gsub(/\A.*\//, '')
        page = Page.find_by(slug: slug)
        a.content = page.title if page.present?
      end
      doc
    end
  end
end
