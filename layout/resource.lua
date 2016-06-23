local pics = {
  {
    food = love.graphics.newImage("assets/food.png"),
    wealth = love.graphics.newImage("assets/wealth.png"),
    might = love.graphics.newImage("assets/might.png"),
    faith = love.graphics.newImage("assets/faith.png")
  },
  {
    food = love.graphics.newImage("assets/food-c.png"),
    wealth = love.graphics.newImage("assets/wealth-c.png"),
    might = love.graphics.newImage("assets/might-c.png"),
    faith = love.graphics.newImage("assets/faith-c.png")
  }
}

local pickFile = function (type, consumable)
  if consumable then
    return pics[2][type]
  else
    return pics[1][type]
  end
end

return function(lc)
  return {
    build = function (base, options)
      return lc:build("image", { width = "wrap", height = "wrap", file = pickFile(options.type, options.consumable), margin=lc.margin(5)})
    end,
    schema =
      {
        type = {
            required = true,
            schemaType = "string"
        },
        consumable = {
          required = false,
          schemaType = "boolean"
        },
        used = {
          required = false,
          schemaType = "boolean"
        }
      }
    
  }
end