module Filters
  class RemoveFragment < HTML::Pipeline::Filter
    def call
      doc.search('span.fragment').each do |s|
        doc.at("a[href=\"##{s[:id]}\"]").remove
        s.remove
      end
      doc
    end
  end
end
