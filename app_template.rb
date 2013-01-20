#
# Application Template
#

repo_url = "https://raw.github.com/mtfuji/rails3_template/master"
gems = {}

@app_name = app_name

def get_and_gsub(source_path, local_path)
  get source_path, local_path
  gsub_file local_path, /%app_name%/, @app_name
  gsub_file local_path, /%app_name_classify%/, @app_name.classify
end

#
# Gemfile
#

# pagination
gem 'kaminari'

# config
gem 'rails_config'

# twitter bootstrap
gem 'less-rails'
gem 'twitter-bootstrap-rails', group: 'assets'

# sitemap.xml
gem 'xml-sitemap'

gem_group :deployment do
  gem 'capistrano_colors'
  gem 'capistrano-ext'
  gem 'rvm-capistrano'
end

gem_group :development do
  gem 'pry-doc'
  gem 'pry-rails'
  gem 'rainbow'
  gem 'tapp'
end

gem_group :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'sqlite3'
end

gem_group :development, :test do
  gem 'debugger'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'rb-fsevent', :require => false
  gem 'thin'
end

gem_group :production do
  gem 'mysql2'
end

comment_lines 'Gemfile', "gem 'sqlite3'"
uncomment_lines 'Gemfile', "gem 'therubyracer'"

#
# Files and Directories
#

# use Rspec instead of TestUnit
remove_dir "test"

application <<-APPEND_APPLICATION
config.generators do |generate|
      generate.test_framework   :rspec, :fixture => true, :views => false
      generate.integration_tool :rspec, :fixture => true, :views => true
    end
APPEND_APPLICATION

# .gitignore
remove_file ".gitignore"
get "#{repo_url}/gitignore", ".gitignore"

remove_file "public/index.html"
remove_file "app/assets//images/rails.png"

# views
empty_directory "app/views/kaminari"
%w(first_page gap last_page next_page page paginator prev_page).each do |key|
  get "https://github.com/gabetax/twitter-bootstrap-kaminari-views/tree/master/app/views/kaminari/_#{key}.html.erb", "app/views/kaminari/_#{key}.html.erb"
end

# helpers
get "#{repo_url}/app/helpers/application_helper.rb", "app/helpers/application_helper.rb"

# config/deploy
empty_directory "config/deploy"
get "#{repo_url}/config/deploy/production.rb", "config/deploy/production.rb"

# config/initializers
get "#{repo_url}/config/initializers/config.rb", "config/initializers/config.rb"
get "#{repo_url}/config/initializers/quiet_assets.rb", "config/initializers/quiet_assets.rb"
get "#{repo_url}/config/initializers/rainbow.rb", "config/initializers/rainbow.rb"

# config/locales/ja.yml
get "https://github.com/svenfuchs/rails-i18n/blob/master/rails/locale/ja.yml", "config/locales/ja.yml"
get "https://gist.github.com/raw/3104030/d3cd6bf55bc905b89b6e08d9454a48c92b81bfdc/devise.ja.yml", "config/locales/devise.ja.yml"

# config/database.yml
remove_file "config/database.yml"
get_and_gsub "#{repo_url}/config/database.example.yml", "config/database.example.yml"
get_and_gsub "#{repo_url}/config/database.example.yml", "config/database.yml"

# config/deploy.rb
get_and_gsub "#{repo_url}/config/deploy.rb", "config/deploy.rb"

# config/application.rb
insert_into_file "config/application.rb",
                 %(    config.time_zone = 'Tokyo'\n),
                 after: "# config.time_zone = 'Central Time (US & Canada)'\n"

insert_into_file "config/application.rb",
                 %(    config.i18n.default_locale = :ja\n),
                 after: "# config.i18n.default_locale = :de\n"

# lib
get "#{repo_url}/lib/sitemap.rb", "lib/sitemap.rb"

# lib/tasks
get "#{repo_url}/lib/tasks/extract_fixtures.rake", "lib/tasks/extract_fixtures.rake"

# lib/templates
empty_directory "lib/templates/erb/scaffold"
empty_directory "lib/templates/rails/scaffold_controller"
get "#{repo_url}/lib/templates/erb/scaffold/_form.html.erb", "lib/templates/erb/scaffold/_form.html.erb"
get "#{repo_url}/lib/templates/erb/scaffold/index.html.erb", "lib/templates/erb/scaffold/index.html.erb"
get "#{repo_url}/lib/templates/erb/scaffold/edit.html.erb", "lib/templates/erb/scaffold/edit.html.erb"
get "#{repo_url}/lib/templates/erb/scaffold/new.html.erb", "lib/templates/erb/scaffold/new.html.erb"
get "#{repo_url}/lib/templates/erb/scaffold/show.html.erb", "lib/templates/erb/scaffold/show.html.erb"
get "#{repo_url}/lib/templates/rails/scaffold_controller/controller.rb", "lib/templates/rails/scaffold_controller/controller.rb"

#
# Generators
run "bundle install --path vendor/bundle"
run "bundle exec rake bootstrap:install"
run "bundle exec rake rails generate devise:install"
run "bundle exec ./script/rails g devise MODEL"
run "bundle exec rake rspec:install"
run "bundle exec rake rails_config:install"
run "echo 'bundle exec rake bootstrap:layout application (fixed|fluid)'"
