module Filters
  class ExternalLink < HTML::Pipeline::Filter
    def call
      doc.search('a').each do |a|
        href = a[:href].to_s
        next unless href =~ /\A(?:https?:)?\/\//
        a[:title] = href
        a[:href] = "/r?u=#{CGI.escape(href)}"
        a[:target] = '_blank'
      end
      doc
    end
  end
end
