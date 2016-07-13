return function(lc)
  return {
    build = function (base, options)      
      
      local getSuccesses = function(self)
        if type(self.currentSuccesses) == "function" then
          return self.currentSuccesses()
        else
          return self.currentSuccesses.value
        end
      end
      
      local getFailures= function(self)
        if type(self.currentFailures) == "function" then
          return self.currentFailures()
        else
          return self.currentFailures.value
        end
      end

      local getSize = function(self)
        return self.successes + self.failures - 1
      end
            
      local container = lc:build("linear", {direction = options.direction or "h", width = options.width, height = options.height, backgroundColor = options.backgroundColor, padding = options.padding})
      container.value = options.value     
      container.getSize = getSize
      container.getSuccesses = getSuccesses
      container.getFailures = getFailures
      container.successes = options.successes
      container.failures = options.failures
      container.currentSuccesses = options.currentSuccesses
      container.currentFailures = options.currentFailures
      
      
      if type(options.image) == "string" then
        container.successImage = love.graphics.newImage(options.successImage)
      else
        container.successImage = options.successImage
      end
      if type(options.failureImage) == "string" then
        container.failureImage = love.graphics.newImage(options.failureImage)
      else
        container.failureImage = options.failureImage
      end
      if type(options.emptyImage) == "string" then
        container.emptyImage = love.graphics.newImage(options.emptyImage)
      else
        container.emptyImage = options.emptyImage
      end
      if type(options.targetImage) == "string" then
        container.targetImage = love.graphics.newImage(options.targetImage)
      else
        container.targetImage = options.targetImage
      end
      
      container.contentWidth = function(self) return self:getSize() * self:emptyChild():contentWidth() end
      container.contentHeight = function(self) return self:emptyChild():contentHeight() end        
      
      container.update = function(self, dt)        
        if self:getSuccesses() ~= self.lastSuccesses or self:getFailures() ~= self.lastFailures then
          self:removeAllChildren()
          self.lastSuccesses = self:getSuccesses()
          self.lastFailures = self:getFailures()
          
          local successesToRender = math.max( math.min(self:getSuccesses(), self.successes ), 0 )
          local empty1ToRender = self.successes - successesToRender - 1
          
          local failuresToRender = math.max( math.min(self:getFailures(), self.failures), 0 )
          local empty2ToRender = self.failures- failuresToRender - 1
          
          local i = 0
          while i < successesToRender do
            i = i + 1
            self:addChild(self:successChild())
          end
          local i = 0
          while i < empty1ToRender do
            i = i + 1
            self:addChild(self:emptyChild())
          end
          
          self:addChild(self:targetChild())
          
          local i = 0
          while i < empty2ToRender do
            i = i + 1
            self:addChild(self:emptyChild())
          end
          local i = 0
          while i < failuresToRender do
            i = i + 1
            self:addChild(self:failureChild())
          end
                
          self:layoutingPass()
        end
      end
      
      container.successChild = function(self)
        return lc:build("image", { width = "wrap", height = "wrap", file = self.successImage } )
      end
      
      container.failureChild = function(self)
        return lc:build("image", { width = "wrap", height = "wrap", file = self.failureImage } )
      end

      container.emptyChild = function(self)
        return lc:build("image", { width = "wrap", height = "wrap", file = self.emptyImage } )
      end
      
      container.targetChild = function(self)
        return lc:build("image", { width = "wrap", height = "wrap", file = self.targetImage } )
      end
      
      return container
    end,
    schema = lc:extendSchema("base", {
      successImage = {        
        required = true,           
        schemaType = "oneOf",
        possibilities = {
            {
              schemaType = "string"
            },
            {
              schemaType = "image"
            }
        }
      }, 
      failureImage = {        
        required = true,
        schemaType = "oneOf",
        possibilities = {
            {
              schemaType = "string"
            },
            {
              schemaType = "image"
            }
        }
      }, 
     emptyImage = {        
        required = true,
        schemaType = "oneOf",
        possibilities = {
            {
              schemaType = "string"
            },
            {
              schemaType = "image"
            }
        }
      }, 
      targetImage = {        
        required = true,
        schemaType = "oneOf",
        possibilities = {
            {
              schemaType = "string"
            },
            {
              schemaType = "image"
            }
        }
      }, 
       successes = {
          required = true,
          schemaType = "number"
        },
       failures = {
          required = true,
          schemaType = "number"
        },
        currentSuccesses = {
          required = true, 
          schemaType = "oneOf",
          possibilities = {
            {
              schemaType = "table", 
              options = { 
                value = { 
                  required = true, 
                  schemaType ="string" 
                } 
              } 
            },
            {
              schemaType = "function",
            }
          }
        },
        currentFailures = {
          required = true, 
          schemaType = "oneOf",
          possibilities = {
            {
              schemaType = "table", 
              options = { 
                value = { 
                  required = true, 
                  schemaType ="string" 
                } 
              } 
            },
            {
              schemaType = "function",
            }
          }
        },
        direction = { 
          required = false, 
          schemaType = "fromList", list = { "v", "h" } 
        }
      })  
  }
end