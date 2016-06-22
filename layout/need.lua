-- needs to render its MET state!
local pics = {
  food = love.graphics.newImage("assets/food.png"),
  wealth = love.graphics.newImage("assets/wealth.png"),
  might = love.graphics.newImage("assets/might.png"),
  faith = love.graphics.newImage("assets/faith.png"),
}

local pickFile = function (type)
  return pics[type]
end

return function(lc)
  return {
    build = function (base, options)
      local view = lc:build("stack", { width = "wrap", height = "wrap" } )
      view:addChild( lc:build("image", { width = "wrap", height = "wrap", file = pickFile(options.type), margin = lc.margin(5)}))      
      view:addChild( lc:build("indicator", { value = function() return options.met end, padding = lc.padding(5) }))
      return view
    end,
    schema =
      {
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
end