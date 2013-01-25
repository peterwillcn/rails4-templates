## Usage

```bash
rails new APP_PATH -m https://raw.github.com/mtfuji/rails3-templates/master/main.rb
```

## After creating app

```bash
bundle install
./script/rails g bootstrap:install
./script/rails g devise:install
./script/rails g devise User
./script/rails g bootstrap:layout application (fixed|fluid)
```
