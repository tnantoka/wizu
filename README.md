# Wizu 

[![Circle CI](https://circleci.com/gh/tnantoka/wizu.svg?style=svg)](https://circleci.com/gh/tnantoka/wizu)
[![Code Climate](https://codeclimate.com/github/tnantoka/wizu/badges/gpa.svg)](https://codeclimate.com/github/tnantoka/wizu)
[![Test Coverage](https://codeclimate.com/github/tnantoka/wizu/badges/coverage.svg)](https://codeclimate.com/github/tnantoka/wizu/coverage)

Just another personal Wiki with Markdown. Powered by Rails and Bootstrap 4.
http://wizu.tnantoka.com/

## Requirement

- Ruby 2.2
- Ruby on Rails 4.2
- GitHub API  
  (Authorization callback path: `/auth/github/callback`)

## Installation

```
# .env
GITHUB_CLIENT_ID="ID"
GITHUB_CLIENT_SECRET="SECRET"
```

## Development

### Capistrano

```
# .env
DEPLOY_HOST="HOST:PORT"
DEPLOY_USER="USER"

# Setup
$ bundle exec cap production deploy
$ bundle exec cap production db:create

# Deploy
$ bundle exec cap production deploy

# Drop
$ bundle exec cap production db:drop
```

## Author

[@tnantoka](https://twitter.com/tnantoka)

