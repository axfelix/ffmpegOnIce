# Running for development

```
bundle install
rake db:create
rake db:migrate
rails webpacker:install
bundle exec rake assets:precompile
```

`rails s`