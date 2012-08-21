module Migral

  class Migration

    def initialize(type = 'active_record')
      @type = type
    end

    def generate(attributes, table_name)
      @template = File.read "lib/templates/#{@type}.erb"
      @migration = ERB.new(@template).result(binding)
    end

    def sum_attr_size!(row)
      @sum_attr_size ||= []

      row.size.times do |n|
        if @sum_attr_size[n].nil? or row[n].size > @sum_attr_size[n]
          @sum_attr_size[n] = row[n].size
        end
      end
    end

  end

end
