return function(lc)
  return {
    build = function (base, options)
      local container = lc:build("linear", {direction = "v", width = "wrap", height = "wrap", backgroundColor = {0,0,255,255}, padding = lc.padding(10)})
      
      container.option = options.option
      container.selectable = function() return options.option:canSelect() end
      container.highlighted = options.highlighted
      
      -- add the name
      container:addChild( lc:build( "text", {data = function() return options.option.name end, width="wrap", height="wrap", backgroundColor = {255,0,0,255}, textColor={0,255,0,255}, padding = lc.padding(5) }) )
      
      -- add the needs
      local needsView = lc:build("linear", {height="wrap", width="fill", direction="h"})
      for k, need in ipairs(options.option.needs) do
        needsView:addChild(lc:build("need", need))
      end
      container:addChild(needsView)

      -- add the gains      
      container:addChild(lc:build("text", {height="wrap", width="wrap", data = { value = "Gains: " }, padding = lc.padding(5) }))
      
      local gainsView = lc:build("linear", {height="wrap", width="fill", direction="v", margin=lc.margin(0,0,0,5)})
      for k, gain in ipairs(options.option.gains ) do
        gainsView:addChild(gain:getView())
      end
      container:addChild(gainsView)

      container:addChild(lc:build("text", {height="wrap", width="wrap", data = function() return options.option.times .. "/" .. options.option.startTimes end }))

      container.update = function(self, dt)
        if self:selectable() then
          if self:highlighted() then
            self.border = { color =  {255,255,255,255}, thickness = 3 }
          else
            self.border= { color = {50,50,50,255}, thickness = 3 }
          end
        else
          self.border = { color =  {255,0,0,255}, thickness = 3 }
        end
        for _, child in ipairs(self:getChildren()) do
          child:update(dt)
        end
      end

      container.signalHandlers.leftclick = function(self, signal, payload)
        self:messageOut("selected", { option = container.option } )
      end

      container.signalHandlers.unselected = function(self, signal, payload)
        local returned self.option:returnResources(true)
        self:messageOut("resources_returned", returned )        
      end

      return container
    end,
    schema = {
      option = {
        required = true,
        schemaType = "free"
      },
      highlighted = {
        required = true,
        schemaType = "function"
      }
    }
    --[[
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
        gains = {required = true, schemaType = "free" },
        highlighted = {
          required = true,
          schemaType = "function",
        },
        selectable = {
          required = true,
          schemaType = "function"
        },
        times = {
          required = true,
          schemaType = "number"
        },
        maxTimes = {
          required = true,
          schemaType = "number"
        }        
      }
      ]]
  }
end