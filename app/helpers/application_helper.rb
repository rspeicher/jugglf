# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def breadcrumb(*args)
    args.join(' &raquo; ')
  end
  
  def link_to_tab(text, path = nil)
    path = ( path.nil? ) ? "##{text.gsub(/^(\w+).*/, '\1').downcase}" : path
    
    link_to "<span>#{text}</span>", path
  end
  
  def link_to_delete(options = {})
    return if options[:path].nil?
    
    options[:text]    ||= 'Delete'
    options[:confirm] ||= 'Are you sure?'
    
    link_to(image_tag('delete.png') + options[:text], options[:path], 
      :confirm => options[:confirm], :method => :delete, :class => 'negative')
  end
  
  def link_to_remote_delete(object, options = {})
    return if object.nil?
    
    klass = object.class.to_s.downcase
    
    options[:url]     ||= polymorphic_path(object)
    options[:text]    ||= ''
    options[:confirm] ||= 'Are you sure?'
    options[:success] ||= "$('##{klass}-#{object.id}').fadeOut(250); zebraRows('#{klass}', 300)"
    
    link_to_remote(image_tag('delete.png') + options[:text], 
      :url     => options[:url],
      :confirm => options[:confirm],
      :method  => :delete,
      :success => options[:success])
  end
  
  def progress_bar(width, options = {})
    options[:container_width] ||= '95'
    options[:color]           ||= '#ACE97C'
    
    "<div class='progress-container' style='width: #{options[:container_width].to_i}%'>" +
      "<div style='width: #{width.to_i}%; background-color: #{options[:color]}'></div>" +
    "</div>"
  end
  
  def link_to_login_or_logout
    if current_user
      link_to('Logout', user_session_path, :method => :delete, 
        :confirm => 'Are you sure you want to log out?')
    else
      link_to('Login', new_user_session_path)
    end
  end
end