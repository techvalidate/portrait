# Potrait

Portrait is a web service which converts a website into a image. The actual hard work is handled by Google's {Puppeteer}[https://github.com/GoogleChrome/puppeteer].  Portrait is primarily designed to be used as a service, but does have a minimal admin interface.

## Timeline
For this project I planned according to the timeline shown below:  
**Understanding the requirements**: 2 hours  
**Writing Specs and Unit Testing**: 8 hours  
**Write code for Passing the test**: 10 hours  
**Design and fixing bugs**: 4 hours  
**Overall**: ~24 hours  
I have the best of my ability to integrate the aunthentication to the system.

##Gems Used
For the project I have addes numerous gems which are listed below:

**Testing Purpose**  
factory_bot_rails  
shoulda-matchers  
faker  
database_cleaner

**Development Purpose**  
bcrypt  
jquery-rails  
bootstrap

##Reflection on Choice

I chose this feature because as a developer I believe that the first and foremost requirement
for any system/application is to have an authentication system and segregate the user
ability to access the application. Hence, before implementing other features I wanted to
work on authentication system.

###RoadBlocks
Since the Mail Protocol was not set up, it was a hindrance for me to send email.
So for the features like Forgor Password, the email template renders itself 
in the server and the reset link has to copied from the server itself.
If other servers with SMTP was implemented, that would not be a problem.

###Estimation Accuracy
Yes, the estimated timeline was not accuracte. I lagged behind while developing the application.
Overall it was an enjoyable experience.
