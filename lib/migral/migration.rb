require 'csv'
require 'erb'

module Migral

  class Migration

    attr_reader :attributes

    def initialize(type, csv_file_path, table_name, separator = ",")
      @type          = type
      @table_name    = table_name
      @csv_file_path = csv_file_path
      @separator     = separator || ","
    end

    def dump!
      @row_count  = IO.readlines(@csv_file_path).size
      @row_number = 0

      CSV.foreach(@csv_file_path, {:col_sep => @separator}) do |row|
        if @row_number == 0
          @attributes = row
          @first_row  = false
        else
          sum_attr_size! row
          return generate(@attributes, @table_name) if im_on_the_last_line?
        end

        @row_number += 1
      end
    end

##############################################################################
#
    private

    def generate(attributes, table_name)
      @template = File.read "lib/templates/#{@type}.erb"
      @migration = ERB.new(@template, 0, '<>').result(binding)
    end

    def im_on_the_last_line?
      @row_number + 1 == @row_count
    end

    def sum_attr_size!(row)
      @sum_attr_size ||= []

      row.size.times do |n|
        next if row[n].nil?
        if @sum_attr_size[n].nil? or row[n].size > @sum_attr_size[n]
          @sum_attr_size[n] = row[n].size
        end
      end
    end

  end

end
