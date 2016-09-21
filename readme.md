## setup repo

    cd ~/Sites
    git clone git@github.com:jonikanerva/destiny.git

    cd destiny
    git remote add heroku git@heroku.com:destiny-weapons.git

## setup db

    brew install postgresql memcached
    createdb destiny_dev
    createuser -P -s -e lord_saladin

## setup env

    SECRET_KEY_BASE=key_base
    DESTINY_DEVELOPMENT_HOSTNAME=localhost
    DESTINY_DEVELOPMENT_DATABASE=destiny_dev
    DESTINY_DEVELOPMENT_USERNAME=lord_saladin
    DESTINY_DEVELOPMENT_PASSWORD=password
    BUNGIE_API_KEY=api_key

## setup app

    bin/setup

## deploy

    git push heroku master

## update databases

    rails runner "FetchManifestJob.perform_now"
    rails runner "ProcessManifestJob.perform_now('/tmp/new.db')"
    rails runner "UpdateWeaponsJob.perform_now"
    rails runner "DeleteItemsJob.perform_now"

## delete heroku database

    heroku pg:reset DATABASE_URL --confirm destiny-weapons

## upload dev database to heroku

    heroku pg:push destiny_dev DATABASE_URL
