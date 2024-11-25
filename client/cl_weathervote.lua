local availableWeathers = {}
local activeVoting = false
RegisterNetEvent('drift_weathervote:setWeather')
AddEventHandler('drift_weathervote:setWeather', function(weather)
    SetWeatherTypeOverTime(weather, 15.0)
    Wait(15000)
    SetWeatherTypePersist(weather)
    SetWeatherTypeNow(weather)
    SetWeatherTypeNowPersist(weather)
end)
RegisterNetEvent('drift_weathervote:setVoteState')
AddEventHandler('drift_weathervote:setVoteState', function(state)
    activeVoting = state
end)
RegisterCommand('vote', function(source, args, rawCommand)
    if not activeVoting then
        TriggerEvent('chat:addMessage', {
            args = { '^1Error', 'There is no active weather vote!' }
        })
        return
    end
    local menuOptions = {}
    for _, weather in ipairs(availableWeathers) do
        table.insert(menuOptions, {
            title = weather,
            description = 'Click to vote for ' .. weather,
            onSelect = function()
                TriggerServerEvent('drift_weathervote:submitVote', weather)
                lib.hideContext()
            end
        })
    end
    lib.registerContext({
        id = 'weather_vote_menu',
        title = 'Vote for Weather',
        menu = 'weather_vote_menu',
        options = menuOptions
    })
    lib.showContext('weather_vote_menu')
end)
RegisterNetEvent('drift_weathervote:startVote')
AddEventHandler('drift_weathervote:startVote', function(weathers)
    availableWeathers = weathers
    local weatherList = table.concat(weathers, ", ")
    TriggerEvent('chat:addMessage', {
        args = { '^2Available Weather Types', weatherList }
    })
end)
TriggerEvent('chat:addSuggestion', '/vote', 'Open weather voting menu')
TriggerEvent('chat:addSuggestion', '/weathervote', 'Start a weather voting session', {
    { name = "seconds", help = "Duration of voting period (10-300 seconds)" }
})