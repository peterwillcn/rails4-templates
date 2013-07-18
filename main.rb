#
# Application Template
#

repo_url = 'https://raw.github.com/stabenfeldt/rails4-templates/master'
gems = {}

@app_name = app_name

run "echo '2.0.0#{@app_name}' > .ruby-version"
run "rvm  --create 2.0.0@#{app_name}"


def get_and_gsub(source_path, local_path)
  get source_path, local_path
  gsub_file local_path, /%app_name%/, @app_name
end

#
# Gemfile
#

gem 'devise', github: 'plataformatec/devise'
gem 'haml-rails'
gem 'bootstrap-sass'
gem 'simple_form'
#gem 'rails_admin', branch: 'rails-4'
#gem 'xml-sitemap'

gem 'foreman'
gem 'unicorn'
gem 'resque'



gem_group :development do
  gem 'growl'
  gem 'foreman'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'quiet_assets'
  gem 'pry-rails'
end

gem_group :test do
  gem 'database_cleaner'
  gem 'capybara'
  gem 'turn'
  gem 'minitest-rails-capybara'
end

gem_group :development, :test do
  gem 'debugger'
  gem 'zeus'
  gem 'rspec-rails'
  gem 'rspec'
  #gem 'timecop'
end

gem_group :production do
end

#comment_lines 'Gemfile', "gem 'sqlite3'"
#comment_lines 'Gemfile', "gem 'turbolinks'"
#uncomment_lines 'Gemfile', "gem 'therubyracer'"

#
# Files and Directories
#

# use Rspec instead of TestUnit
remove_dir 'test'

application <<-APPEND_APPLICATION
config.generators do |g|
      g.template_engine     :slim
      g.integration_tool    :rspec
      g.test_framework      :rspec, :spec => true, :fixture => true
      g.fixture_replacement :fabrication
    end
    
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)

    Fabrication.configure do |config|
      fabricator_dir = "data/fabricators"
    end

    config.action_mailer.delivery_method = :smtp
        config.action_mailer.smtp_settings = {
          address:              'smtp.gmail.com',
          port:                 587,
          domain:               ENV['SMTP_DOMAIN'],
          user_name:            ENV['SMTP_USERNAME'],
          password:             ENV['SMTP_PASSWORD'],
          authentication:       'plain',
          enable_starttls_auto: true  }
        
      end
    end
APPEND_APPLICATION

# .gitignore
remove_file '.gitignore'
get "#{repo_url}/gitignore", '.gitignore'

remove_file 'public/index.html'
remove_file 'app/assets/images/rails.png'

# bundler
#get_and_gsub "#{repo_url}/bundle.config", '.bundle/config'

# capistrano
#get "#{repo_url}/Capfile", 'Capfile'

# views
remove_file 'app/views/layouts/application.html.erb'
get_and_gsub "#{repo_url}/app/views/layouts/application.html.haml", 'app/views/layouts/application.html.haml'
%w(first_page gap last_page next_page page paginator prev_page).each do |key|
  get "https://raw.github.com/deeproot/twitter-bootstrap-kaminari-views-haml/master/app/views/kaminari/_#{key}.html.haml", "app/views/kaminari/_#{key}.html.haml"
end

# helpers
remove_file 'app/helpers/application_helper.rb'
get "#{repo_url}/app/helpers/application_helper.rb", 'app/helpers/application_helper.rb'

# config/deploy
get "#{repo_url}/config/deploy/production.rb", 'config/deploy/production.rb'

# config/locales/ja.yml
#get 'https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/ja.yml', 'config/locales/ja.yml'
#get 'https://gist.github.com/raw/3104030/d3cd6bf55bc905b89b6e08d9454a48c92b81bfdc/devise.ja.yml', 'config/locales/devise.ja.yml'
#get 'https://gist.github.com/mshibuya/1662352/raw/a5ce6fb646d53ca44434a8b7ab238aeeb8791d27/rails_admin.ja.yml', 'config/rails_admin.ja.yml'
#get "#{repo_url}/config/locales/helpers.ja.yml", 'config/locales/helpers.ja.yml'

# config/database.yml
gsub_file 'config/database.yml', /^test:$/, 'test: &test'
#insert_into_file 'config/database.yml',
#                 %(cucumber:\n  <<: *test\n\n),
#                 before: 'production:'
#run 'cp config/database.yml config/database.example.yml'
#get "#{repo_url}/config/database.yml", 'config/database.yml'

# config/deploy.rb
get_and_gsub "#{repo_url}/config/deploy.rb", 'config/deploy.rb'

# config/application.rb
insert_into_file 'config/application.rb',
                 %(    config.time_zone = 'Tokyo'\n),
                 after: "# config.time_zone = 'Central Time (US & Canada)'\n"

insert_into_file 'config/application.rb',
                 %(    config.i18n.default_locale = :no\n),
                 after: "# config.i18n.default_locale = :de\n"

# config/environments/development.rb
insert_into_file 'config/environments/development.rb',
                 %(    config.action_mailer.delivery_method = :file\n    config.action_mailer.default_url_options = Settings.action_mailer.default_url_options.to_hash\n),
                 after: "# config.action_mailer.raise_delivery_errors = false\n"

# config/settings
run 'touch config/settings.yml'
get "#{repo_url}/config/settings/development.yml", 'config/settings/development.yml'
get "#{repo_url}/config/settings/test.yml", 'config/settings/test.yml'
get_and_gsub "#{repo_url}/config/settings/production.yml", 'config/settings/production.yml'

# config/initializers
# Airbrake
#get "#{repo_url}/config/initializers/errbit.rb", 'config/initializers/errbit.rb'

# lib
#get "#{repo_url}/lib/sitemap.rb", 'lib/sitemap.rb'

# lib/tasks
#get "#{repo_url}/lib/tasks/extract_fixtures.rake", 'lib/tasks/extract_fixtures.rake'

# lib/templates
#get "#{repo_url}/lib/templates/haml/scaffold/_form.html.haml", 'lib/templates/haml/scaffold/_form.html.haml'
#get "#{repo_url}/lib/templates/haml/scaffold/index.html.haml", 'lib/templates/haml/scaffold/index.html.haml'
#get "#{repo_url}/lib/templates/haml/scaffold/edit.html.haml", 'lib/templates/haml/scaffold/edit.html.haml'
#get "#{repo_url}/lib/templates/haml/scaffold/new.html.haml", 'lib/templates/haml/scaffold/new.html.haml'
#get "#{repo_url}/lib/templates/haml/scaffold/show.html.haml", 'lib/templates/haml/scaffold/show.html.haml'
#get "#{repo_url}/lib/templates/rails/scaffold_controller/controller.rb", 'lib/templates/rails/scaffold_controller/controller.rb'

# rspec
get "#{repo_url}/rspec", '.rspec'
#get "#{repo_url}/spec/factories.rb", 'spec/factories.rb'
get "#{repo_url}/spec/spec_helper.rb", 'spec/spec_helper.rb'
get "#{repo_url}/spec/support/controller_macros.rb", 'spec/support/controller_macros.rb'

# static files
remove_file 'public/favicon.ico'
get 'http://api.rubyonrails.org/favicon.ico', 'app/assets/images/favicon.ico'
get "#{repo_url}/travis.yml", '.travis.yml'
get 'http://newrelic.com/assets/pages/application_monitoring/logos/lang_ruby.png', 'app/assets/images/apple-touch-icon-144x144-precomposed.png'
get 'https://fbexternal-a.akamaihd.net/safe_image.php?d=AQDXiqes17_vjH3T&w=155&h=114&url=http%3A%2F%2Fcdn.tutsplus.com%2Fnet.tutsplus.com%2Fauthors%2Fjeffreyway%2Frails-history-preview-image.png', 'app/assets/images/apple-touch-icon-114x114-precomposed.png'
get 'http://4.bp.blogspot.com/-S5WVH9zVULA/UMHpxhJuZkI/AAAAAAAAAa4/w6LeyOLDfio/s72-c/150px-Ruby_on_Rails.svg.png', 'app/assets/images/apple-touch-icon-72x72-precomposed.png'
get 'http://www.usahostingservices.com/pics/1-rubyonrails.PNG', 'app/assets/images/apple-touch-icon-precomposed.png'
gsub_file 'app/assets/javascripts/application.js', /turbolinks/, 'bootstrap'
append_to_file 'app/assets/stylesheets/application.css', '@import "bootstrap";'
run 'mv app/assets/stylesheets/application.css app/assets/stylesheets/application.css.scss'

# remove .keep
remove_file 'app/assets/images/.keep'
remove_file 'lib/tasks/.keep'

#
# Git
#
git :init
git add: '.'
git commit: '-am "Initial commit"'
