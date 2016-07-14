-- problems

  -- strikes
  -- material shortage
  -- a new competitor
  -- poor planning
  -- theft
  -- buiding construction
  
-- opportunities
  -- a new guild
  -- a valuable trade
  -- a new technology
  -- a huge order
  
local potentials = {
  {
    identifier = "guilds_strikes",
    issue = {
      type = "problem",
      name = "Guild Strike",
      options = {
        {
          name = "This is not tolerated.",
          needs = { {"might"}},
          gains = {{"score", 2}},
        },
      },
      default = {
        name = "Whatever.",
        times = 2,
        gains = {{"score", -5}},
      },
    },
    validator = { "arithmetic", "guilds", "standing", 5, "<" },
    faction = "guilds"
  }, 
  {
    identifier = "guilds_shortages",
    issue = {
      type = "problem",
      name = "Material shortages",
      options = {
        {
          name = "Give them assistence",
          needs = { {"wealth"}, {"wealth"}},
          gains = {{"score", 10}},
        }
      },
      default = {
        name = "They made this mess, they fix it.",
        gains = {{"power", "guilds", -1}},
      }
    },
    validator = { "always" },
    faction = "guilds"
  },   
  {
    identifier = "guilds_conduct_trade",
    issue = {
      type = "opportunity",
      name = "Trade mission",
      options = {
        {
          name = "Help them set it up.",
          needs = { {"wealth"}},
          gains = {{"score", 3}},
        }
      },
      default = {
        name = "No assistence",        
        gains = {},
      }
    },
    validator = { "arithmetic", "guilds", "power", 3, ">" },
    faction = "guilds"
  },   
  {
    identifier = "guilds_new_technology",
    issue = {
      type = "opportunity",
      name = "New technology",
      options = {
        {
          name = "Invest heavily.",
          needs = { {"wealth"},{"wealth"},{"wealth"}},
          gains = {{"power", "guilds", 2}, {"score", 15}},
          times = 2,
        },
        {
          name = "Invest.",
          needs = { {"wealth"} },
          gains = {{"power", "guilds", 1}, {"score", 2}},
          times = 2
        }
      },
      default = {
        name = "Our current technology is fine.",
        gains = {{"power", "guilds", -1}},
      },
      ignorable = {
        times = 3,
        name = "Invest later."
      }
    },
    validator = { "rare" },
    faction = "guilds"
  },   
  {
    identifier = "guilds_new_trade_route",
    issue = {
      type = "opportunity",
      name = "A new trade route",
      options = {
        {
          name = "Secure the entire route.",
          needs = { {"wealth"}, {"wealth"}, {"might"}},
          gains = {{"score", 20}, {"resource", "wealth"}},
          times = 3
        },
        {
          name = "Setup minor caravans",
          needs = { {"wealth"} },
          gains = {{"score", 10}},
          times = 2
        }
      },
      default = {
        name = "Leave it to others.",
        gains = {{"standing", "guilds", -2}},
        times = 3
      }
    },
    validator = { "rare" },
    faction = "guilds"
  },   
  {
    identifier = "guilds_build_cathedral",
    issue = {
      type = "opportunity",
      name = "Build a cathedral",
      options = {
        {
          name = "Build now",
          needs = { {"wealth"}, {"wealth"}},
          gains = {{"score", 100}},
          times = 10,
        }
      },
      ignorable = {
        name = "Build later.",
        gains = {{"score", -2}},
        times = 5
      },
      default = {
        name = "Abandon the project",
        gains = {{"standing", "guilds", -2}, {"score", -20}}
      }
    },
    validator = { "rare" },
    faction = "guilds"
  },
  
}

return potentials