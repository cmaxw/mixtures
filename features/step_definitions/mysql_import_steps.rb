Given /^I can connect to mysql$/ do
  @mysql = Mysql.real_connect("localhost", "root", "")
  
end

Given /^I have a database "([^\"]*)"$/ do |db|
  @mysql.query("DROP DATABASE #{db};")
  @mysql.query("CREATE DATABASE #{db};")
end

Given /^"([^\"]*)" has a table "([^\"]*)"$/ do |db, table|
  @mysql.query("USE #{db};")
  @mysql.query("CREATE TABLE #{table} (id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY);")
end

Given /^"([^\"]*)" has a "([^\"]*)" column "([^\"]*)"$/ do |table, type, column|
  type = "VARCHAR(45)" if type == "string"
  type.upcase!
  @mysql.query("ALTER TABLE #{table} ADD COLUMN #{column} #{type}")
end

Given /^"([^\"]*)" has a record with id = "([^\"]*)"$/ do |table, id|
  @id = id
  @table = table
  @mysql.query("INSERT INTO #{table} (id) VALUES (#{id})")
end

Given /^the record has value "([^\"]*)" = "([^\"]*)"$/ do |column, value|
  record = @mysql.query("UPDATE #{@table} SET #{column} = '#{value}' WHERE id = #{@id}")
end

When /^I import "([^\"]*)" to dataset "([^\"]*)"$/ do |database, dataset|
  Mixtures.import(:database => database, :dataset => dataset)
end

Then /^I should have a record for dataset "([^\"]*)" with table "([^\"]*)" and id "([^\"])"$/ do |dataset, table, id|
  @dataset = Mixtures::Dataset.find_by_name(dataset)
  @record = @dataset.records.find_by_table_and_id(table, id)
end

Then /^the record should have key "([^"]*)" with value "([^"]*)"$/ do |key, value|
  data = JSON.parse(@record.data)
  data.should have_key(key)
  data[key].should == value
end
