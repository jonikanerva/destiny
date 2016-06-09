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
