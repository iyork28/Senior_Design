# README

This is GT FInancial Records Services (GT FIRES). This name will probably change.

This service is aimed at:

* Managing bills for organizations like clubs and fraternal organizations (though certainly not limited to it)
* Keeping treasurer-types organized and accountable
* Being awesome (or something else... couldn't come up with any more bullets)

If you want to pull this code, follow this procedure after pulling:

	git pull # in case you hadn't pulled yet :)
	bundle # this does bundle install to get an update list of gems. If the Gemfile wasn't changed, this isn't necessary
	rake db:migrate # runs any DB migrations; again, not necessary if there aren't any
	rails server # runs the server, navigate to localhost:3000 on your browser

To run the tests:

    rake db:test:prepare # prepares the test database for the tests
    rake test # runs all tests

To enable credit cards:

    Add a stripe.rb file under config/initializers as described in the link below
    https://stripe.com/docs/checkout/guides/rails#configuration

    If you don't want to use ENV variables, then put the raw string in there
    The file is not being commited as it is in the .gitignore
    (ENV variables should be required eventually)

    You might need to sign up for stripe to get api credentials

	
Here's the link to the Heroku server: [*http://morning-island-4911.herokuapp.com*](http://morning-island-4911.herokuapp.com). Not sure how dynamic this will be, so if it stops working... Oops.

\- Ian
