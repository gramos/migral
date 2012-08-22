module Migral

  class Importer

    def initialize(klass, csv_file, separator)
      @klass          = eval klass
      @csv_file_path  = csv_file
      @separator      = separator
      set_attributes!
    end

    def set_attributes!
      reader = CSV.open @csv_file_path, "r"
      @attributes = reader.shift
    end

    def parse_and_create_record(record_data)
      record = {}
      @attributes.each do |a|
        index = @attributes.index(a)
        record[a] = record_data[index]
      end
      print "+"

      @klass.create(record)
    end

    def import!
      CSV.foreach(@csv_file_path, {:col_sep => @separator}) do |row|
        parse_and_create_record row
      end
    end

    def delete_table_data
      puts "\n*** Im going to delete all data in #{@klass}!!! ******"
      puts "\nPress ctrl + c to cancel"
      sleep 5
      puts "Deleting #{@klass}..."
      @klass.delete
    end
  end

end
