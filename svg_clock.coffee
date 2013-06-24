class SvgClock extends Backbone.View
  _h: ->
    if @$el.parent()?.length
      p = @$el.parent()
      return p.height() || p.width() || 200
    else
      200
  setTime: (h,m) ->
    d = @diameter
    minuteDegree = (m * 6) - 180
    @minute
      .transition()
      .duration(1000)
      .attr("transform","translate(#{d*.5},#{d*.5}) rotate(#{minuteDegree},0,0)")
    hourDegree = ((h * 30) - 180) + (30 * (m/60))
    @hour
      .transition()
      .duration(1000)
      .attr("transform","translate(#{d*.5},#{d*.5}) rotate(#{hourDegree},0,0)")
    
  setDate: (d) ->
    @setTime h.getHours(), h.getMinutes()
  render: (opts={}) ->
    d = @diameter = opts.diameter || @_h()
    t = opts.time || new Date()
    
    svg = d3.select("#clock").append("svg")
    foc = svg.append("g")
    
    bg = foc.append("circle")
      .attr("cx", d/2)
      .attr("cy", d/2)
      .attr("r",d*.45)
      .style("fill","#fff")
      .style("stroke","#000")
      .style("stroke-width",2)
    
    shadow_gradient = svg.append("defs")
      .append("linearGradient")
      .attr("id", "shadow")
      .attr("x1","0%")
      .attr("x2","0%")
      .attr("y1","0%")
      .attr("y2","100%")
      
    shadow_gradient.append("stop")
      .attr("offset","0%")
      .attr("style","stop-color:rgb(100,100,100);stop-opacity:.2")

    shadow_gradient.append("stop")
      .attr("offset","60%")
      .attr("style","stop-color:rgb(255,255,255);stop-opacity:0")
      
    shadow = foc.append("circle")
      .attr("cx", d/2)
      .attr("cy", d/2)
      .attr("r",d*.45)
      .style("fill","url(#shadow)")
    
    fg = foc.append("circle")
      .attr("cx", d/2)
      .attr("cy", d/2)
      .attr("r",d*.42)
      .style("fill","#fff")
      
    hours = foc.append("g")
      .attr("transform","translate(#{d/2},#{d/2})")
      .style("font-size",d*.1)
    _.each _.range(1,13), (i) ->
      hours.append("g")
      hours.append("text")
        .text(i)
        .style("fill","#999")
        .attr("text-anchor","middle")
        .attr("x", ->
          angle = i*30-90
          pos = Math.cos(angle*Math.PI/180)*(d*.345)
          pos
        )
        .attr("y", ->
          angle = i*30-90
          pos = Math.sin(angle*Math.PI/180)*(d*.345)
          pos += d*.03
          pos
        )
        
    ticks = foc.append("g")
      .attr("transform","translate(#{d*.5},#{d*.05})")
    _.each _.range(1,61), (i) ->
      ticks
      .append("g")
      .attr("transform","rotate(#{i*6-180}, 0, #{d*.45})")
      .append("line")
      .style("stroke","#666")
      .style("stroke-width",if i % 5 then d*.005 else d*.02)
      .attr("x1",0)
      .attr("x2",0)
      .attr("y1",if i % 5 then d*.015 else 0)
      .attr("y2",if i % 5 then d*.04 else d*.05)
      
    time = t
    minuteDegree = (time.getMinutes() * 6) - 180
    hourDegree = ((time.getHours() * 30) - 180) + (30 * (time.getMinutes()/60))
    
      
    @hour = foc.append("g")
    @hour.append("polygon")
      .attr("points","#{d*.0175},-#{d*.05} #{d*.01},#{d*.25} #{d*-.01},#{d*.25} -#{d*.0175},-#{d*.05}")
      .style("fill","#555")
    @hour
      .attr("transform","translate(#{d*.5},#{d*.5}) rotate(180,0,0)")
    @hour
      .transition()
      .duration(1000)
      .attr("transform","translate(#{d*.5},#{d*.5}) rotate(#{hourDegree},0,0)")
    
    @minute = foc.append("g")
    @minute.append("polygon")
      .attr("points","#{d*.0125},-#{d*.05} #{d*.01},#{d*.35} #{d*-.01},#{d*.35} -#{d*.0125},-#{d*.05}")
      .style("fill","#555")
    @minute
      .attr("transform","translate(#{d*.5},#{d*.5}) rotate(180,0,0)")
    @minute
      .transition()
      .duration(1000)
      .attr("transform","translate(#{d*.5},#{d*.5}) rotate(#{minuteDegree},0,0)")
    
    foc.append("circle")
      .attr("cx", d/2)
      .attr("cy", d/2)
      .attr("r",d*.01)
      .style("fill","#999")
      .style("stroke","none")
      
    reflect_gradient = svg.append("defs")
      .append("linearGradient")
      .attr("id", "reflect")
      .attr("x1","0%")
      .attr("x2","0%")
      .attr("y1","0%")
      .attr("y2","100%")
      
    reflect_gradient.append("stop")
      .attr("offset","0%")
      .attr("style","stop-color:rgb(157,216,255);stop-opacity:.25")

    reflect_gradient.append("stop")
      .attr("offset","60%")
      .attr("style","stop-color:rgb(157,216,255);stop-opacity:.05")
      
    foc.append("ellipse")
      .attr("cx",d*.5)
      .attr("cy",d*.36)
      .attr("rx",d*.3)
      .attr("ry",d*.2)
      .style("fill","url(#reflect)")
      .style("stroke","none")
