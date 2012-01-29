INTRODUCTION

this is my attempt at a start towards an app building framework that can take the hurt out of building a bunch of similar html5, typically mobile, apps. 

using thor and middleman for the heavy lifting. coffee-script for the app code.

...
I want to create multiple very similar static html applications.

I want access to my helpers i've become used to using rails & sinatra.
I need a Middleman.

Middleman is - 
 a static site generator based on Sinatra.
 Dozens of templating languages 
 (Haml, Sass, Compass, Slim, CoffeeScript, and more).
 does minification, compression, cache busting

 So basically, Middleman takes your sinatra app, and optimises and builds out all the endpoints into static pages.
 You sculpt the app in source directory. - this is your development environment.
 then tell middleman to build the app. That produces a build directory, that is ready for deployment to S3 or for packaging to the mobile app stores.

 So if you want to build static sites with as little pain as possible, then Middleman is ready for use and highly recommended.


I want a large amount of code reuse over my apps, as they are in fact the very same app, just segmented based on location/market forces.

So, one way would be to have separate git branches for each app, then just change the relevant pieces on each branch when i want to build and package an update to that app. - messy.

I rather want 1 codebase, that spits out the different apps on request.

So I'm adding a third layer to Middleman.

This layer is for app configuration, changing layouts, styles, coffeescript modules, and app specific data.
So I add a /raw directory to the mix. This holds all the code possibilities. the Source directory is then recreated for each app based on app specific configuration. For this I call on the power of Thor. 

Thor is a simple and efficient tool for building command line utilities.
- why not rake: 
  rake and thor is very similar, although rake is very project specific while thor is more general. As I want to move and create files and directories, as well as run various commands, and do it in a simple structured way. I could use either.
  I like Thor.
  Middleman already depends on Thor so the gem is already in the bundle.
  Thor::Group is cool. 
  It a great tool to create generators, since you can define several steps which are invoked in the order they are defined. generators in Rails3.+ is Thor:Group's 



So - let me show you an example.

@

CODE WALKTHROUGH

WRAP UP


