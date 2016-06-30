function makeViewForIssue(lc, issue)
    
    return lc:build("issue", { type = issue.type, name = issue.name, options = issue.options, selected = function() return issue.selected end } )
    
end