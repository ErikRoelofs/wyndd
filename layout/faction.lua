return function(lc)
  return {
    build = function (base, options)
    
    local container = lc:build("linear", {direction = "v", width = "wrap", height = "wrap"})     
    container:addChild( lc:build( "text", {data = function() return options.name end, width="wrap", height="wrap", padding = lc.padding(5) }) )
    container:addChild( lc:build( "numberasimage", {width = "wrap", height = "wrap", value = function() return options.power end, image = "assets/faith.png", emptyImage = "assets/food.png", maxValue = 10, backgroundColor = {255,0,0,255}}))
    container:addChild( lc:build( "numberasimage", {width = "wrap", height = "wrap", value = function() return options.standing end, image = "assets/wealth.png", emptyImage = "assets/might.png", maxValue = 10, backgroundColor = {255,0,0,255}}))
   
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