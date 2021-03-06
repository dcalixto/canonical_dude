module CanonicalDude
  module ActionViewMethods

    # tag to include within your HTML header, e.g.:
    #   <%= canonical_link_tag %>
    def canonical_link_tag( url_for_options = nil )
      url = canonical_url_from( url_for_options || @_canonical_url_for_options || request.url )
      tag( :link, :rel => 'canonical', :href => url ) if url # custom url methods may sometimes return nil --R
    end

    # returns true if canonical_url has been explicitly set
    def canonical_link_tag?
      !!@_canonical_url_for_options
    end


    private

    def canonical_url_from( url_for_options )
      case url_for_options
      when Hash
        url_for( url_for_options )
      when String
        url_for_options
      else
        # could be an AR instance, so let's try some custom methods
        # will turn a User instance into 'user'
        canonical_method_name = url_for_options.class.name.downcase.gsub( '::', '_' )

        custom_canonical_method_name = [
          "canonical_#{canonical_method_name}_url",
          "canonical_#{canonical_method_name}_path",
          "canonical_url_for"
        ].find { |m| respond_to? m }

        if custom_canonical_method_name
          send( custom_canonical_method_name, url_for_options )
        else
          url_for( url_for_options )
        end
      end
    end

  end
end

