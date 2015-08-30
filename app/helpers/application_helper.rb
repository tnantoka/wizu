module ApplicationHelper
  def time_ago(time)
    content_tag :span, t('global.time_ago', time: time_ago_in_words(time)), title: l(time)
  end

  def icon(class_name)
    content_tag :i, '', class: "fa fa-fw fa-#{class_name}"
  end

  def diff(string1, string2)
    Diffy::Diff.new(string1.to_s, string2.to_s, include_plus_and_minus_in_html: true).to_s(:html).html_safe
  end
end
