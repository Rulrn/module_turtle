------------------------------------------------------------------
--              Symplified module for turtle                    --
--               By Rulrn and Phlimy (SpaVec)                   --
--                                                              --
-- This module should simplify the call of basic functions           --
-- in addition to offering additional functions.                --
--                                                                --    
--                              version : 1.16.4                    --
------------------------------------------------------------------
    
    
--[[
    - ligne(n)
    - print_3D(mot)
    - drop in chest (position, all, slots, item)
--]]

local u = require("util")
local t = {}
setmetatable(t, {__index = turtle})

-- variables 
t.ALL_COALS = {"minecraft:coal", "minecraft:charcoal"}
    -- a finir si besoin
t.ALL_FUELS = {
    "minecraft:planks", "minecraft:coal", "minecraft:charcoal"
}
t.FUEL_VALUES = {
    ["minecraft:lava_bucket" ] = 1000,
    ["minecraft:coal"		 ] = 80,
    ["minecraft:charcoal"	 ] = 80, 
    ["minecraft:blaze_rod"   ] = 120,
    ["minecraft:oak_planks"  ] = 15,
    ["minecraft:red_mushroom"] = 15,
    ["minecraft:sticks"      ] = 5, 
    ["minecraft:coal_block"  ] = 800
}
-- inventory

function t.slot(n)
    turtle.select(n)
    return turtle.getItemDetail(n)
end

function t.isInventoryFull()
    for i=1, 16 do
        if t.getItemCount(i) == 0 then
            return false
        end
    end
    return true
end

function t.selectItem(name)
    for i=1, 16 do
        local data = turtle.getItemDetail(i)
        if data and data.name == name then
            turtle.select(i)
            return true
        end
    end
    return false
end

function t.getItemCount(name)
    local count = 0
    for i=1, 16 do
        local data = turtle.getItemDetail(i)
        if data and data.name == name then
            count = count + data.count
        end
    end
    return count
end

function t.dropItem(name)
    for i=1, 16 do
        details = turtle.getItemDetail(i)
    
        if details and details.name == name then
            turtle.select(i)
            turtle.drop()
        end
    end
end

function t.stackItems()
    -- Remember seen items
    local m = {}
    for i=1, 16 do
        local this = turtle.getItemDetail(i)
        if this ~= nil then
            -- Slot is not empty
            local saved = m[this.name]
            if saved ~= nil then
                -- We've seen this item before in the inventory
                local amount = this.count
                turtle.select(i)
                turtle.transferTo(saved.slot)
                if amount > saved.space then
                    -- We have leftovers, and now the
                    -- saved slot is full, so we replace
                    -- it by the current one
                    saved.slot = i
                    saved.count = amount - saved.space
                    -- Update on table.
                    m[this.name] = saved
                elseif amount == saved.space then
                    m[this.name] = nil -- Just delete the entry
                end
            else
                -- There isn't another slot with this
                -- item so far, so sign this one up.
                this.slot = i
                this.space = turtle.getItemSpace(i)
                m[this.name] = this
            end
        end
    end
end

function t.smartRefuel(combustible, n)
    local n = n or 1
    local fuels = {}
    local prevCursor = t.getSelectedSlot()

    for k, v in ipairs(combustible) do
        fuels[v] = true
    end

    local initFuel = t.getFuelLevel()
    local currFuel = initFuel
    for i=1, 16 do
        t.select(i)
        item = turtle.getItemDetail()
        if item and fuels[item.name] then
            local fuelValue = t.FUEL_VALUES[item.name]
            local missingFuel = n-(currFuel-initFuel)
            turtle.refuel(math.ceil(missingFuel/fuelValue))
            currFuel = t.getFuelLevel()
            if currFuel - initFuel >= n then
              t.select(prevCursor)
              return true
            end
        end
    end
    t.select(prevCursor)
    return false
end

-- movements

    -- back is risky to use because we can't know if the way is clear
function t.back(n)
    n = n or 1
    for i=1, n do
        if not turtle.back() then
            return false
        end
    end
    return true
end

function t.forward(n)
    n = n or 1
    for i=1, n do
        if not turtle.forward() then
            return false
        end
    end
    return true
end

function t.up(n)
    n = n or 1
    for i=1, n do
        if not turtle.up() then
            return false
        end
    end
    return true
end

function t.down(n)
    n = n or 1
    for i=1, n do
        if not turtle.down() then
            return false
        end
    end
    return true
end

function go_to(x,y,z)
    
end

function t.flip()
    turtle.turnLeft()
    turtle.turnLeft()
end

-- function create


-- test

function test()
    print(t.smartRefuel(t.ALL_COALS, 5000))
end

test()
