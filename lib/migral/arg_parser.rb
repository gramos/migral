require 'optparse'
require 'ostruct'
class ArgParser
  def self.parse(args)
    options = OpenStruct.new

   help = <<-EOS
   This script can be used to generate an ORM migration based on csv files headers.
   And it can be used for import data into a table.

   Generate a migration:
   --------------------

   Example: migral --csv_file example.csv --action gen_migration
                          --table_name examples --migration_type sequel
                          --separator \|


   Import data:
   -------------

   Example: migral --csv_file example.csv --action import --sequel_class Example
                          --separator \|

   EOS

    opts = OptionParser.new do |opts|
      opts.on("-f", "--csv_file FILE", "Csv file with data to be imported") do |f|
        options.csv_file = f
      end

      opts.on("-a", "--action ACTION", "Action to execute, it can be 'import' or 'gen_migration'.") do |a|
        options.action = a
      end

      opts.on("-t", "--table_name TABLE", "Table name to generate the migration") do |t|
        options.table_name = t
      end

      opts.on("-m", "--migration_type TYPE", "Migration type name to generate the migration (active_record, sequel)") do |m|
        options.migration_type = m
      end

      opts.on("-c", "--sequel_class CLASS_NAME", "Sequel model class") do |c|
        options.sequel_class = c
      end

      opts.on("-s", "--separator SEPARATOR", "Csv Separator") do |s|
        options.separator = s
      end

      opts.on_tail("-h", "--help", "Show this message") do
        puts help
        puts opts

        exit
      end
    end

    opts.parse!(args)
    options
  end
end
