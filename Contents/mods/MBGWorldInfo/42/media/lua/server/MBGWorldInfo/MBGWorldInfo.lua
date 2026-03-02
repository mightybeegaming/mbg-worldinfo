print("[MBGWorldInfo] loaded")


-- World Age
local function getWorldAgeDays()
	local gameTime = getGameTime()
	
    if not gameTime then return end
	
	local ageHours = gameTime:getWorldAgeHours()
	local ageDays = ageHours / 24
	
	return ageDays
end


-- In-game Date Time
local function getInGameDateTime()
    local gameTime = getGameTime()
	
    if not gameTime then return end
	
	local year = gameTime:getYear()
	local month = gameTime:getMonth() + 1
	local day = gameTime:getDay() + 1
	local hour = gameTime:getHour()
	local minute = gameTime:getMinutes()
	
	return string.format("%04d-%02d-%02d %02d:%02d", year, month, day, hour, minute)
end


-- Start Print
if not isServer() then return end

local lastPrintTime = os.time()
local interval = 10

-- Print Interval
Events.OnTick.Add(function()
	local now = os.time()
	
	if now - lastPrintTime < interval then return end
	
	lastPrintTime = now

	local ageDays = getWorldAgeDays()
	local inGameDT = getInGameDateTime()

	if not ageDays then
		print("[MBGWorldInfo] Error: Game still loading")
	end
	
	ageDays = math.floor(ageDays)
	
	print(string.format("[MBGWorldInfo] World Age: %d days", ageDays))
	print(string.format("[MBGWorldInfo] Date Time: %s", inGameDT))
end)