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
      local border = nil
      if options.consumable then
        border = { color = { 255, 255, 255, 255 }, thickness = 2 }
      end
      return lc:build("image", { width = "wrap", height = "wrap", file = pickFile(options.type), margin=lc.margin(5), border = border})
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