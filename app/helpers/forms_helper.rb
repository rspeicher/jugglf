module FormsHelper
  def styled_button(options = {})
    options[:type]  ||= 'button'
    options[:text]  ||= options[:type].titleize
    options[:style] ||= ( options[:type] == 'submit' ) ? 'positive' : ''
    options[:image] ||= ''
    
    s = ''
    s << "<button type='#{options[:type]}' class='#{options[:style]}'>"
    s << image_tag(options[:image], :alt => options[:text]).gsub('"', "'") unless options[:image].empty?
    s << options[:text]
    s << "</button>"
    
    s
  end
end