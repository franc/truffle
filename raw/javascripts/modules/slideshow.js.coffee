root = exports ? this

class root.application.Slide extends Backbone.Model
  el: "#slide-#{@id}"
  _states: [ "distant-slide", "far-past", "past", "current", "future", "far-future", "distant-slide" ]
  _visited: false
  _currentState: ""
  show: ->
    $(@el).removeClass @_states.join(" ")
    $(@el).addClass 'current'
    @_currentState = 'current'
    $(@el).show()
    @
  setState: (state) ->
    state = @_states[state]  unless typeof state is "string"
    if state is "current" and not @_visited
      @_visited = true
     @show()
           
class root.application.Slides extends Backbone.Collection
  model: root.application.Slide



class SlideShow extends Backbone.View
  slides: '#slides'
  current: 0
    
  slideTemplate: _.template("""
  <div id="slide-<%= id %>" class="slide" >
    <section><header><%= caption %></header></section>
    <%= content %>
    <span class="counter"><%= id + 1 %></span>
  </div>
  """)

  render: ->
    root.application.log @collection
    @collection.each((slide) =>
      $(@slides).append(@slideTemplate(slide.toJSON()))
    )
    
    @start()
  
  _update: ->
    root.application.log("slide #{@current + 1}")
    return  if @current is null
    $("#presentation-counter").innerText = @current
    $(".slide").hide()
    
    root.application.log @collection.at(@current).attributes.caption.replace(/(<([^>]+)>)/ig,"")
    root.application.log @collection.at(@current).attributes.content.replace(/(<([^>]+)>)/ig,"")
    root.application.log '<>'
    root.application.log @collection.at(@current).attributes.notes
    root.application.log '-----------'
    $("#slide-#{@current}").show()
    
    x = @current# - 1
    while x < @current + 7
      @collection.at(x - 4).setState(Math.max(0, x - @current))  if @collection.at(x - 4)
      x++
    @
  next: ->
    @current = Math.min(@current + 1, @collection.length - 1)
    @_update()

  prev: ->
    @current = Math.max(@current - 1, 0)
    @_update()

  go: (num) ->
    @current = num
    @_update()
  handleKeys: (e) ->
    return  if /^(input|textarea)$/i.test(e.target.nodeName) or e.target.isContentEditable
    switch e.keyCode
      when 37
        @prev()
      when 39, 32
        @next()
  start: ->
    @go(0)

#-------------------

#bind launch action
root.application.bind("application:launch", ->
  @log('slideShow2 : application:launch')
  #initialize module instance
  root.application.module("slideShow", new SlideShow({
    el: '#slideShow'
    collection: new root.application.Slides(root.slides_data)
  }))
  root.addEventListener "keydown", ((e) ->
    root.application.module("slideShow").handleKeys(e)
  ), false
,root.application)

#bind custom routes
root.application.bind "route:slides", ->
  root.application.log('route:slides')
  root.application.module("slideShow").render()
  root.application.showPage('slideShow')
,root.application
