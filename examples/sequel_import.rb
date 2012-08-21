require 'sequel'
require 'sequel/adapters/postgres'

db_conf = {"database"=>"migral_test", "username"=>"migral",
           "password"=>"headache",
           "host"=>"localhost", "adapter"=>"postgres"}

DB = Sequel.connect db_conf

class Headache < Sequel::Model ; end
