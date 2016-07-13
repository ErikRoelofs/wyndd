local pics = {
  {
    food = love.graphics.newImage("assets/food.png"),
    wealth = love.graphics.newImage("assets/wealth.png"),
    might = love.graphics.newImage("assets/might.png"),
    faith = love.graphics.newImage("assets/faith.png"),
    official = love.graphics.newImage("assets/official.png")
  },
  {
    food = love.graphics.newImage("assets/food-c.png"),
    wealth = love.graphics.newImage("assets/wealth-c.png"),
    might = love.graphics.newImage("assets/might-c.png"),
    faith = love.graphics.newImage("assets/faith-c.png"),
    official = love.graphics.newImage("assets/official-c.png")
  }
}

local pickFile = function (type, hungry)
  if hungry then
    return pics[2][type]
  else
    return pics[1][type]
  end
end

return function(lc)
  return {
    build = function (base, options)
      local view = lc:build("stack", { width = "wrap", height = "wrap" } )
      view:addChild( lc:build("image", { width = "wrap", height = "wrap", file = pickFile(options.type, options.hungry), }))
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