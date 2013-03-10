require "capistrano/ext/multistage"
require "capistrano_colors"
require "bundler/capistrano"

require "rvm/capistrano"                       # Load RVM"s capistrano plugin.
set :rvm_ruby_string, "ruby-2.0.0"             # Or whatever env you want it to run in.
set :rvm_type, :system                         # Copy the exact line. I really mean :system here

set :application, "%app_name%"
set :scm, :git
set :repository,  "git://github.com/mtfuji/%app_name%.git"
#set :deploy_via, :remote_cache
set :copy_exclude, %w(.git .gitignore doc features log spec test tmp Capfile)
set :shared_children, shared_children + %w(public/uploads)

set :use_sudo, false

set :stages, %w(staging production)

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :customs do
  namespace :rake do
    desc "Run a task on a remote server."
    # run like: cap staging customs:rake:invoke task='db:version'
    task :invoke, :roles => :db do
      run("cd #{current_path}; BUNDLE_GEMFILE=#{current_path}/Gemfile bundle exec rake #{ENV['task']} RAILS_ENV=#{rails_env}")
    end
  end
end

def confirm
  puts "\n\e[0;36m#{stage}\e[0m\e[0;31m Do you really deploy? (yes/no) \e[0m\n"
  proceed = STDIN.gets rescue nil
  exit unless proceed.chomp! == "yes"
end
