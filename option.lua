function newOption( name, needs, gains, times, payoutEnd )
  needs = simplecopy(needs)
  gains = simplecopy(gains)
  return {
    name = name,
    needs = needs,
    gains = gains,    
    times = times or 1,
    startTimes = times or 1,
    payoutEnd = payoutEnd or true,
    shouldResolve = true,
    resources = {},
    resolve = function(self)
      assert( self:metNeeds(), "Trying to resolve an option that was not met!")
      self:clean()     
      self.times = self.times - 1
      if self.times == 0 or not self.payoutEnd then
        for k, gain in ipairs(self.gains) do
          gain:resolve()
        end
      end
      return self.times == 0 and self.shouldResolve
    end,
    metNeeds = function(self)
      local met = true
      for k, need in ipairs(self.needs) do
        met = met and (need.met or false)
      end
      return met
    end,
    give = function(self, resource)
      for _, want in ipairs(self.needs) do
        if not want.met and want.type == resource.type then
          want.met = true          
          table.insert(self.resources, resource)          
          return true
        end
      end
      return false
    end,
    clean = function(self)
      for k, need in ipairs(self.needs) do
        need.met = false
      end
      self.done = false
    end,
    cleanHungry = function(self)
      for k, need in ipairs(self.needs) do
        if need.hungry then
          local notFound = true
          for i, resource in ipairs(self.resources) do            
            if notFound and resource.type == need.type then
              notFound = false
              table.remove(self.resources, i)              
            end
          end
        end
      end
    end,
    allNeedsNotMet = function(self)
      for k, need in ipairs(self.needs) do
        need.met = false
      end      
    end,
    returnResources = function(self, allOfThem)
      if not allOfThem then
        self:cleanHungry()
      end
      local r = #self.resources
      while r > 0 do
        local resource = self.resources[r]
        if allOfThem or not resource.consumable then
          resource.used = false
          table.insert(resources, resource)
        end
        table.remove(self.resources, r)
        r = r -1
      end
      self:allNeedsNotMet()      
    end,
    canSelect = function(self)
      return true
    end
  }
end

function buildOptionsFromTable(options)
  local returnList = {}
  for k, v in ipairs(options) do
    table.insert(returnList, buildOptionFromTable(v))
  end
  return returnList
end

function buildOptionFromTable(option)  
  return newOption(option.name, buildNeedsFromTable(option.needs), buildRewardsFromTable(option.gains), option.times)
end

function buildDefaultFromTable(default)
  default.needs = {}
  return buildOptionFromTable(default)
end

function buildIgnoreFromTable(ignore)
  local options = {
    name = ignore.name or "Ignore the issue",
    needs = {},
    gains = ignore.gains or {},
    times = ignore.times
  }
  local option = buildOptionFromTable(options)
  option.shouldResolve = false
  option.canSelect = function(self) return self.times > 0 end
  return option
end