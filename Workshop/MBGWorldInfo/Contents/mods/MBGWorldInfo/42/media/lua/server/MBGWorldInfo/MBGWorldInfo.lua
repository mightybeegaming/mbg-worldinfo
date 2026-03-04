print('[MBGWorldInfo] loaded')

-- World Age
local function getWorldAgeDays()
	local gameTime = getGameTime()
	local ageHours = gameTime:getWorldAgeHours()
	local ageDays = ageHours / 24
	
	local worldAgeDays = math.floor(ageDays)
	
	return worldAgeDays
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
    local isRaining = climateInstance:isRaining()
	local rainIntensity = climateInstance:getRainIntensity()
	local cloudIntensity = climateInstance:getCloudIntensity()
	local fogIntensity = climateInstance:getFogIntensity()
	local windSpeed = climateInstance:getWindspeedKph()
	local temp = climateInstance:getTemperature()

    -- Condition
    local condition = 'Clear'
    if isSnowing then
        if rainIntensity > 0.6 then
            condition = 'Snow+'
        else
            condition = 'Snow'
        end
    elseif isRaining then
        if rainIntensity > 0.7 then
            condition = 'Rain++'
        elseif rainIntensity > 0.3 then
            condition = 'Rain+'
        else
            condition = 'Rain'
        end
    elseif cloudIntensity > 0.6 then
        condition = 'Cloud+'
    elseif cloudIntensity > 0.3 then
        condition = 'Cloud'
    end
	
	-- Fog Type
	local fog = ''
	if fogIntensity > 0.5 then
		fog = 'Fog+'
	elseif fogIntensity > 0.2 then
		fog = 'Fog'
	end
	
	-- Wind Type
	local wind = ''
	if windSpeed > 40 then
		wind = 'Wind+'
	elseif windSpeed > 20 then
		wind = 'Wind'
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
	
	local weather = string.format('%s%s | %.1f', condition, modifiers, temp)

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

	local worldAgeDays = getWorldAgeDays()
	local dateTime = getDateTime()
	local weather = getWeather()
	
	print(string.format('[MBGWorldInfo] World Age: %d days', worldAgeDays))
	print(string.format('[MBGWorldInfo] Date Time: %s', dateTime))
	print(string.format('[MBGWorldInfo] Weather: %s', weather))
end)