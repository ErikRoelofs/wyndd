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
        local optionChild = lc:build("option", { option = option, highlighted = selectedFn })
        view:addChild(optionChild)
        if key ~= options.issue.selected then
          optionChild.collapse()
        end
      end
      
      view.signalHandlers.selected = function(self, signal, payload)
        if payload.option ~= self.issue.options[self.issue.selected] then
          self.children[self.issue.selected + 1]:receiveSignal("unselected", {})
          self.issue:selectOption(payload.option)
          self:layoutingPass()
        end
      end
      view.signalHandlers.resources_returned = "o"
      view.signalHandlers.resource_requesting_drop = function(self, signal, payload)        
        if self.issue:give(payload.resource) then
          payload.resource.used = true
          for i, r in ipairs(resources) do
            if r == payload.resource then
              table.remove(resources, i)
            end
          end          
          self:messageOut("accept_resource_drop", {})
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