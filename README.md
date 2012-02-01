INTRODUCTION

this is my attempt at a start towards an app building framework that can take the hurt out of building a bunch of similar html5, typically mobile, apps. 

using thor and middleman for the heavy lifting. coffee-script for the app code.

...
...
2.
I've been building large web applications for the past decade and developing for mobile devices has always been very attractive, but until recently that meant either developing java applications, or a web0.2-ish WAP interface.

3.
HTML5 and webkit support on new devices has unlocked this space for using web standard technologies.

4.
There's still one problem : javascript - it is very flexible and powerful, but oh so ugly and verbose with loads of boilerplate.

AltJS - Node.JS spawned a host of languages that transcompiles to javascript. Most notably CoffeeScript.

->

CoffeeScript has unleashed the power of javascript for the ADD stricken programmer that is me and finally everything was in place for me to start building HTML5 applications.

Over the years I have wanted to build a number of applications for mobile devices. They shared a lot of typical functionality, but each had its own identity and target market.

DRY - I want to create multiple very similar static html applications, and i want to reuse as much code as possible and have few maintenance issues.

example apps that are the same but slightly different? restuarant menus. museum exhibition guides. 


I'm lazy and want access to the helper methods I've become used to while building in rails & sinatra apps.
I want a framework that helps me build static sites.


Middleman is - 
 a static site generator based on Sinatra.
 It supports many templating languages 
 (Haml, Sass, Compass, Slim, CoffeeScript and more).
 does minification, compression, cache busting

 So basically, Middleman takes your sinatra app, and optimises and builds out all the endpoints into static pages.
 You sculpt the app in the source directory. - this is your development environment.
 then tell middleman to build the app. That produces a build directory, that is ready for deployment to S3 or for packaging to the mobile app stores.

 So if you want to build static sites with as little pain as possible, then Middleman is ready for use and highly recommended.


I want a large amount of code reuse over my apps, as they are in fact the very same app, just segmented based on branding, location, data or specific market.

So, one way would be to have separate git branches for each app, then just change the relevant pieces on each branch when i want to build and package an update to that app. - messy.

I rather want 1 codebase, that spits out the different apps on request.

So I've added a third layer to Middleman.

This layer is for app configuration, changing layouts, styles, coffeescript modules, and app specific data.
So I add a /raw directory to the mix. This holds all the code possibilities. the Source directory is then recreated for each app based on app specific configuration. For this I call on the power of Thor. 

Thor is a simple and efficient tool for building command line utilities.
- why not rake: 
  rake and thor is very similar, although rake is very project specific while thor is more general. As I want to move and create files and directories, as well as run various commands, and do it in a simple structured way. I could use either.
  I like Thor.
  Middleman already depends on Thor so the gem is already in the bundle.
  Thor::Group is cool. 
  It is a great tool to create generators, since you can define several step methods which are invoked in the order they are defined. generators in Rails3.+ is Thor:Groups 



So - to understand what this means, let's look at an example:

@

CODE WALKTHROUGH


WRAP UP
  We've seen how I use Thor to manage building various Middleman apps. I use configuration to tell Thor what should be put in place in order for Middleman to build the proper app.
  My application CoffeeScript is normalized into modules with as little assumptions made as needed.
  Modules interact by means of firing and binding to events. In this way I hope to make staying up to date on module changes straight forward.

Near future
  Apart from building more modules, I will also build yet another Thor layer that will be responsible for packaging and submitting the resulting apps to the various mobile markets or stores.
  
I don't know how this building tool will handle my apps when they start to diverge fundamentally, I expect that I will eventually have to maintain a number of seperate middleman apps. But as a quick start for managing a number of similar apps, I find this toolset pretty useful.

I hope you have better solutions to the problem for me, and that you will share them with me tonight.

questions.any?



