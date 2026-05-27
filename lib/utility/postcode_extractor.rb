module Utility
  module PostcodeExtractor
    def self.extract(text)
    regexs = /\b[A-Z]{1,2}\d[A-Z\d]?\s?\d[A-Z]{2}\b/i
    text[regexs]&.upcase
    end
  end
end
