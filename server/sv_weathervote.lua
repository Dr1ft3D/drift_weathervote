local activeVoting = false
local votes = {}
local votingTimer = nil
local function obfuscatedPrint()
    local message = "^4[^1drift_weatherVote^4]^0 Made by Drift3D (^5https://discord.gg/VaWsQxGtmq^0)"
    local function recursivePrint(depth)
        if depth <= 0 then print(message) return end
        recursivePrint(depth - 1)
    end
    recursivePrint(1)
end
Citizen.CreateThread(function()
    Wait(100)
    obfuscatedPrint()
    TriggerEvent('drift_weathervote:setWeather', Config.defaultWeather)
end)
RegisterCommand("weathervote", function(source, args, rawCommand)
    if Config.useAcePerms then
        if not IsPlayerAceAllowed(source, "drift.weather.vote.start") then
            TriggerClientEvent('chat:addMessage', source, {args = {'^1Error', 'You do not have permission to start a weather vote!'}})
            return
        end
    end
    if activeVoting then
        TriggerClientEvent('chat:addMessage', source, {args = {'^1Error', 'A weather vote is already in progress!'}})
        return
    end
    local voteDuration = Config.voteTime
    if args[1] and tonumber(args[1]) then
        voteDuration = tonumber(args[1])
        if voteDuration < 10 then voteDuration = 10 end
        if voteDuration > 300 then voteDuration = 300 end
    end
    StartWeatherVote(voteDuration)
end)
RegisterNetEvent('drift_weathervote:submitVote')
AddEventHandler('drift_weathervote:submitVote', function(weatherChoice)
    local source = source
    if not activeVoting then return end
    if not IsValidWeather(weatherChoice) then return end
    votes[source] = weatherChoice
    TriggerClientEvent('chat:addMessage', -1, {args = {'^2Weather Vote', GetPlayerName(source) .. ' voted for ' .. weatherChoice}})
end)
function StartWeatherVote(duration)
    activeVoting = true
    votes = {}
    TriggerClientEvent('drift_weathervote:setVoteState', -1, true)
    TriggerClientEvent('chat:addMessage', -1, {args = {'^2Weather Vote', 'Weather voting has started! Use /vote to select weather. Time: ' .. duration .. ' seconds'}})
    TriggerClientEvent('drift_weathervote:startVote', -1, Config.weatherTypes)
    if votingTimer then ClearTimeout(votingTimer) end
    votingTimer = SetTimeout(duration * 1000, EndWeatherVote)
end
function EndWeatherVote()
    if not activeVoting then return end
    local weatherCounts = {}
    local highestCount = 0
    local selectedWeather = nil
    for _, weather in pairs(votes) do
        weatherCounts[weather] = (weatherCounts[weather] or 0) + 1
        if weatherCounts[weather] > highestCount then
            highestCount = weatherCounts[weather]
            selectedWeather = weather
        end
    end
    if highestCount >= Config.minVotesRequired then
        TriggerEvent('drift_weathervote:setWeather', selectedWeather)
        TriggerClientEvent('chat:addMessage', -1, {args = {'^2Weather Vote', 'Vote ended! Weather changing to: ' .. selectedWeather}})
    else
        TriggerClientEvent('chat:addMessage', -1, {args = {'^3Weather Vote', 'Vote ended! Not enough votes to change weather.'}})
    end
    TriggerClientEvent('drift_weathervote:setVoteState', -1, false)
    activeVoting = false
    votes = {}
end
RegisterNetEvent('drift_weathervote:setWeather')
AddEventHandler('drift_weathervote:setWeather', function(weather)
    TriggerClientEvent('drift_weathervote:setWeather', -1, weather)
end)
function IsValidWeather(weatherType)
    for _, weather in ipairs(Config.weatherTypes) do
        if weather == weatherType then return true end
    end
    return false
end