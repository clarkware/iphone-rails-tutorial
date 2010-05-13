RailsConf 2010 Tutorial Bootstrap
=================================

Planning on attending my [Mobile App Development with iPhone/iPad and
Rails](http://en.oreilly.com/rails2010/public/schedule/detail/14136) tutorial at RailsConf this year?  Great - I look forward to meeting you!

Unfortunately, our time together is fairly limited.  And, just like any well-run software project, we'll need to be mindful of scope.  Our overall goal is to build an iPhone app ([screenshots](http://github.com/clarkware/iphone-rails-tutorial/raw/master/screenshots/iphone-app.png)) that talks to a Rails app ([try it!](http://saveup.heroku.com/about)) by way of RESTful resources.  Along the way we'll explore several libraries and delve into topics such as authentication, nested resources, and asynchronous communication.  To do that in three hours time, I'll assume that you have a basic working knowledge of Objective-C and a general understanding of iPhone table view programming.  

How do you know if you're ready? I'm glad you asked. In the <tt>projects/1-bootstrap</tt> directory of
this project you'll find a basic iPhone app that shows a read-only table of data. (No, you
couldn't even charge 99 cents for this app.) You're ready to attend if...

* You're able to run this app
* You're comfortable with the Objective-C syntax used in this app
* You understand the table view programming used in this app

New to iPhone programming and still want to attend?  You're welcome just the same! But you'll get more out of the tutorial if you spend some time preparing beforehand.  Below you'll find steps for installing the iPhone SDK and suggested resources to help you prepare for the tutorial.        

In coming weeks, I'll add the source for incremental versions of the iPhone app and the final Rails app, as well as the workbook we'll follow during the tutorial. Stay tuned!  

See you there...

Mike Clark


Installing the iPhone SDK
-------------------------

1. Make sure you've upgraded your Intel-based Mac laptop to run Snow Leopard (version 10.6.3), the latest Mac OS X release.

2. You'll need to be an Apple Developer Connection (ADC) member in order to download the latest version of the iPhone SDK. If you're not already a member, you can [sign up for an ADC account](http://developer.apple.com). ADC membership is free.

3. Once you have an ADC account, [download iPhone SDK 3.2](http://developer.apple.com/iphone/) and install it. You may be tempted to download iPhone SDK 4 beta. Note however that the sample project was built with iPhone SDK 3.2 and the 4.0 version is under NDA at this time, so we won't be using it in this tutorial.

4. Xcode 3.2.2 is included in the full download of the iPhone SDK iPhone SDK 3.2. Verify that you're running Xcode version 3.2.2 by launching Xcode and using the <em>Xcode -> About Xcode</em> menu item. (You'll find Xcode under the <tt>/Developer/Applications</tt> directory.)

We'll be running the iPhone app on the iPhone Simulator during the tutorial, so becoming a registered iPhone developer is not required. However, if you want to run your apps on your iPhone or iPod Touch device, you'll need to join Apple's iPhone Developer program. The program costs $99/year for individuals.

Learning Objective-C and iPhone Programming
-------------------------------------------

Everyone learns in a slightly different way.  I like to read a little or watch a screencast, tinker around with some code, and then dive right into a project.  I've given you some iPhone code to safely tinker around with.  And you probably already have an idea for a project.  In terms of reading books, I can only recommend what I've read and it's no surprise that I'm a tad biased.  Of course, there are many other fine books and screencasts.  Choose the resources that work best for you.

* [Coding in Objective-C 2.0](http://pragprog.com/screencasts/v-bdobjc/coding-in-objective-c-2-0): a three-part screencast series by Bill Dudney

* [iPhone SDK Development book](http://pragprog.com/titles/amiphd/iphone-sdk-development): read through chapter 5 on table views 

* [Becoming Productive in Xcode](http://pragprog.com/screencasts/v-mcxcode/becoming-productive-in-xcode): a two-part screencast series by yours truly

* [Introduction to The Objective-C Programming Language](http://developer.apple.com/mac/library/DOCUMENTATION/Cocoa/Conceptual/ObjectiveC/Introduction/introObjectiveC.html): the official Apple guide

* [Table View Programming Guide for iPhone OS](http://developer.apple.com/iphone/library/documentation/UserExperience/Conceptual/TableView_iPhone/AboutTableViewsiPhone/AboutTableViewsiPhone.html): the definitive Apple guide


