print("[MBGWorldInfo] loaded")


-- World Age
local function getWorldAgeDays()
	local gameTime = getGameTime()
	local ageHours = gameTime:getWorldAgeHours()
	local ageDays = ageHours / 24
	
	return math.floor(ageDays)
end


-- In-game Date Time
local function getInGameDateTime()
    local gameTime = getGameTime()
	local year = gameTime:getYear()
	local month = gameTime:getMonth() + 1
	local day = gameTime:getDay() + 1
	local hour = gameTime:getHour()
	local minute = gameTime:getMinutes()
	
	return string.format("%04d-%02d-%02d %02d:%02d", year, month, day, hour, minute)
end


-- In-game Weather
local function getInGameWeather()
    local climateInstance = ClimateManager.getInstance()
    local isSnowing = climateInstance:isSnowing()
    local isRaining = climateInstance:isRaining()
	local rainIntensity = climateInstance:getRainIntensity()
	local cloudIntensity = climateInstance:getCloudIntensity()
	local fogIntensity = climateInstance:getFogIntensity()
	local windSpeed = climateInstance:getWindspeedKph()
	local temp = climateInstance:getTemperature()

    -- Weather
	local condition = "Clear"
    if isSnowing then
        if rainIntensity > 0.6 then
            condition = "Blizzard"
        else
            condition = "Snowing"
        end
    elseif isRaining then
        if rainIntensity > 0.7 then
            condition = "Heavy Rain"
        elseif rain > 0.3 then
            condition = "Rain"
        else
            condition = "Light Rain"
        end
    elseif fogIntensity > 0.5 then
        condition = "Heavy Fog"
    elseif fogIntensity > 0.2 then
        condition = "Foggy"
    elseif cloudIntensity > 0.6 then
        condition = "Overcast"
    elseif cloudIntensity > 0.3 then
        condition = "Cloudy"
    end

    -- Wind Type
    local windDesc = ""
    if windSpeed > 40 then
        windDesc = "(Strong Wind)"
    elseif windSpeed > 20 then
        windDesc = "(Windy)"
    end

    return string.format(
        "%s %s | %.1f°C",
        condition,
        windDesc,
        temp
    )
end


-- Start Print
local lastPrintTime = os.time()
local interval = 10

-- Print Interval
Events.OnTick.Add(function()
	local now = os.time()
	
	if now - lastPrintTime < interval then return end
	
	lastPrintTime = now

	local worldAge = getWorldAgeDays()
	local dateTime = getInGameDateTime()
	local weather = getInGameWeather()
	
	print(string.format("[MBGWorldInfo] World Age: %d days", worldAge))
	print(string.format("[MBGWorldInfo] Date Time: %s", dateTime))
	print(string.format("[MBGWorldInfo] Weather: %s", weather))
end)