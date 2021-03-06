require 'blurrily/map_ext'
require 'active_support/core_ext/module/aliasing' # alias_method_chain
require 'active_support/core_ext/string/multibyte' # mb_chars

module Blurrily
  Map.class_eval do

    def put_with_string_normalize(needle, reference, weight=nil)
      weight ||= 0
      needle = normalize_string needle
      put_without_string_normalize(needle, reference, weight)
    end

    alias_method_chain :put, :string_normalize


    def find_with_string_normalize(needle, limit=10)
      needle = normalize_string needle
      find_without_string_normalize(needle, limit)
    end

    alias_method_chain :find, :string_normalize


    private

    def normalize_string(needle)
      result = needle.downcase
      unless result =~ /^([a-z ])+$/
        result = ActiveSupport::Multibyte::Chars.new(result).mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/,'').to_s.gsub(/[^a-z]/,' ')
        # result = result.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/,'').to_s.gsub(/[^a-z]/,' ')
      end
      result.gsub(/\s+/,' ').strip
    end

  end
end
