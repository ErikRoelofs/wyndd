return function(lc)
  return {
    build = function (base, options)
      local bgColor = {}
      if options.issue.type == "problem" then
        bgColor = {150,0,0,255}
      elseif options.issue.type == "opportunity" then
        bgColor = {0,150,0,255}
      end
      
      local view = lc:build("linear", {height="fill", width="wrap", direction="v", backgroundColor = bgColor})
      
      view.issue = options.issue
      
      view:addChild(lc:build("text", {height="wrap", width="wrap", data = { value = options.issue.name }, padding = lc.padding(5) }))
      
      local selected = function() return options.issue.selected end
      
      for key, option in ipairs(options.issue.options) do
        local myKey = key
        local selectedFn = function() return myKey == selected() end
              
        --[[
        local toPass = {          
          name = option.name,
          needs = option.needs,
          gains = option.gains,
          highlighted = selectedFn,
          times = option.times,
          maxTimes = option.startTimes,
          selectable = function() return option:canSelect() end
        }
        ]]
        view:addChild(lc:build("option", { option = option, highlighted = selectedFn }))
      end
            
      view.receiveSignal = function( self, signal, payload )
        if signal == "leftclick" then
          -- hmm. going to have to implement this.
          self:clickedViews(payload.x, payload.y)
          
          
          self:signalChildren(signal, payload)
        end
        if signal == "selected" then
          self.issue:selectOption(payload.option)
        end
      end
            
      return view
    end,
    --[[
    schema = 
      { 
        type = { required = true, schemaType = "fromList", list = { "problem", "opportunity" }},
        name = { required = true, schemaType = "string" },
        options = { required = true, schemaType = "free" },
        selectedOption = { required = true, schemaType = "function" }        
      }
      ]]
      schema = { issue = { required = true, schemaType = "free" } }
  }
end