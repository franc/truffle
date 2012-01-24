root = exports ? this

class root.application.Slide extends Backbone.Model
  show: =>
    root.application.log 'slide.show'
    #root.application.log @getEl()
    @getEl().show()
  getEl: =>
    $("#slide-#{@id}")


class root.application.Slides extends Backbone.Collection
  model: root.application.Slide

class SlideShow extends Backbone.View
  slides: '#slides'
  controls: '#slideShow .controls'
  currentIndex: 0
    
  slideTemplate: _.template("""
  <div id="slide-<%= id %>" class="slide" style="margin-left: auto; margin-right: auto;background:yellow;float:left;width:766px;height:400px;border:1px solid white;">
    <div class='caption'><%= caption %></div><div id='content'><%= content %></div>
  </div>
  """)

  controlTemplate: _.template("""<div id="carousel_dots" style="text-align: center; margin-left: auto; margin-right: auto; clear: both;position:relative;"></div>""")        

  render: =>
    root.application.log @collection
    @collection.each((slide) =>
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
    collection: new root.application.Slides(root.slides_data)
  }))
,root.application)

#bind custom routes
root.application.bind "route:slides", ->
  @log('route:slides')
  @module("slideShow").render()
  root.application.showPage('slideShow')
,root.application
