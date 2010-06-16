module Mixtures
  def self.import(options = {})
    options = {:host => "localhost", :user => "root", :password => "", :dataset => "default"}.merge(options)
    db = Mysql.connect(options[:host], options[:user], options[:password], options[:database])
    Dataset.create(:name => options[:dataset])
    table_results = db.query("SHOW TABLES")
    while t = table_results.fetch_row do
      import_table(t[0])
    end
  end
  
  def self.import_table(table_name)
    
  end
end