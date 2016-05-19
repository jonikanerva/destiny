## deploy

    git push heroku master

## update databases

fetch newest database and

    rails runner "FetchManifestJob.perform_now"
    rails runner "ProcessManifestJob.perform_now('/tmp/new.db')"
    rails runner "UpdateWeaponsJob.perform_now"

## upload database to heroku

delete heroku database

    heroku pg:reset DATABASE_URL --confirm destiny-weapons

upload dev database to heroku

    heroku pg:push destiny_dev DATABASE_URL

delete unneccessary row (to fit hobby plan)

    heroku run rails runner "DeleteItemsJob.perform_now"
