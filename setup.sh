#!/bin/sh

# exit if it fails anywhere
set -e

# copy any configs
if ![ -f .env ]; then
  cp .sample.env .env
fi

# ruby dependencies
gem install bundler --conservative
bundle check || bundle install

# setup db
bundle exec rails db:drop
bundle exec rails db:create
bundle exec rails db:migrate

# seed with test db when not a CI Machine
if [ -z "$CI" ]; then
  # add seed data
  bundle exec rails db:seed

  # # add heroku remotes
  # git remote add staging https://git.heroku.com/app_stagin.git || true
  # git remote add production https://git.heroku.com/app_production.git ||true

  # # join app to heroku
  # heroku join --app this_staging_app || true
  # heroku join --app this_production_app || true
fi
