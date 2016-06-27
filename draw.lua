function makeViewForIssue(lc, issue)
    
    return lc:build("issue", { type = issue.type, name = issue.name, needs = issue.needs, gains = issue.gains, losses = issue.losses, repeats = issue.repeats, persistent = issue.persistent, delayed = issue.delayed, metNeeds = function() return issue:metNeeds() end, continuous = issue.continuous } )
    
end