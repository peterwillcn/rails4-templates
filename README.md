## Usage

```bash
rails new APP_PATH -m https://raw.github.com/mtfuji/rails4-templates/master/main.rb
```

## After creating app

```bash
bundle install
./bin/rails g bootstrap:install
./bin/rails g devise:install
./bin/rails g devise User
./bin/rails g bootstrap:layout application (fixed|fluid)
```
