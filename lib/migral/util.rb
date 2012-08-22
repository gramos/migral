module Migral
  module Util
    def self.camelize(str)
      str.to_s.split("_").map{|e| e.capitalize}.join
    end
  end
end
