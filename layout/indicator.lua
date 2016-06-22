return function(lc)
  return {
    build = function (base, options)
      local getColor = function()
        if options.value() then
          return {0,255,0,255}
        else
          return {255,0,0,255}
        end
      end
      
      local view = lc:build("text", {width=11, height=11, border = { color = {255,255,255,255}, thickness = 2}, backgroundColor = getColor(), data = function() return "" end, padding = lc.padding(2), margin = lc.margin(2)})
      return view      
    end,
    schema = { 
      value = {
          required = true,
          schemaType = "function"
      },
      padding = { required = false, schemaType = "table", options = {
        left = { required = true, schemaType = "number" },
        right = { required = true, schemaType = "number" },
        bottom = { required = true, schemaType = "number" },
        top = { required = true, schemaType = "number" },
      }},      
    }
  }
end