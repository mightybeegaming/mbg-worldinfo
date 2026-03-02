print("[MBGWorldInfo] loaded")

-- World Age
local function getWorldAgeDays()
    if getGameTime() then
        local ageHours = getGameTime():getWorldAgeHours()
        return ageHours / 24
    end
    return nil
end

-- In-game Date Time
local function getInGameDateTime()
    local gt = getGameTime()
    if gt then
        local year  = gt:getYear()
        local month = gt:getMonth() + 1
        local day   = gt:getDay() + 1
        local hour  = gt:getHour()
        local minute = gt:getMinutes()
        return string.format("%04d-%02d-%02d %02d:%02d", year, month, day, hour, minute)
    end
    return "N/A"
end

-- Start Print
if isServer() then
    local lastPrintTime = os.time()
    local interval = 10 -- seconds real-life

    -- Print once on server start
    Events.OnServerStarted.Add(function()
        local ageDays = getWorldAgeDays()
        local inGameDT = getInGameDateTime()

        if ageDays then
            ageDays = math.floor(ageDays)
            print(string.format("[MBGWorldInfo] World Age: %d days", ageDays))
            print(string.format("[MBGWorldInfo] Date Time: %s", inGameDT))
        else
            print("[MBGWorldInfo] Error: Game still loading")
        end

        lastPrintTime = os.time()
    end)

    -- Print Interval
    Events.OnTick.Add(function()
        local now = os.time()
        if now - lastPrintTime >= interval then
            lastPrintTime = now

            local ageDays = getWorldAgeDays()
            local inGameDT = getInGameDateTime()

            if ageDays then
                ageDays = math.floor(ageDays)
                print(string.format("[MBGWorldInfo] World Age: %d days", ageDays))
                print(string.format("[MBGWorldInfo] Date Time: %s", inGameDT))
            else
                print("[MBGWorldInfo] Error: Game still loading")
            end
        end
    end)
end