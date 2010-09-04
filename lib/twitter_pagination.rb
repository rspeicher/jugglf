module TwitterPagination
  class LinkRenderer < WillPaginate::ViewHelpers::LinkRenderer
    protected

    def next_page
      previous_or_next_page(@collection.next_page, "More", 'twitter_pagination') if @collection.next_page
    end

    def pagination
      [ :next_page ]
    end

    # Override will_paginate's <tt>link</tt> method since it generates its own <tt>a</tt>
    # attribute and won't support <tt>:remote => true</tt>
    def link(text, target, attributes = {})
      if target.is_a? Fixnum
        attributes[:rel] = rel_value(target)
        target = url(target)
      end
      @template.link_to(text, target, attributes.merge(:remote => true))
    end
  end
end
