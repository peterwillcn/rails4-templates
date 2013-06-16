#
# Application Template
#

repo_url = 'https://raw.github.com/mtfuji/rails4-templates/master'
gems = {}

@app_name = app_name

def get_and_gsub(source_path, local_path)
  get source_path, local_path
  gsub_file local_path, /%app_name%/, @app_name
end

#
# Gemfile
#

gem 'airbrake'
gem 'devise'
gem 'kaminari'
gem 'less-rails'
gem 'rails_admin', branch: 'rails-4'
gem 'rails_config'
gem 'twitter-bootstrap-rails', group: 'assets'
#gem 'xml-sitemap'

gem_group :development do
  gem 'capistrano_colors'
  gem 'capistrano-ext'
  gem 'rvm-capistrano'
  gem 'meta_request'
  #gem 'pry-doc'
  gem 'pry-rails'
  gem 'tapp'
  gem 'quiet_assets'
end

gem_group :test do
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  #gem 'faker'
  gem 'guard-cucumber'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'rspec-rails'
  gem 'simplecov'
end

gem_group :development, :test do
  gem 'debugger'
  gem 'rb-fsevent', require: false
  gem 'spring'
  gem 'sqlite3'
  gem 'thin'
  #gem 'timecop'
end

gem_group :production do
  gem 'mysql2'
end

comment_lines 'Gemfile', "gem 'sqlite3'"
comment_lines 'Gemfile', "gem 'turbolinks'"
uncomment_lines 'Gemfile', "gem 'therubyracer'"

#
# Files and Directories
#

# use Rspec instead of TestUnit
remove_dir 'test'

application <<-APPEND_APPLICATION
config.generators do |generate|
      generate.test_framework   :rspec, fixture: false, views: false
      generate.integration_tool :rspec, fixture: false, views: true
    end
APPEND_APPLICATION

# .gitignore
remove_file '.gitignore'
get "#{repo_url}/gitignore", '.gitignore'

remove_file 'public/index.html'
remove_file 'app/assets/images/rails.png'

# bundler
empty_directory '.bundle'
get "#{repo_url}/bundle.config", '.bundle/config'

# capistrano
get "#{repo_url}/Capfile", 'Capfile'

# views
empty_directory 'app/views/kaminari'
%w(first_page gap last_page next_page page paginator prev_page).each do |key|
  get "https://raw.github.com/gabetax/twitter-bootstrap-kaminari-views/master/app/views/kaminari/_#{key}.html.erb", "app/views/kaminari/_#{key}.html.erb"
end

# helpers
remove_file 'app/helpers/application_helper.rb'
get "#{repo_url}/app/helpers/application_helper.rb", 'app/helpers/application_helper.rb'

# config/deploy
empty_directory 'config/deploy'
get "#{repo_url}/config/deploy/production.rb", 'config/deploy/production.rb'

# config/locales/ja.yml
get 'https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/ja.yml', 'config/locales/ja.yml'
get 'https://gist.github.com/raw/3104030/d3cd6bf55bc905b89b6e08d9454a48c92b81bfdc/devise.ja.yml', 'config/locales/devise.ja.yml'
get 'https://gist.github.com/mshibuya/1662352/raw/a5ce6fb646d53ca44434a8b7ab238aeeb8791d27/rails_admin.ja.yml', 'config/rails_admin.ja.yml'

# config/database.yml
remove_file 'config/database.yml'
get "#{repo_url}/config/database.yml", 'config/database.yml'

# config/deploy.rb
get_and_gsub "#{repo_url}/config/deploy.rb", 'config/deploy.rb'

# config/application.rb
insert_into_file 'config/application.rb',
                 %(    config.time_zone = 'Tokyo'\n),
                 after: "# config.time_zone = 'Central Time (US & Canada)'\n"

insert_into_file 'config/application.rb',
                 %(    config.i18n.default_locale = :ja\n),
                 after: "# config.i18n.default_locale = :de\n"

# config/environments/development.rb
insert_into_file 'config/environments/development.rb',
                 %(    config.action_mailer.default_url_options = Settings.action_mailer.default_url_options.to_hash\n),
                 after: "# config.action_mailer.raise_delivery_errors = false\n"

# config/settings
empty_directory 'config/settings'
run 'touch config/settings.yml'
get "#{repo_url}/config/settings/development.yml", 'config/settings/development.yml'
get "#{repo_url}/config/settings/test.yml", 'config/settings/test.yml'
get_and_gsub "#{repo_url}/config/settings/production.yml", 'config/settings/production.yml'

# lib
get "#{repo_url}/lib/sitemap.rb", 'lib/sitemap.rb'

# lib/tasks
get "#{repo_url}/lib/tasks/extract_fixtures.rake", 'lib/tasks/extract_fixtures.rake'

# lib/templates
empty_directory 'lib/templates/erb/scaffold'
empty_directory 'lib/templates/rails/scaffold_controller'
get "#{repo_url}/lib/templates/erb/scaffold/_form.html.erb", 'lib/templates/erb/scaffold/_form.html.erb'
get "#{repo_url}/lib/templates/erb/scaffold/index.html.erb", 'lib/templates/erb/scaffold/index.html.erb'
get "#{repo_url}/lib/templates/erb/scaffold/edit.html.erb", 'lib/templates/erb/scaffold/edit.html.erb'
get "#{repo_url}/lib/templates/erb/scaffold/new.html.erb", 'lib/templates/erb/scaffold/new.html.erb'
get "#{repo_url}/lib/templates/erb/scaffold/show.html.erb", 'lib/templates/erb/scaffold/show.html.erb'
get "#{repo_url}/lib/templates/rails/scaffold_controller/controller.rb", 'lib/templates/rails/scaffold_controller/controller.rb'

# rspec
empty_directory 'spec/factories'
get "#{repo_url}/rspec", '.rspec'
get "#{repo_url}/spec/factories.rb", 'spec/factories.rb'

# static files
remove_file 'public/favicon.ico'
get 'http://api.rubyonrails.org/favicon.ico', 'public/favicon.ico'
get "#{repo_url}/travis.yml", '.travis.yml'

#
# Git
#
git :init
git add: '.'
git commit: '-am "Initial commit"'

if @deploy_via_remote && @remote_repo
  git remote: 'add origin git://github.com/mtfuji/#@app_name.git'
end
