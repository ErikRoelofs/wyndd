function makeViewForIssue(lc, issue)
    
    return lc:build("issue", { type = issue.type, name = issue.name, needs = issue.needs, gains = issue.gains, losses = issue.losses, repeats = issue.repeats, persistent = issue.persistent, delayed = issue.delayed, metNeeds = issue:metNeeds()  } )
    
end

function makeViewForNeed(need)
  
  local bgColor = {}
  if need.type == "wealth" then
    bgColor = {0,200,150,255}
  elseif need.type == "might" then
    bgColor = {100,100,100,255}
  elseif need.type == "food" then
    bgColor = {0,200,0,255}
  elseif need.type == "faith" then
    bgColor = {250,150,150,255}
  end
  
  met = {}
  if need.met then
    met = {0,255,0,255}
  else
    met = {255,0,0,255}
  end
 
  local view = lc:build("linear", {height=20, width=20, backgroundColor = bgColor, margin=lc.margin(5, 2)})
  view:addChild(lc:build("linear", {height=5, width=5, backgroundColor = met, border={color={255,255,255,255}, thickness=1 }, padding=lc.padding(10,2,2,10)}))
  return view
end