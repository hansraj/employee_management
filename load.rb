require 'config/environment.rb'
require 'mysql'

system('nohup ruby script/generate employee_migration &')
system('nohup rake db:migrate &')

mysql = Mysql.init()

# change  the mysql connection parameters accordingly
mysql.connect('localhost', 'ejosh', 'josh123@', 'eJosh')

mysql.query("update extensions set entry_point = '/employees' where id = #{ARGV} ;")

mysql.close()

