module NavigationHelpers
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      root_path

    when /^my standing page$/
      member_path(User.last.member)

    when /the members? index/
      members_path

    when /^the item page for (.*)$/i
      item_path(Item.find_by_name($1))

    when /^the member page for (.*)$/i
      member_path(Member.find_by_name($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
