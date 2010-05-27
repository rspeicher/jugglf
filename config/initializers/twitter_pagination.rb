# Modified from flow_pagination gem
module TwitterPagination

  # TwitterPagination renderer for (Mislav) WillPaginate Plugin
  class LinkRenderer < WillPaginate::LinkRenderer

    def to_html
      pagination = ''

      if self.current_page < self.last_page
        pagination = @template.link_to_remote(
          'More',
          :url => { :controller => @template.controller_name,
            :action => @template.action_name,
            :params => @template.params.merge!(:page => self.next_page)},
          :method => @template.request.request_method,
          :html => { :class => 'twitter_pagination' })
      end

      @template.content_tag(:div, pagination, :class => 'pagination', :id => self.html_attributes[:id])
    end

    protected

      # Get current page number
      def current_page
        @collection.current_page
      end

      # Get last page number
      def last_page
        @last_page ||= WillPaginate::ViewHelpers.total_pages_for_collection(@collection)
      end

      # Get next page number
      def next_page
        @collection.next_page
      end

  end

end
