Save Up iPhone App
==================

This is the final version of the iPhone app that interacts with a
REST service (a Rails app) to manage goals and their related credits.

Features
--------

This app is intended for educational purposes only, but it sports a few features you may want to consider in your application:

* Supports all CRUD operations of two resources (Goal and Credit)
* Nested resources
* Asynchronous network requests
* Authentication
* Error handling

Quickstart
----------

1. Fire up the Rails application in the <code>../rails_app</code> directory:

        $ rake db:migrate
        $ rake db:seed
        $ rails s
  
2. Point your trusty browser at the [running Rails app](http://localhost:3000), and create an account and a goal.

3. Open the iPhone project and run it!

        $ open SaveUp.xcodeproj

