Migral
======

Migral is a tool to help you working with csv files
without having . It generates migrations and imports data from a csv file, 
it comes with 2 diferent kind of migration templates, sequel and active record
but you can add a new one on template folder if you want to create
another type of migrations.

Install:
========

  gem install migral

Examples:
=========

Generate a migration:
--------------------

   Example: migral --csv_file example.csv --action gen_migration
                          --table_name examples --migration_type sequel
                          --separator \|


Import data:
-------------
 
   Example: migral --csv_file example.csv --action import --sequel_class Example
                          --separator \|

   