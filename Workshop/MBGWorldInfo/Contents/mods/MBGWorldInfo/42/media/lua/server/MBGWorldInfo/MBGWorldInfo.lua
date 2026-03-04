print("[MBGWorldInfo] loaded")

-- World Age
local function getWorldAgeDays()
	local gameTime = getGameTime()
	local ageHours = tonumber(gameTime:getWorldAgeHours()) or 0
	local ageDays = ageHours / 24
	
	local worldAgeDays = math.floor(ageDays)
	
	return worldAgeDays
end

-- Date Time
local function getDateTime()
    local gameTime = getGameTime()
	local year = tonumber(gameTime:getYear()) or 0
	local month = tonumber(gameTime:getMonth()) or 0
	local day = tonumber(gameTime:getDay()) or 0
	local hour = tonumber(gameTime:getHour()) or 0
	local minute = tonumber(gameTime:getMinutes()) or 0

    -- Adjustments
    month = month + 1
    day = day + 1
	
	local dateTime = string.format("%04d-%02d-%02d %02d:%02d", year, month, day, hour, minute)
	
	return dateTime
end

-- Weather
local function getWeather()
    local climateInstance = ClimateManager.getInstance()
    local isSnowing = climateInstance:isSnowing() or false
    local isRaining = climateInstance:isRaining() or false
	local rainIntensity = tonumber(climateInstance:getRainIntensity()) or 0
	local cloudIntensity = tonumber(climateInstance:getCloudIntensity()) or 0
	local fogIntensity = tonumber(climateInstance:getFogIntensity()) or 0
	local windSpeed = tonumber(climateInstance:getWindspeedKph()) or 0
	local temp = tonumber(climateInstance:getTemperature()) or 0

    -- Condition
    local condition = "Clear"
    if isSnowing then
        if rainIntensity > 0.6 then
            condition = "Snow+"
        else
            condition = "Snow"
        end
    elseif isRaining then
        if rainIntensity > 0.7 then
            condition = "Rain++"
        elseif rainIntensity > 0.3 then
            condition = "Rain+"
        else
            condition = "Rain"
        end
    elseif cloudIntensity > 0.6 then
        condition = "Cloud+"
    elseif cloudIntensity > 0.3 then
        condition = "Cloud"
    end
	
	-- Modifiers
	local modifiersList = {}

	-- Fog Type
	if fogIntensity > 0.5 then
		table.insert(modifiersList, "Fog+")
	elseif fogIntensity > 0.2 then
		table.insert(modifiersList, "Fog")
	end
	
	-- Wind Type
	if windSpeed > 40 then
		table.insert(modifiersList, "Wind+")
	elseif windSpeed > 20 then
		table.insert(modifiersList, "Wind")
	end

	local modifiers = ""
	if #modifiersList > 0 then
		modifiers = table.concat(modifiersList, ", ")
		modifiers = " (" .. modifiers .. ")"
	end
	
	local weather = string.format("%s%s | %.1f", condition, modifiers, temp)

	return weather
end

-- Start Printing
local lastPrintTime = tonumber(os.time()) or 0
local interval = 10

-- Print Interval
Events.OnTick.Add(function()
	local now = tonumber(os.time()) or 0
	
	if now - lastPrintTime < interval then return end
	
	lastPrintTime = now

	local worldAgeDays = getWorldAgeDays()
	local dateTime = getDateTime()
	local weather = getWeather()
	
	print(string.format("[MBGWorldInfo] World Age: %d days", worldAgeDays))
	print(string.format("[MBGWorldInfo] Date Time: %s", dateTime))
	print(string.format("[MBGWorldInfo] Weather: %s", weather))
end)