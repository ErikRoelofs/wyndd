return function(lc)
  return {
    build = function (base, options)
      local bgColor = {}
      if options.type == "problem" then
        bgColor = {150,0,0,255}
      elseif options.type == "opportunity" then
        bgColor = {0,150,0,255}
      end
      
      local view = lc:build("linear", {height="fill", width="wrap", direction="v", backgroundColor = bgColor})
      
      view:addChild(lc:build("text", {height="wrap", width="wrap", data = { value = options.name }, padding = lc.padding(5) }))
      
      local selected = options.selectedOption
      
      for key, option in ipairs(options.options) do
        local myKey = key
        local selectedFn = function() return myKey == selected() end
              
        local toPass = {          
          name = option.name,
          needs = option.needs,
          gains = option.gains,
          highlighted = selectedFn,
          selectable = function() return option:canSelect() end
        }
        view:addChild(lc:build("option", toPass))
      end
            
      return view
    end,
    schema = 
      { 
        type = { required = true, schemaType = "fromList", list = { "problem", "opportunity" }},
        name = { required = true, schemaType = "string" },
        options = {},
        selectedOption = { required = true, schemaType = "function" }        
      }
      
  }
end