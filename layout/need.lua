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
      return lc:build("image", { width = "wrap", height = "wrap", file = pickFile(options.type)})
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