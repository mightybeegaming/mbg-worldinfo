print('[MBGWorldInfo] loaded')

-- World Age
local function getWorldAge()
	local gameTime = getGameTime()
	local ageInHours = gameTime:getWorldAgeHours()
	local ageInDays = ageInHours / 24
	
	local worldAgeInDays = math.floor(ageInDays)
	
	return worldAgeInDays
end

-- Date Time
local function getDateTime()
    local gameTime = getGameTime()
	local year = gameTime:getYear()
	local month = gameTime:getMonth()
	local day = gameTime:getDay()
	local hour = gameTime:getHour()
	local minute = gameTime:getMinutes()

    -- Adjustments
    month = month + 1
    day = day + 1
	
	local dateTime = string.format('%04d-%02d-%02d %02d:%02d', year, month, day, hour, minute)
	
	return dateTime
end

-- Weather
local function getWeather()
    local climateInstance = ClimateManager.getInstance()
    local isSnowing = climateInstance:isSnowing()
	local snowIntensity = climateInstance:getSnowIntensity()
    local isRaining = climateInstance:isRaining()
	local rainIntensity = climateInstance:getRainIntensity()
	local cloudIntensity = climateInstance:getCloudIntensity()
	local fogIntensity = climateInstance:getFogIntensity()
	local windSpeed = climateInstance:getWindspeedKph()
	local temperature = climateInstance:getTemperature()
	local season = climateInstance:getSeasonName()
	
    -- Weather
    local weather = 'Clear'
    if isSnowing then
        if snowIntensity > 0.6 then
            weather = 'Snowing+'
        else
            weather = 'Snowing'
        end
    elseif isRaining then
        if rainIntensity > 0.7 then
            weather = 'Raining++'
        elseif rainIntensity > 0.3 then
            weather = 'Raining+'
        else
            weather = 'Raining'
        end
    elseif cloudIntensity > 0.6 then
        weather = 'Cloudy+'
    elseif cloudIntensity > 0.3 then
        weather = 'Cloudy'
    end
	
	-- Fog Type
	local fog = ''
	if fogIntensity > 0.5 then
		fog = 'Foggy+'
	elseif fogIntensity > 0.2 then
		fog = 'Foggy'
	end
	
	-- Wind Type
	local wind = ''
	if windSpeed > 40 then
		wind = 'Windy+'
	elseif windSpeed > 20 then
		wind = 'Windy'
	end

	-- Modifiers
	local modifiersList = {}
	if fog ~= '' then table.insert(modifiersList, fog) end
	if wind ~= '' then table.insert(modifiersList, wind) end

	local modifiers = ''
	if #modifiersList > 0 then
		modifiers = table.concat(modifiersList, ', ')
		modifiers = ' (' .. modifiers .. ')'
	end
	
	local weather = string.format('%s%s | %.1f | %s', weather, modifiers, temperature, season)

	return weather
end

-- Start Printing
local lastPrintTime = os.time()
local interval = 10

-- Print Interval
Events.OnTick.Add(function()
	local now = os.time()
	
	if now - lastPrintTime < interval then return end
	
	lastPrintTime = now

	local worldAge = getWorldAge()
	local dateTime = getDateTime()
	local weather = getWeather()
	
	print(string.format('[MBGWorldInfo] World Age: %d days', worldAge))
	print(string.format('[MBGWorldInfo] Date Time: %s', dateTime))
	print(string.format('[MBGWorldInfo] Weather: %s', weather))
end)