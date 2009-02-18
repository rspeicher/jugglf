# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def link_to_tab(text, path = nil)
    path = ( path.nil? ) ? "##{text.gsub(/^(\w+).*/, '\1').downcase}" : path
    
    link_to "<span>#{text}</span>", path
  end
  
  def progress_bar(width, *args)
    options = args.extract_options!
    options.symbolize_keys!
    
    defaults = { 
      :container_width => "95",
      :color => "#ACE97C"
    }
    container_width ||= (options[:container_width] || defaults[:container_width])
    color ||= (options[:color] || defaults[:color])
    
    "<div class='progress-container' style='width: #{container_width.to_i}%'>" +
      "<div style='width: #{width.to_i}%; background-color: #{color}'></div>" +
    "</div>"
  end
end