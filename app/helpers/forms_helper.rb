module FormsHelper
  def styled_button(options = {})
    options[:type]  ||= 'submit'
    options[:style] ||= ''
    options[:image] ||= ''
    options[:text]  ||= options[:type].titleize
    
    s = ''
    s << "<button type='#{options[:type]}' class='#{options[:style]}'>"
    s << image_tag(options[:image], :alt => options[:text]) unless options[:image].empty?
    s << options[:text]
    s << "</button>"
    
    s
  end
end