Config = {
    voteTime = 60, -- Leave this at 60
    weatherTypes = { -- The list of weather types that can be changed to
        "CLEAR",
        "CLOUDS",
        "SMOG",
        "FOGGY",
        "OVERCAST",
        "RAIN",
        "THUNDER",
        "CLEARING",
        "NEUTRAL"
    },
    minVotesRequired = 2, -- This is the min ammout of votes that need to be made in order for the vote system to be used
    defaultWeather = "CLEAR", --  This is the default weather to be set when the server is statrted
    useAcePerms = false  -- Set this to true if you want the /weathervote command to be restricted
} 