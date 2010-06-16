RailsConf 2010 Tutorial
=======================

This repo contains a workbook and source code for the 3-hour [Mobile App Development with iPhone/iPad and
Rails](http://en.oreilly.com/rails2010/public/schedule/detail/14136) tutorial I taught at RailsConf 2010.

The overall goal is to build a full-featured iPhone app ([screenshots](http://github.com/clarkware/iphone-rails-tutorial/raw/master/screenshots/iphone-app.png)) that talks to a Rails app ([try it!](http://saveup.heroku.com/about)) using RESTful resources.  Along the way we explore several libraries and delve into topics such as authentication, nested resources, and asynchronous communication.

Workbook
--------

To start working through the workbook, open the <tt>workbook/html/all.html</tt> file in your favorite browser.  Each section starts with an objective and includes steps to guide you to the solution.

Source Code
-----------

The <tt>code</tt> directory contains incremental versions of the iPhone app that correlate
roughly to each section of the workbook. Check the <tt>README</tt> in each directory for more
details.

The final iPhone and Rails apps are in the <tt>iphone_app</tt> and <tt>rails_app</tt>
directories, respectively.

Install Rails 3 (beta)
----------------------

You'll need the Rails 3 beta installed to run the sample Rails app:

    $ gem install rails --pre
        
Install the iPhone SDK
----------------------

You'll need the iPhone SDK to run the sample iPhone app:

1. Make sure you've upgraded your Intel-based Mac laptop to run Snow Leopard (version 10.6.3), the latest Mac OS X release.

2. You'll need to be an Apple Developer Connection (ADC) member in order to download the latest version of the iPhone SDK. If you're not already a member, you can [sign up for an ADC account](http://developer.apple.com). ADC membership is free.

3. Once you have an ADC account, [download iPhone SDK 3.2](http://developer.apple.com/iphone/) and install it. You may be tempted to download iPhone SDK 4 beta. Note however that the sample project was built with iPhone SDK 3.2 and the 4.0 version is under NDA at this time, so we won't be using it in this tutorial.

4. Xcode 3.2.2 is included in the full download of the iPhone SDK iPhone SDK 3.2. Verify that you're running Xcode version 3.2.2 by launching Xcode and using the <em>Xcode -> About Xcode</em> menu item. (You'll find Xcode under the <tt>/Developer/Applications</tt> directory.)

If you want to run your apps on your iPhone or iPod Touch device, you'll need to join Apple's iPhone Developer program. The program costs $99/year for individuals.

New To iPhone Programming?
--------------------------

The workbook assumes you have a basic working knowledge of Objective-C and a general
understanding of iPhone table view programming. Here are some recommended resources to help you
get started:

* [iPhone SDK Training](http://pragmaticstudio.com/iphone): A 3-day, hands-on iPhone programming course.

* [Coding in Objective-C 2.0](http://pragprog.com/screencasts/v-bdobjc/coding-in-objective-c-2-0): A three-part screencast series on Objective-C fundamentals by Bill Dudney

* [Becoming Productive in Xcode](http://pragprog.com/screencasts/v-mcxcode/becoming-productive-in-xcode): A two-part screencast series on how to be productive in Xcode by yours truly

* [iPhone SDK Development](http://pragprog.com/titles/amiphd/iphone-sdk-development): A comprehensive book on iPhone programming





