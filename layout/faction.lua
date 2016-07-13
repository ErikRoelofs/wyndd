return function(lc)
  return {
    build = function (base, options)
    
    local container = lc:build("linear", {direction = "v", width = "wrap", height = "wrap"})
    container:addChild( lc:build( "text", {data = function() return options.name end, width="wrap", height="wrap", padding = lc.padding(5) }) )
    container:addChild( lc:build( "numberasimage", {width = "wrap", height = "wrap", value = function() return options.power end, image = "assets/power.png", emptyImage = "assets/emptypower.png", maxValue = 10}))
    container:addChild( lc:build( "numberasimage", {width = "wrap", height = "wrap", value = function() return options.standing end, image = "assets/heart.png", emptyImage = "assets/emptyheart.png", maxValue = 10}))
   
      return container
    end,
    schema = 
      { 
        name = {
          required = true,
          schemaType = "string"
        },
        power = {
          required = true,
          schemaType = "number"
        },
        standing = {
          required = true,
          schemaType = "number"
        }
      }
  }
end