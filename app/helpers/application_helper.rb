module ApplicationHelper
  def admin?
    unless current_user.nil?
      return current_user.is_admin?
    else
      return false
    end
  end

  def page_title(*args)
    args.push('Juggernaut Loot Factor')
    content_for(:page_title) { args.join(' :: ') }
  end

  def breadcrumb(*args)
    # Insert the first breadcrumb, it's always the same
    content_for(:breadcrumb) { content_tag(:li, link_to('Juggernaut Loot Factor', root_url), :class => 'first') }

    # Insert the supplied arguments
    args.each do |arg|
      content_for(:breadcrumb) { content_tag(:li, arg) }
    end
  end

  def link_to_delete(path, options = {})
    options[:path]    ||= path
    # options[:text]  ||= 'Delete'
    options[:class]   ||= 'negative delete'
    options[:confirm] ||= "Are you sure you want to delete this record?"
    options[:image]     = options[:image].nil?  ? true : options[:image]
    options[:remote]    = options[:remote].nil? ? true : options[:remote]

    raise ArgumentError, "path is required" if options[:path].blank?

    image = ( options[:image] == true ) ? image_tag('delete.png', :alt => "Delete") : ''
    link_to(image, options.delete(:path), options.merge(:method => :delete))
  end

  def progress_bar(options = {})
    options[:width]           ||= 0
    options[:container_width] ||= '95'
    options[:color]           ||= '#ACE97C'

    options[:width] *= 100 if options[:width] <= 1.00

    # IP.Board Splat stlyle:
    # content_tag(:p, :title => "Percentage: #{options[:width].to_i}%", :class => "progress_bar") do
    #   content_tag(:span, :style => "width: #{options[:width].to_i}") do
    #     content_tag(:span, "Percentage: #{options[:width].to_i}%")
    #   end
    # end

    # Custom style:
    content_tag(:div, :class => 'progress-container', :style => "width: #{options[:container_width].to_i}%") do
      content_tag(:div, nil, :style => "width: #{options[:width].to_i}%; background-color: #{options[:color]}")
    end
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
