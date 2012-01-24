#= require "lib/jquery-1.7.1.js"
#= require "lib/jq.mobi.js"
#= require "lib/jq.carousel.js"
#= require "lib/underscore.js"
#= require "lib/backbone.js"
#= require_self
#= require "modules/homeview"
#= require "modules/slideshow"

root = exports ? this


class Application
  modules: {}
  constructor: ->
    @log "start!"
  launch: ->
    @log "launch"
    @launched = true
    @mainLaunch()
  mainLaunch: ->
    @log "mainlaunch"
    device = true
    if (!device || !@launched) then return
    
    @bind("application:launch", -> 
      @log('launched')
    ,@) 
    @trigger("application:launch")
    setTimeout(@homePage, 0) #this setTimeout runs the function when the dom is ready for it.
    @
  homePage: =>
    if _.isEmpty(@modules['homeView'])
      @log('modules.homeview is empty')
      @trigger("application:start")
    else
      @log(@module('homeView'))
      @log(@module('slideShow'))
      @trigger("route:home")
  log: (msg) ->
    #TODO middlman config boolean flag to decide how/if to log
    if true
      console.log(msg)
    return msg
  module: (name, mod = {}) =>
    if !@modules?
      @modules = {}
    if !@modules[name]?
      @modules[name] = mod  
    return @modules[name]
  showPage: (id) ->
    $('#pages div.page').hide()
    $("#pages div##{id}").show()


root.application = _.extend(new Application(), Backbone.Events)
root.application.bind("application:start", -> 
  @log "application:start"
  @homePage
,root.application)


  
