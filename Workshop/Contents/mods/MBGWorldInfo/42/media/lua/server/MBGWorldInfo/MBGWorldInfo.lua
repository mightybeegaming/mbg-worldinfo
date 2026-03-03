print("[MBGWorldInfo] loaded")

-- World Age
local function getWorldAgeDays()
	local gameTime = getGameTime()

    -- if not gameTime then return end

	local ageHours = tonumber(gameTime:getWorldAgeHours()) or 0
	local ageDays = ageHours / 24
	
	return math.floor(ageDays)
end

-- In-game Date Time
local function getInGameDateTime()
    local gameTime = getGameTime()
    
    -- if not gameTime then return end

	local year = tonumber(gameTime:getYear()) or 0
	local month = tonumber(gameTime:getMonth()) or 0
	local day = tonumber(gameTime:getDay()) or 0
	local hour = tonumber(gameTime:getHour()) or 0
	local minute = tonumber(gameTime:getMinutes()) or 0

    -- Adjustments
    month = month + 1
    day = day + 1
	
	return string.format("%04d-%02d-%02d %02d:%02d", year, month, day, hour, minute)
end

-- In-game Weather
local function getInGameWeather()
    local climateInstance = ClimateManager.getInstance()

    -- if not climateInstance then return end

    local isSnowing = climateInstance:isSnowing() or false
    local isRaining = climateInstance:isRaining() or false
	local rainIntensity = tonumber(climateInstance:getRainIntensity()) or 0
	local cloudIntensity = tonumber(climateInstance:getCloudIntensity()) or 0
	local fogIntensity = tonumber(climateInstance:getFogIntensity()) or 0
	local windSpeed = tonumber(climateInstance:getWindspeedKph()) or 0
	local temp = tonumber(climateInstance:getTemperature()) or 0

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
        windDesc = " (Strong Wind)"
    elseif windSpeed > 20 then
        windDesc = " (Windy)"
    end

    return string.format(
        "%s%s | %.1f",
        condition,
        windDesc,
        temp
    )
end

-- Start Print
-- if not isServer() then return end

local lastPrintTime = tonumber(os.time()) or 0
local interval = 10

-- Print Interval
Events.OnTick.Add(function()
	local now = tonumber(os.time()) or 0
	
	if now - lastPrintTime < interval then return end
	
	lastPrintTime = now

	local worldAge = getWorldAgeDays()
	local dateTime = getInGameDateTime()
	local weather = getInGameWeather()
	
	print(string.format("[MBGWorldInfo] World Age: %d days", worldAge))
	print(string.format("[MBGWorldInfo] Date Time: %s", dateTime))
	print(string.format("[MBGWorldInfo] Weather: %s", weather))
end)