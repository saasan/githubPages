require 'cgi'

module Entities
    def remove_extra_whitespace(input)
        input.gsub(/\s+/, ' ')
    end

    Liquid::Template.register_filter self
end
