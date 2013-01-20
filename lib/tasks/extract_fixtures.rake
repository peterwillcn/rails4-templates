# encoding: utf-8

require 'active_record/fixtures'

def fixture_entry(table_name, obj)
  res = []
  klass = table_name.singularize.camelize.constantize
  res << "#{table_name.singularize}#{obj['id']}:"
  klass.columns.each do |column|
    x = obj[column.name]
    x = sprintf("\"%s\"", x.gsub(/"/, '\"')) if column.text? && !x.nil?
    res << "  #{column.name}: #{x}"
  end
  res.join("\n")
end

namespace :cw do
  fixtures_dir = "#{::Rails.root}/tmp/fixtures/"
  namespace :fixtures do
    desc "Extract database data to the tmp/fixtures/ directory. Use FIXTURES=table_name[,table_name...] to specify table names to extract. Otherwise, all the table data will be extracted."
    task :extract => :environment do
      sql = "SELECT * FROM %s ORDER BY id"
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
        File.open("#{fixtures_dir}#{table_name}.yml", "w") do |file|
          objects  = ActiveRecord::Base.connection.select_all(sql % table_name)
          objects.each do |obj|
            file.write fixture_entry(table_name, obj) + "\n\n"
          end
        end
      end
    end
    
    desc "Load data in spec/fixtures dir to db. Use FIXTURES=table_name[,table_name...] to specify table names to load."
    task :load => :environment do
      if ENV['FIXTURES']
        ENV['FIXTURES'].split(/,/).each do |table_name|
          p "load #{table_name}."
          ActiveRecord::Base.connection.execute("TRUNCATE #{table_name}")
          ActiveRecord::Fixtures.create_fixtures("#{::Rails.root}/spec/fixtures", table_name)
        end
      end
    end
    
    desc "Export database data to the spec/fixtures/ directory. Use FIXTURES=table_name[,table_name...] to specify table names to extract."
    task :seed => :environment do
      sql = "SELECT * FROM %s ORDER BY id"
      if ENV['FIXTURES']
        ENV['FIXTURES'].split(/,/).each do |table_name|
          p "export #{table_name}."
          File.open("#{fixtures_dir}#{table_name}.yml", "w") do |file|
            objects  = ActiveRecord::Base.connection.select_all(sql % table_name)
            objects.each do |obj|
              file.write fixture_entry(table_name, obj) + "\n\n"
            end
          end
        end
      end
    end
  end
end
