return function(lc)
  return {
    build = function (base, options)
      local container = lc:build("linear", {direction = "v", width = "wrap", height = "wrap", backgroundColor = {0,0,255,255}, border = { color = {255,255,255,255}, thickness = 3}, padding = lc.padding(10)})
      
      -- add the name
      container:addChild( lc:build( "text", {data = function() return options.name end, width="wrap", height="wrap", backgroundColor = {255,0,0,255}, textColor={0,255,0,255}, padding = lc.padding(5) }) )
      
      -- add the needs
      local needsView = lc:build("linear", {height="wrap", width="fill", direction="h"})
      for k, need in ipairs(options.needs) do
        needsView:addChild(lc:build("need", need))
      end
      container:addChild(needsView)

      -- add the gains      
      container:addChild(lc:build("text", {height="wrap", width="wrap", data = { value = "Gains: " }, padding = lc.padding(5) }))
      
      local gainsView = lc:build("linear", {height="wrap", width="fill", direction="v", margin=lc.margin(0,0,0,5)})
      for k, gain in ipairs(options.gains ) do
        gainsView:addChild(gain:getView())
      end
      container:addChild(gainsView)

      return container
    end,
    schema = 
      { 
        name = {
          required = true,
          schemaType = "string",
        },
        needs = { 
          required = true, 
          schemaType = "array", 
          item = {
            required = true,
            schemaType = "table",
            options = {
              type = {
                required = true,
                schemaType = "string"
              },
              hungry = {
                required = false,
                schemaType = "boolean"
              },
              met = {
                required = false,
                schemaType = "boolean"
              }
            }
          }
        },
        gains = {},
      }
  }
end