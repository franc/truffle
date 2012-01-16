root = exports ? this

root.application.Slide = Backbone.Model.extend(
  defaults: 
    id: 1
    headline: 'welcome to the slideshow'
    layout: 'right'
  show: ->
    root.application.log 'slide.show'
    root.application.log @getEl()
    @getEl().show()
  getEl: =>
    $("#slide-#{@id}")
  getControl: =>
    $('.jump-to').eq(@id - 1)
)

root.application.Slides = Backbone.Collection.extend(
  model: root.application.Slide
)

class SlideShow extends Backbone.View
  slides: '#slideShow .slides'
  controls: '#slideShow .controls'
  playPauseControl: '#slideShow .controls .toggle-play-pause'
  delay: 10000
  currentIndex: 0
  events:
    'click .toggler': 'toggleVisibility'
    'click .toggle-play-pause': 'togglePlayPause'
    'click .jump-to': 'jumpTo'

  slideTemplate: _.template("""
  <li id="slide-<%= id %>" class="slide <%= layout %>" style="background: url(images/slides/<%= id %>.jpg) no-repeat;">
    <p class="headline"><%= headline %></p>
    <p class="caption"><%= caption %></p>
  </li>
  """)

  controlTemplate: _.template("""<li class="slide-control jump-to" data-index="<%= index %>"><%= human_readable_index %></li>""")        

  render: => 
    @.collection.each((slide, i) =>
      $(@slides).append(@slideTemplate(slide.toJSON()))
      $(@controls).append(@controlTemplate({
        index: i
        human_readable_index: ++i
      }))
    )
    @start()
    @

  rotateSlides: =>
    current = @currentIndex
    next = @currentIndex == (@collection.length - 1) ? 0 : @currentIndex + 1
    @transition(current, next)

  transition: (from, to) =>
    current = @collection.at(from)
    next = @collection.at(to)
    current.getEl().fadeOut('slow', -> 
      next.getEl().fadeIn('slow')
    )
    current.getControl().toggleClass('current')
    next.getControl().toggleClass('current')
    @currentIndex = to
    @

  toggleVisibility: =>
    slides = $(@slides)
    slides.toggle()
    $(@el).toggleClass('collapsed')
    if slides.is(":visible")
      @play()
    else
      @pause()

  togglePlayPause: =>
    if @isPlaying()
      @pause()
    else
      @play()

  start: ->
    root.application.log @collection
    $('.slides .slide').hide()
    @collection.at(0).show()
    @collection.at(0).getControl().toggleClass('current')
    @play()

  pause: =>
    if @isPaused()
      return
    @state = 'paused'
    clearInterval(@intervalID)
    $(@playPauseControl).toggleClass('playing', false)
    @

  play: =>
    if @isPlaying()
      return
    @state = 'playing';
    @intervalID = setInterval(@rotateSlides, @delay)
    $(@playPauseControl).toggleClass('playing', true)
    @

  jumpTo: (e) =>
    next = $(e.currentTarget).data('index')
    @pause()
    @transition(@currentIndex, next)
    @

  isPlaying: =>
      return @.state == 'playing'

  isPaused: =>
      return !@isPlaying()


#-------------------

#bind launch action
root.application.bind("application:launch", ->
  @log('slideShow : application:launch')
  #initialize module instance
  @module("slideShow", new SlideShow({
    el: '#slideShow'
    collection: new root.application.Slides([
      {
        id: 0
        headline: 'SLide 0'
        caption: 'trying things out.'
        layout: 'left'
      }
      {
        id: 1
        headline: 'Welcome to APP'
        caption: 'The best online tool for stuff.'
        layout: 'left'
      }
      {
        id: 2
        headline: 'Thousands of Products'
        caption: 'APP provides a huge catalogue of stuff.<br/> Search the below to get started.'
      }
      {
        id: 3
        headline: 'Mobile Ready'
        caption: 'Are you ready for the mobile web?'
      }
      {
        id: 4
        headline: 'Rich Media'
        caption: 'Search the APP for access to thousands of videos and audio files to enrich your stuff.'
      }
      {
        id: 5
        headline: 'Built for Medical Professionals'
        caption: 'APP provides tools for people that allow you to manage and organize your purchases with ease.'
      }
    ])
  }))
,root.application)

#bind custom routes
root.application.bind "route:slides", ->
  @log('route:slides')
  @module("slideShow").render()
  root.application.showPage('slideShow')
,root.application
