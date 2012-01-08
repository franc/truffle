root = exports ? this

routes = {
  home: "route:home"  
}

class HomeView extends Backbone.View
  events: {}
  links: []
  constructor: ->
    super
    root.application.log "HomeView initialize"
    # link_opt should be an object with key being the link text, and value being an event to trigger on application object
    # {home: "route:home"}
    i = 0
    #console.log @options.el
    @el = @options.el
    @links = []
    for own link, event of @options.link_opts
      id = "link_#{i}"
      @links.push "<li><a id='#{id}' class='homeView_link'>#{link}</a></li>"
      #add new event function to the prototype  
      HomeView.prototype["event_func_#{i}"] = -> 
        root.application.trigger(event)
      #sets click event for link to new event function that will trigger event on application
      @events["click ##{id}"] = "event_func_#{i}"
      i += 1
    return @

  template: _.template("""
<h3> HOME </h3> 
<ul id='links'>
<% _.each(this.links, function(link) { %><%= link %><% }); %>
</ul>    
""")
#<% _.each(@links, function(link) { %><%= link %><% }); %>
  render: =>
    @delegateEvents()#[@events])
    root.application.log('homeView render')
    #root.application.log(@el)
    #root.application.log(@links)
    #root.application.log @template(@links)
    $(@el).html(@template(@links))
    #root.application.log @el
    @

#bind launch action
root.application.bind("application:launch", ->
  @log('homeview : application:launch')
  #initialize module instance
  @module("homeView", new HomeView({link_opts: routes, el: '#homePage'}))
,root.application)

#bind custom routes
root.application.bind "route:home", ->
  @log('route:home')
  @module("homeView").render()
,root.application
