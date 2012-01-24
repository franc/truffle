root = exports ? this

class root.application.Slide extends Backbone.Model
  defaults: 
    id: 1
    headline: 'welcome to the slideshow'
    layout: 'right'
  show: =>
    root.application.log 'slide.show'
    #root.application.log @getEl()
    @getEl().show()
  getEl: =>
    $("#slide-#{@id}")
  #getControl: =>
  #  $('.jump-to').eq(@id)


class root.application.Slides extends Backbone.Collection
  model: root.application.Slide

class SlideShow extends Backbone.View
  slides: '#slides'
  controls: '#slideShow .controls'
  currentIndex: 0
    
  slideTemplate: _.template("""
  <div id="slide-<%= id %>" class="slide <%= layout %>" style="margin-left: auto; margin-right: auto;background:yellow;float:left;width:766px;height:400px;border:1px solid white;">
    <p class="headline"><%= headline %></p>
    <p class="caption"><%= caption %></p>
  </div>
  """)

  controlTemplate: _.template("""<div id="carousel_dots" style="text-align: center; margin-left: auto; margin-right: auto; clear: both;position:relative;"></div>""")        

  render: =>
    @.collection.each((slide) =>
      $(@slides).append(@slideTemplate(slide.toJSON()))
    )
    $(@controls).append(@controlTemplate({}))
    @start()
    @


  start: =>
    #root.application.log @collection
    #$('.slides .slide').hide()
    #@collection.at(0).show()
    #@collection.at(0).getControl().toggleClass('current')
    @carousel = $(@slides).carousel({#root.jq(@slides).carousel({
      vertical:false,
      horizontal:true,
      pagingDiv:"carousel_dots", # div to hold the dots for paging
      pagingCssName:"carousel_paging", #classname for the paging dots
      pagingCssNameSelected: "carousel_paging_selected" #classname for the selected page dots
    })

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
