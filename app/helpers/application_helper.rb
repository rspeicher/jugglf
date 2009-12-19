# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def admin?
    unless current_user.nil?
      return current_user.is_admin?
    else
      return false
    end
  end
  
  def breadcrumb(*args)
    # Insert the first breadcrumb, it's always the same
    content_for(:breadcrumb) { content_tag(:li, link_to('Juggernaut Loot Factor', root_url), :class => 'first') }

    # Insert the supplied arguments
    args.each do |arg|
      content_for(:breadcrumb) { content_tag(:li, arg) }
    end
  end
  
  def link_to_tab(text, path = nil)
    path = ( path.nil? ) ? "##{text.gsub(/^(\w+).*/, '\1').downcase}" : path
    
    link_to "<span>#{h(text)}</span>", path
  end
  
  def link_to_controller(mod, options = {})
    return if options[:admin_only] and not current_user.is_admin?
    
    controller_name = mod.to_s.downcase.pluralize
    path = ( mod.respond_to? :new ) ? polymorphic_path(mod.new) : ''
    css = ( controller.controller_name == controller_name ) ? 'selected' : ''
    
    link_to h(controller_name.titlecase), path, :class => css
  rescue NameError
    return ''
  end
  
  def link_to_delete(options = {})
    return if options[:path].nil?
    
    options[:text]    ||= 'Delete'
    options[:confirm] ||= 'Are you sure you want to delete this record?'
    options[:image]   = (options[:image].nil?) ? true : options[:image]
    options[:class]   ||= 'negative'
    
    image = ( options[:image] == true ) ? image_tag('delete.png') : ''
    
    link_to(image + h(options[:text]), options[:path], 
      :confirm => options[:confirm], :method => :delete, :class => options[:class])
  end
  
  def link_to_remote_delete(object, options = {})
    return if object.nil?
    
    klass = object.class.to_s.downcase
    
    options[:url]     ||= polymorphic_path(object)
    options[:text]    ||= ''
    options[:confirm] ||= 'Are you sure you want to delete this record?'
    options[:success] ||= "$('##{klass}_#{object.id}').fadeOut(250); zebraRows('#{klass}', 300)"
    
    link_to_remote(image_tag('delete.png') + h(options[:text]), 
      :url     => options[:url],
      :confirm => options[:confirm],
      :method  => :delete,
      :success => options[:success])
  end
  
  def progress_bar(options = {})
    options[:width]           ||= 0
    options[:container_width] ||= '95'
    options[:color]           ||= '#ACE97C'
    
    options[:width] *= 100 if options[:width] <= 1.00
    
    "<div class='progress-container' style='width: #{options[:container_width].to_i}%'>" +
      "<div style='width: #{options[:width].to_i}%; background-color: #{options[:color]}'></div>" +
    "</div>"
  end
  
  def link_to_login_or_logout
    if current_user
      link_to("Sign Out", '/logout', :method => :delete, 
        :confirm => 'Are you sure you want to log out?')
    else
      link_to(image_tag('http://www.juggernautguild.com/public/style_images/splat/key.png', :alt => '') + ' Sign In', '/login')
    end
  end
end