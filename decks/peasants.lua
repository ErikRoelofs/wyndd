--[[ issues for the peasant faction ]]--

-- problems
  -- uprising
  -- hunger
  -- crop death (pests, draught, disease)
  -- banditry
  -- land disputes
  -- not paying tax

-- opportunities
  -- harvest feast
  -- bountiful harvest
  -- draft
  -- taxation
  -- land expansion
  -- structures (mills, bakeries, granaries, etc)
  -- new crops
  -- animal related
  
local potentials = {
  {
    identifier = "peasant_riot_3",
    issue = {
      type = "problem",
      name = "Peasant revolt",
      options = {
        {
          name = "Strike them down!",
          needs = { {"might"}, {"might"}, {"might"}, {"might"} },
          gains = {{"power", "peasants", -3}},
        }
      },
      default = {
        name = "Flee the country",
        gains = {{"game_end"}},
      },
      ignorable = {
        times = 3,
        gains = {}
      }      
    },
    validator = { "never" },
    faction = "peasants"
  },
  {
    identifier = "peasant_riot_2",
    issue = {
      type = "problem",
      name = "Peasant uprising",
      options = {
        {
          name = "Face them, head on",
          needs = { {"might"}, {"might"}, {"might"} },
          gains = {{"power", "peasants", -2}},
        }
      },
      default = {
        name = "Let the problem grow.",
        gains = {{"score", -10}, {"issue", "peasant_riot_3"}},
      },
      ignorable = {
        times = 3
      }      
    },
    validator = { "never" },
    faction = "peasants"
  },
  {
    identifier = "peasant_riot_1",
    issue = {
      type = "problem",
      name = "Peasant riot",
      options = {
        {
          name = "Put them in their place.",
          needs = { {"might"}, {"might"} },
          gains = {{"power", "peasants", -1}},
        }
      },
      default = {
        name = "Let them have their fun.",
        gains = {{"score", -5}, {"issue", "peasant_riot_2"}},
      },
      ignorable = {
        times = 3,
      }
    },
    validator = { "arithmetic", "peasants", "standing", 3, "<" },
    faction = "peasants"
  },
  {
    identifier = "peasant_hunger",
    issue = {
      type = "problem",
      name = "Famine strikes.",
      options = {
        {
          name = "Feed them from your reserves.",
          needs = { {"food"} },
          gains = {{"standing", "peasants", 1}},
        }
      },
      default = {
        name = "Let them starve.",
        gains = {{"power", "peasants", -1}}
      }
    },
    validator = { "seasonal", "winter" },
    faction = "peasants"
  },
  {
    identifier = "peasant_good_harvest",
    issue = {
      type = "opportunity",
      name = "Bountiful Harvest",
      options = {
        {
          name = "Bring it to your granaries.",
          needs = { {"might"} },
          gains = {{"resource", "food", true}},
        }
      },
      default = {
        name = "Let them keep it.",
        gains = {{"standing", "peasants", 1}}
      }
    },
    validator = { "OR", {{ "seasonal", "autumn" }, { "seasonal", "summer" }}},
    faction = "peasants"
  },
  {
    identifier = "peasant_festivities",
    issue = {
      type = "opportunity",
      name = "Summer Festivities",
      options = {
        {
          name = "Make it a grand festival.",
          needs = { {"wealth"} },
          gains = {{"power", "peasants", 1}},
        },
      },
      default = {
        name = "Let them pay for their own.",
        gains = {}
      }
    },
    validator = { "seasonal", "summer" },
    faction = "peasants"
  },
  {
    identifier = "peasant_militia",
    issue = {
      type = "opportunity",
      name = "Raise Militia",
      options = {
        {
          name = "Recruit the able-bodied.",
          needs = { {"wealth"} },
          gains = {{"power", "peasants", -1}, {"resource", "might"}}
        },
      },
      default = {
        name = "We can't afford more troops",
        gains = {}
      }
    },
    validator = { "arithmetic", "peasants", "power", 5, ">" },
    faction = "peasants"
  },
  {
    identifier = "peasant_draft",
    issue = {
      type = "opportunity",
      name = "Draft soldiers",
      options = {
        {
          name = "Conscript the able-bodied.",
          needs = { {"might"}, {"might"} },
          gains = {{"power", "peasants", -1}, {"standing", "peasants", -1}, {"resource", "might"}},
        },
      },
      default = {
        name = "Leave them be, for now.",
        gains = {}
      }
    },
    validator = { "arithmetic", "peasants", "power", 3, ">" },
    faction = "peasants"
  }, 
  {
    identifier = "peasant_expand_land",
    issue = {
      type = "opportunity",
      name = "Expand farmlands",
      options = {
        {
          name = "Set up an expedition.",
          needs = { {"might"}, {"wealth"} },
          gains = {{"power", "peasants", 1}, {"score", 5}},
          times = 2
        }
      },
      default = {
        name = "Let them try on their own.",
        gains = {{"score", -2}},
      }
    },
    validator = { "rare" },
    faction = "peasants"
  },
  {
    identifier = "peasant_taxation",
    issue = {
      type = "opportunity",
      name = "Raise taxes",
      options = {
        {
          name = "High taxes",
          needs = { {"might"} },
          gains = {{"standing", "peasants", -1}, {"resource", "wealth", true}},
          times = 2
        },
        {
          name = "Excessive taxes",
          needs = { {"might"}, {"might"} },
          gains = {{"standing", "peasants", -2}, {"resource", "wealth"}},
          times = 3
        }
      },
      default = {
        name = "Regular taxes.",
        gains = {}
      },
    },
    validator = { "always" },
    faction = "peasants"
  },
  {
    identifier = "peasant_build_mill",
    issue = {
      type = "opportunity",
      name = "Build a Mill",
      options = {
        {
          name = "Help build the mill",
          needs = { {"wealth"}, {"wealth"} },
          gains = {{"standing", "peasants", 1}, {"resource", "food"}},
          times = 3,
        }
      },
      default = {
        name = "Let them struggle alone.",
        gains = {{"score", -10}}
      },
      ignorable = {
        name = "Promise help later.",
        gains = {{"score", -1}},
        times = 3
      }      
    },
    validator = { "always" },
    faction = "peasants"
  },
  {
    identifier = "peasant_build_barn",
    issue = {
      type = "opportunity",
      name = "Raise a Barn",
      options = {
        {
          name = "Help raising the barn",
          needs = { {"wealth"} },
          gains = {{"score", 3}},
          times = 2,
        },
      },
      default = {
        name = "It is their own problem",
        gains = {},
      },
    },
    validator = { "always" },
    faction = "peasants"
  },  
 {
    identifier = "peasant_bandits",
    issue = {
      type = "problem",
      name = "Bandit activity",
      options = {
        {
          name = "Flush out these bandits.",
          needs = { {"might"}, {"might"} },
          gains = {{"standing", "peasants", 1}, {"score", 10}},
          times = 3
        },
        {
          name = "Increase patrols.",
          needs = { {"might"} },
          gains = {{"score", 3}},
          times = 3
        }
      },
      default = {
        name = "Let them rob the peasants",
        gains = {{"score", -5}, {"standing", "peasants", -1}},
        times = 5,
        payoutEnd = false,
      }
    },
    validator = { "always" },
    faction = "peasants"
  },
  {
    identifier = "peasant_cropdeath",
    issue = {
      type = "problem",
      name = "Withering crops",
      options = {
        {
          name = "Help them, any way you can",
          needs = { {"faith"}, {"wealth"} },
          gains = {{"score", 5}},
        }
      },
      default = {
        name = "Leave the crops to sort themselves out.",
        gains = {{"power", "peasants", -1}, {"lose_resource", "food"}}
      },
    },
    validator = { "seasonal", "spring" },
    faction = "peasants"
  },
  {
    identifier = "peasant_cropdeath2",
    issue = {
      type = "problem",
      name = "Swarms of Locust",
      options = {
        {
          name = "Do whatever it takes!",
          needs = { {"faith"}, {"wealth"}, {"wealth"}, {"food"} },
          gains = {{"score", 25}},
        },
      },
      default = {
        name = "Every man for himself.",        
        gains = {{"power", "peasants", -2}, {"lose_resource", "food"}, {"lose_resource", "food"}}
      }
    },
    validator = { "AND", {{"rare"}, {"seasonal", "spring"} }},
    faction = "peasants"
  },
  {
    identifier = "peasant_landdispute",
    issue = {
      type = "problem",
      name = "Land disputes",
      options = {
        {
          name = "Oversee the dispute, enforce the judgement.",
          needs = { {"official"},{"might"} },
          gains = {{"score", 10}, {"standing", "peasants", 1}},
          times = 3,
        },
        {
          name = "Judge swiftly, and harshly.",
          needs = {{"might"},{"might"}},
          gains = {{"score", 10}}
        },
      },
      ignorable = {
        times = 4,
        gains = {}
      },
      default = {
        name = "Let them settle their own disputes.",
        gains = {{"score", -10}, {"power", "peasants", -1}},
      },      
    },
    validator = { "rare" },
    faction = "peasants"
  }
}

return potentials