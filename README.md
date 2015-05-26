# RDStationv4 by RickWolff

Hi! =)

rdstationv4 is a web app that demonstrates a ruby application accessing SalesForce REST API methods to list, create, update and delete Leads.

That's my first ruby app... So don't expect too much. But I hope you can find the code useful either for what to copy as for what not to!  ¬¬'

If you want to use it on your SalesForce environment, you'll have to Enable API REST methods on your Organization. Or you can use SalesForce with a Developer Edition. It comes with API REST methods enabled.

## Source

Source is available at [github](https://github.com/ricfwolff/rdstationv4)

## Online Sample

To run the online sample, simply go to [heroku-sample-app](https://rdstationv4.herokuapp.com/) and enjoy! :)
The user interface should be easy to understand and to use. The database is shared and it shows some Leads registered on it. You can Create new Leads, Edit existing ones and Delete them.
If you connect to your SalesForce organization (using Developer Edition), you'll be able to send the leads created on the app to SalesForce. You can also Updated the app's leads with newest information filled on SalesForce or vice-versa.
The Delete from SalesForce feature is also available from Lead Detail's screen and it removes the Lead from SalesForce.

## Attention - SalesForce

SalesForce options are only available after connecting to an organization on SalesForce.

## System requirements

Ruby version used on this app was `ruby 2.1.5p273 (2014-11-13 revision 48405) [i386-mingw32]`

## Tests

Some basic tests are configured. If you download the source to your computer, you can run the tests by doing:

```
bundle install --without production
rake db:migrate RAILS_ENV=test
rake test
```

## Database creation

The database for production is different from the one on your machine. Production uses PostgreSQL. Test and Development environments use SqLite. You must create the database using:

```
bundle install --without production
rake db:migrate
```

## Questions

If you have questions on how to understand any part of the code, feel free to contact me here and I'll be happy to answer. I know the code is far from beautiful and full of errors, but I plan to use it as my Ruby learner.

