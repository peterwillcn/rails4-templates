# coding: utf-8
require 'active_record/fixtures'

def fixture_entry(table_name, objects)
  begin
    klass = table_name.classify.constantize
  rescue
    Object.const_set table_name.classify, Class.new(ActiveRecord::Base) {
      self.table_name = table_name
    }
    klass = table_name.classify.constantize
  end
  res = {}
  objects.each do |obj|
    name = "#{table_name.singularize}#{obj['id']}"
    res[name] = {}
    klass.columns.each do |column|
      res[name][column.name] = obj[column.name]
    end
  end
  res.to_yaml
end

namespace :customs do
  fixtures_dir = "#{::Rails.root}/tmp/fixtures/"
  namespace :fixtures do
    desc 'Extract database data to the tmp/fixtures/ directory. Use FIXTURES=table_name[,table_name...] to specify table names to extract. Otherwise, all the table data will be extracted.'
    task extract: :environment do
      sql = 'SELECT * FROM %s ORDER BY id'
      skip_tables = %w(schema_migrations sessions delayed_jobs)
      ActiveRecord::Base.establish_connection
      FileUtils.mkdir_p(fixtures_dir)

      if ENV['FIXTURES']
        table_names = ENV['FIXTURES'].split(/,/)
      else
        table_names = (ActiveRecord::Base.connection.tables - skip_tables)
      end

      table_names.each do |table_name|
        p "extract #{table_name}."
        File.open("#{fixtures_dir}#{table_name}.yml", 'w') do |file|
          objects  = ActiveRecord::Base.connection.select_all(sql % table_name)
          file.write fixture_entry(table_name, objects)
        end
      end
    end
    
    desc 'Load data in tmp/fixtures dir to db. Use FIXTURES=table_name[,table_name...] to specify table names to load.'
    task load: :environment do
      if ENV['FIXTURES']
        ENV['FIXTURES'].split(/,/).each do |table_name|
          p "load #{table_name}."
          if YAML.load_file("#{Rails.root}/config/database.yml")[Rails.env]['adapter'] == 'sqlite3'
            ActiveRecord::Base.connection.execute("DELETE FROM #{table_name}")
          else
            ActiveRecord::Base.connection.execute("TRUNCATE #{table_name}")
          end
          begin
            ActiveRecord::Fixtures.create_fixtures("#{::Rails.root}/tmp/fixtures", table_name)
          rescue NameError
            Fixtures.create_fixtures("#{::Rails.root}/tmp/fixtures", table_name)
          end
        end
      end
    end
    
    desc 'Export database data to the tmp/fixtures/ directory. Use FIXTURES=table_name[,table_name...] to specify table names to extract.'
    task seed: :environment do
      sql = 'SELECT * FROM %s ORDER BY id'
      if ENV['FIXTURES']
        ENV['FIXTURES'].split(/,/).each do |table_name|
          p "export #{table_name}."
          File.open("#{fixtures_dir}#{table_name}.yml", 'w') do |file|
            objects  = ActiveRecord::Base.connection.select_all(sql % table_name)
            file.write fixture_entry(table_name, objects)
          end
        end
      end
    end
  end
end
