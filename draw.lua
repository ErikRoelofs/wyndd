function makeViewForIssue(lc, issue)
    
    return lc:build("issue", { type = issue.type, name = issue.name, options = issue.options } )
    
end