#
# Application Template
#

repo_url = "https://raw.github.com/mtfuji/rails3-templates/master"
gems = {}

@app_name = app_name

def get_and_gsub(source_path, local_path)
  get source_path, local_path
  gsub_file local_path, /%app_name%/, @app_name
end

#
# Gemfile
#

# pagination
gem 'kaminari'

# pagination
gem 'devise'

# config
gem 'rails_config'

# twitter bootstrap
gem 'less-rails'
gem 'twitter-bootstrap-rails', group: 'assets'

# admin
gem 'rails_admin'

# sitemap.xml
gem 'xml-sitemap'

gem_group :deployment do
  gem 'capistrano_colors'
  gem 'capistrano-ext'
  gem 'rvm-capistrano'
end

gem_group :development do
  gem 'better_errors'
  #gem 'pry-doc'
  gem 'pry-rails'
  gem 'rainbow'
  gem 'tapp'
  gem 'quiet_assets'
end

gem_group :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'rspec-rails'
end

gem_group :development, :test do
  gem 'debugger'
  gem 'rb-fsevent', :require => false
  gem 'sqlite3'
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

# bundler
get "#{repo_url}/bundle.config", ".bundle/config"

# views
empty_directory "app/views/kaminari"
%w(first_page gap last_page next_page page paginator prev_page).each do |key|
  get "https://github.com/gabetax/twitter-bootstrap-kaminari-views/tree/master/app/views/kaminari/_#{key}.html.erb", "app/views/kaminari/_#{key}.html.erb"
end

# helpers
remove_file "app/helpers/application_helper.rb"
get "#{repo_url}/app/helpers/application_helper.rb", "app/helpers/application_helper.rb"

# config/deploy
empty_directory "config/deploy"
get "#{repo_url}/config/deploy/production.rb", "config/deploy/production.rb"

# config/initializers
get "#{repo_url}/config/initializers/quiet_assets.rb", "config/initializers/quiet_assets.rb"
get "#{repo_url}/config/initializers/rainbow.rb", "config/initializers/rainbow.rb"

# config/locales/ja.yml
get "https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/ja.yml", "config/locales/ja.yml"
get "https://gist.github.com/raw/3104030/d3cd6bf55bc905b89b6e08d9454a48c92b81bfdc/devise.ja.yml", "config/locales/devise.ja.yml"

# config/database.yml
remove_file "config/database.yml"
get "#{repo_url}/config/database.yml", "config/database.yml"

# config/deploy.rb
get_and_gsub "#{repo_url}/config/deploy.rb", "config/deploy.rb"

# config/application.rb
insert_into_file "config/application.rb",
                 %(    config.time_zone = 'Tokyo'\n),
                 after: "# config.time_zone = 'Central Time (US & Canada)'\n"

insert_into_file "config/application.rb",
                 %(    config.i18n.default_locale = :ja\n),
                 after: "# config.i18n.default_locale = :de\n"

# config/environments/development.rb
insert_into_file "config/environments/development.rb",
                 %(    config.action_mailer.default_url_options = Settings.action_mailer.default_url_options.to_hash\n),
                 after: "# config.action_mailer.raise_delivery_errors = false\n"

# config/settings
empty_directory "config/settings"
run "touch config/settings.yml"
get "#{repo_url}/config/settings/development.yml", "config/settings/development.yml"
get "#{repo_url}/config/settings/test.yml", "config/settings/test.yml"
get_and_gsub "#{repo_url}/config/settings/production.yml", "config/settings/production.yml"

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

# rspec
empty_directory "spec/factories"
get "#{repo_url}/rspec", ".rspec"
get "#{repo_url}/spec/factories.rb", "spec/factories.rb"

#
# Git
#
git :init
git :add => '.'
git :commit => '-am "Initial commit"'

if @deploy_via_remote && @remote_repo
  git :remote => "add origin git@bitbucket.org:workbrew/#@app_name.git"
end
