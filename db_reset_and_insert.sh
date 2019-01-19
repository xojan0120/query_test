cmd="eval(File.read 'insert.rb')"

rails db:migrate:reset
rails r "$cmd"

rails db:migrate:reset RAILS_ENV=test
rails r "$cmd" -e test
