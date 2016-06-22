-- needs to render its MET state!
local function timeInfo(issue)
  local timeInfo = ''
  
  if issue.repeats > 1 then
    timeInfo = timeInfo .. "r: " .. issue.repeats .. "x"
  end
  if issue.repeats > 1 and issue.delayed > 1 then
    timeInfo = timeInfo .. " / "
  end
  if issue.delayed > 1 then
    timeInfo = timeInfo .. "d: " .. issue.delayed .. "x"
  end
  if issue.persistent then
    timeInfo = timeInfo .. " (P)"
  end
  return timeInfo
end

return function(lc)
  return {
    build = function (base, options)
      local bgColor = {}
      if options.type == "problem" then
        bgColor = {150,0,0,255}
      elseif options.type == "opportunity" then
        bgColor = {0,150,0,255}
      end
      
      local view = lc:build("linear", {height="wrap", width="wrap", direction="v", backgroundColor = bgColor})
      
      view:addChild(lc:build("text", {height="wrap", width="wrap", data = { value = options.name }, padding = lc.padding(5) }))
      
      view:addChild(lc:build("text", {height="wrap", width="wrap", data = { value = "Requirements: " }, padding = lc.padding(5) }))
      
      local needsView = lc:build("linear", {height="wrap", width="fill", direction="h"})
      for k, need in ipairs(options.needs) do
        needsView:addChild(lc:build("need", need))
      end
      view:addChild(needsView)
      
      local gainsBorder = {}
      local lossesBorder = {}
      if options.metNeeds then
        gainsBorder = { color = {255,255,255,255}, thickness = 2}
        lossesBorder = { color = {0,0,0,0}, thickness = 0}
      else
        gainsBorder = { color = {0,0,0,0}, thickness = 0}
        lossesBorder = { color = {255,255,255,255}, thickness = 2}        
      end
      view:addChild(lc:build("text", {height="wrap", width="wrap", data = { value = "Gains: " }, border = gainsBorder, padding = lc.padding(5) }))
      
      local gainsView = lc:build("linear", {height="wrap", width="fill", direction="v", margin=lc.margin(0,0,0,5)})
      for k, gain in ipairs(options.gains ) do
        gainsView:addChild(gain:getView())
      end
      view:addChild(gainsView)
      
      view:addChild(lc:build("text", {height="wrap", width="wrap", data = { value = "Losses: " }, border = lossesBorder, padding = lc.padding(5) }))

      local lossesView = lc:build("linear", {height="wrap", width="fill", direction="h", margin=lc.margin(0,0,0,5)})  
      for k, loss in ipairs(options.losses ) do
        lossesView:addChild(loss:getView())
      end
      view:addChild(lossesView)
      
      view:addChild(lc:build("text", {width="wrap", height="wrap",data = { value = timeInfo(options) } }))
      view:addChild(lc:build("indicator", {value = function() return options.metNeeds() end}))
      
      return view
    end,
    schema = 
      { 
        type = { required = true, schemaType = "fromList", list = { "problem", "opportunity" }},
        name = { required = true, schemaType = "string" },
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
        losses = {},
        metNeeds = {
            required = true,
            schemaType = "function"
        },
        repeats = {
          required = true,
          schemaType = "number"
        },
        persistent = {
          required = true,
          schemaType = "boolean"
        },
        delayed = {
          required = true,
          schemaType = "number"
        }
        
      }
  }
end