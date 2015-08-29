module ApplicationHelper
  def time_ago(time)
    content_tag :span, t('global.time_ago', time: time_ago_in_words(time)), title: l(time)
  end

  def icon(class_name)
    content_tag :i, '', class: "fa fa-fw fa-#{class_name}"
  end
end
