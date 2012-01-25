root = exports ? this


class root.application.Slide extends Backbone.Model
  el: $("#slide-#{@id}")
  _states: [ "distant-slide", "far-past", "past", "current", "future", "far-future", "distant-slide" ]
  _visited: false
  _currentState: ""
  show: ->
    @el.show()
  setState: (state) ->
    root.application.log "setState #{state} : id #{@id}"
    state = @_states[state]  unless typeof state is "string"
    if state is "current" and not @_visited
        @_visited = true
        @el.show()
        #@_makeBuildList()
      @el.removeClass @_states.join(" ")
      @el.addClass state
      @_currentState = state
      #_t = this
      #setTimeout (->
      #  _t._runAutos()
      #), 400

class root.application.Slides extends Backbone.Collection
  model: root.application.Slide



class SlideShow extends Backbone.View
  slides: '#slides'
  controls: '#slideShow .controls'
  current: 0
    
  slideTemplate: _.template("""
  <div id="slide-<%= id %>" class="slide" >
    <section><header><%= caption %></header></section>
    <%= content %>
    <span class="counter"><%= id + 1 %></span>
  </div>
  """)

  controlTemplate: _.template("""<div id="carousel_dots" style="text-align: center; margin-left: auto; margin-right: auto; clear: both;position:relative;"></div>""")        

  render: ->
    root.application.log @collection
    @collection.each((slide) =>
      $(@slides).append(@slideTemplate(slide.toJSON()))
    )
    #$(@controls).append(@controlTemplate({}))
    @start()
  
  _update: =>
    root.application.log("update: current #{@current}")
    return  if @current is null
    $("#presentation-counter").innerText = @current
    $(".slide").hide()
    $("#slide-#{@current}").show()
    #window.location.hash = "slide" + @current
    x = @current# - 1
    while x < @current + 7
      @collection[x - 4].setState(Math.max(0, x - @current))  if @collection[x - 4]
      x++
    @
  next: ->
    #unless @_slides[@current - 1].buildNext()
    ##
    @current = Math.min(@current + 1, @collection.length - 1)
    @_update()

  prev: ->
    @current = Math.max(@current - 1, 0)
    @_update()

  go: (num) ->
    #history.replaceState @current, "Slide " + @current, "#slide" + @current  if history.pushState and @current isnt num
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
  @log('route:slides')
  @module("slideShow").render()
  root.application.showPage('slideShow')
,root.application
