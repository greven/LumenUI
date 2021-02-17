local A, ns = ...

local E, D, C, M, L, P = {}, {}, {}, {}, {}, {} -- Engine, Defaults, Config, Media, Locale, Private
ns.E, ns.D, ns.C, ns.M, ns.L, ns.P = E, D, C, M, L, P

_G[A] = {
    [1] = ns.E,
    [2] = ns.M,
    [3] = ns.C,
    [4] = ns.L
}

D.global, D.profile = {}, {} -- Defaults

-- Lua
local _G = getfenv(0)
local assert = _G.assert
local next = _G.next
local pairs = _G.pairs
local xpcall = _G.xpcall
local t_insert = _G.table.insert
local s_split = _G.string.split
local s_format = _G.string.format
local CreateFrame = _G.CreateFrame
local geterrorhandler = _G.geterrorhandler

-- ---------------

local function errorHandler(err)
    return geterrorhandler()(err)
end

function E:Call(func, ...)
    return xpcall(func, errorHandler, ...)
end

-- ---------------
-- > Modules
-- ---------------

do
    local modules = {}

    function P:AddModule(name)
        modules[name] = {}
        return modules[name]
    end

    function P:GetModule(name)
        return modules[name]
    end

    function P:InitModules()
        for _, module in next, modules do
            E:Call(module.Init, module)
        end
    end

    function P:UpdateModules()
        for _, module in next, modules do
            if module.Update then
                E:Call(module.Update, module)
            end
        end
    end
end

-- ---------------
-- > Events
-- ---------------

do
    local oneTimeEvents = {ADDON_LOADED = false, PLAYER_LOGIN = false}
    local registeredEvents = {}

    local dispatcher = CreateFrame("Frame")
    dispatcher:SetScript(
        "OnEvent",
        function(_, event, ...)
            for func in pairs(registeredEvents[event]) do
                func(...)
            end

            if oneTimeEvents[event] == false then
                oneTimeEvents[event] = true
            end
        end
    )

    function E:RegisterEvent(event, func)
        assert(not oneTimeEvents[event], s_format("Failed to register for '%s' event, already fired!", event))

        if not registeredEvents[event] then
            registeredEvents[event] = {}

            dispatcher:RegisterEvent(event)
        end

        registeredEvents[event][func] = true
    end

    function E:UnregisterEvent(event, func)
        local funcs = registeredEvents[event]

        if funcs and funcs[func] then
            funcs[func] = nil

            if not next(funcs) then
                registeredEvents[event] = nil

                dispatcher:UnregisterEvent(event)
            end
        end
    end
end

-- ------------------
-- > Addon Specific
-- ------------------

do
    local onLoadTasks = {}

    hooksecurefunc(
        "LoadAddOn",
        function(name)
            local tasks = onLoadTasks[name]

            if tasks then
                if not IsAddOnLoaded(name) then
                    return
                end

                for i = 1, #tasks do
                    tasks[i]()
                end
            end
        end
    )

    function E:AddOnLoadTask(name, func)
        onLoadTasks[name] = onLoadTasks[name] or {}
        t_insert(onLoadTasks[name], func)
    end
end

-- ------------------
-- > Slash Commands
-- ------------------

do
    local commands = {}

    SLASH_LUMUI1 = "/lumui"
    SlashCmdList["LUMUI"] = function(msg)
        msg = msg:gsub("^ +", "")
        local command, arg = s_split(" ", msg, 2)
        arg = arg and arg:gsub(" ", "")

        if commands[command] then
            commands[command].func(arg)
        end
    end

    function P:AddCommand(command, handler, desc)
        commands[command] = {func = handler, desc = desc or "no description"}
    end
end
