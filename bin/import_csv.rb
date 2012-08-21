require 'csv'
require "import_arg_parser"

def gen_migration(attributes, table_name)
  puts <<EOS
    Sequel.migration do
      up do
        create_table(:#{table_name}) do
        primary_key :id
EOS
  attributes.each_with_index{|a, i| puts "        String '#{a}', :size => #{@sum_attr_size[i]}" }
  puts <<EOS
    end
  end
  down do
    drop_table(:#{table_name})
  end
end
EOS
end

def parse_and_create_record(record_data, attributes, sequel_class)
  record = {}
  attributes.each do |a|
    index = attributes.index(a)
    record[a] = record_data[index]
  end

  if DEBUG
    puts c
  else
    print "+"
  end
  sequel_class.create(record)
end

def delete_table_data
  puts "\n*** Im going to delete all data in #{@sequel_class}!!! ******"
  puts "\nPress ctrl + c to cancel"
  sleep 5
  puts "Deleting #{@sequel_class}..."
  @sequel_class.delete
end

def sum_attr_size!(row)
  @sum_attr_size ||= []

  row.size.times do |n|
    if @sum_attr_size[n].nil? or row[n].size > @sum_attr_size[n]
      @sum_attr_size[n] = row[n].size
    end
  end
end

def process_row(row)
  if @action == "gen_migration"
    sum_attr_size! row

    if @row_number +1 == @row_count
      gen_migration @attributes, @table_name
    end
  end

  if @action == "import"
    parse_and_create_record row, @attributes, @sequel_class
  end
end

opt = ArgParser.parse(ARGV)

if ARGV[3] == 'debug'
  DEBUG = true
else
  DEBUG = false
end

@csv_file     = opt.csv_file
@action       = opt.action
@separator    = opt.separator || ","
@sequel_class = Kernel.const_get opt.sequel_class if @action == "import"
@table_name   = opt.table_name if @action == "gen_migration"
@first_row    = true
@row_count    = %x{wc -l < "#{@csv_file}"}.to_i
@row_number   = 0


CSV.foreach(@csv_file, {:col_sep => @separator}) do |row|
  if @first_row
    @attributes = row
    @first_row  = false

    if @action == "import"
      delete_table_data
      puts "\n==> Importing records data from #{@csv_file}..."
    end
  else
    process_row row
  end
  @row_number += 1
end

