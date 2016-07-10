function makeViewForIssue(lc, issue)
    
    --return lc:build("issue", { type = issue.type, name = issue.name, options = issue.options, selectedOption = function() return issue.selected end } )
    return lc:build("issue", { issue = issue } )
    
end