-- Reyfield SaveManager (GitHub File)
local SaveManager = {}
local HttpService = game:GetService("HttpService")

-- Folder for saving configurations
local SaveFolder = "ReyfieldConfigs"
if not isfolder(SaveFolder) then
    makefolder(SaveFolder)
end

-- Internal storage for configuration data
local Configs = {}

-- Load all configs into the dropdown
local function RefreshConfigList()
    Configs = {}
    for _, fileName in ipairs(listfiles(SaveFolder)) do
        if fileName:match("%.json$") then
            local configName = fileName:match("([^/]+)%.json$")
            table.insert(Configs, configName)
        end
    end
    return Configs
end

-- Save a configuration
function SaveManager:SaveConfig(name, data)
    local filePath = SaveFolder .. "/" .. name .. ".json"
    local jsonData = HttpService:JSONEncode(data)
    writefile(filePath, jsonData)
end

-- Load a configuration
function SaveManager:LoadConfig(name)
    local filePath = SaveFolder .. "/" .. name .. ".json"
    if isfile(filePath) then
        local jsonData = readfile(filePath)
        return HttpService:JSONDecode(jsonData)
    else
        return nil
    end
end

-- Overwrite an existing configuration
function SaveManager:OverwriteConfig(name, data)
    self:SaveConfig(name, data)
end

-- Refresh the list of available configs
function SaveManager:GetConfigList()
    return RefreshConfigList()
end

-- Set a configuration as auto-load
function SaveManager:SetAutoLoad(name)
    writefile(SaveFolder .. "/AutoLoadConfig.txt", name)
end

-- Get the auto-load configuration
function SaveManager:GetAutoLoad()
    local filePath = SaveFolder .. "/AutoLoadConfig.txt"
    if isfile(filePath) then
        return readfile(filePath)
    else
        return nil
    end
end

-- Auto-load a configuration
function SaveManager:AutoLoad()
    local autoLoadConfig = self:GetAutoLoad()
    if autoLoadConfig then
        return self:LoadConfig(autoLoadConfig)
    end
    return nil
end

return SaveManager
