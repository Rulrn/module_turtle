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
    - print_3D(mot)
    - drop in chest (position, all, slots, item)
	- blame
--]]

-- constants
ALL_COALS = {"minecraft:coal", "minecraft:charcoal", "minecraft:coal_block"}
ALL_FUELS = {
    "minecraft:lava_bucket",
    "minecraft:coal",
    "minecraft:charcoal",
    "minecraft:coal_block",
    "minecraft:blaze_rod",
    "minecraft:oak_sapling",
    "minecraft:spruce_sapling",
    "minecraft:birch_sapling",
    "minecraft:jungle_sapling",
    "minecraft:acacia_sapling",
    "minecraft:dark_oak_sapling",
    "minecraft:oak_planks",
    "minecraft:spruce_planks",
    "minecraft:birch_planks",
    "minecraft:jungle_planks",
    "minecraft:acacia_planks",
    "minecraft:dark_oak_planks",
    "minecraft:oak_log",
    "minecraft:spruce_log",
    "minecraft:birch_log",
    "minecraft:jungle_log",
    "minecraft:acacia_log",
    "minecraft:dark_oak_log",
    "minecraft:stick"
}
FUEL_VALUES = {
    ["minecraft:lava_bucket"] = 100,
    ["minecraft:coal"] = 80,
    ["minecraft:charcoal"] = 80,
    ["minecraft:coal_block"] = 800,
    ["minecraft:blaze_rod"] = 120,
    ["minecraft:oak_sapling"] = 5,
    ["minecraft:spruce_sapling"] = 5,
    ["minecraft:birch_sapling"] = 5,
    ["minecraft:jungle_sapling"] = 5,
    ["minecraft:acacia_sapling"] = 5,
    ["minecraft:dark_oak_sapling"] = 5,
    ["minecraft:oak_planks"] = 15,
    ["minecraft:spruce_planks"] = 15,
    ["minecraft:birch_planks"] = 15,
    ["minecraft:jungle_planks"] = 15,
    ["minecraft:acacia_planks"] = 15,
    ["minecraft:dark_oak_planks"] = 15,
    ["minecraft:oak_log"] = 960,
    ["minecraft:spruce_log"] = 960,
    ["minecraft:birch_log"] = 960,
    ["minecraft:jungle_log"] = 960,
    ["minecraft:acacia_log"] = 960,
    ["minecraft:dark_oak_log"] = 960,
    ["minecraft:stick"] = 5
}
GRAVITY = {
    ["minecraft:gravel"] = true,
    ["minecraft:sand"] = true,
    ["minecraft:red_sand"] = true,
    ["minecraft:anvil"] = true,
    ["minecraft:chipped_anvil"] = true,
    ["minecraft:damaged_anvil"] = true,
    ["minecraft:white_concrete_powder"] = true,
    ["minecraft:orange_concrete_powder"] = true,
    ["minecraft:magenta_concrete_powder"] = true,
    ["minecraft:light_blue_concrete_powder"] = true,
    ["minecraft:yellow_concrete_powder"] = true,
    ["minecraft:lime_concrete_powder"] = true,
    ["minecraft:pink_concrete_powder"] = true,
    ["minecraft:gray_concrete_powder"] = true,
    ["minecraft:light_gray_concrete_powder"] = true,
    ["minecraft:cyan_concrete_powder"] = true,
    ["minecraft:purple_concrete_powder"] = true,
    ["minecraft:blue_concrete_powder"] = true,
    ["minecraft:brown_concrete_powder"] = true,
    ["minecraft:green_concrete_powder"] = true,
    ["minecraft:red_concrete_powder"] = true,
    ["minecraft:black_wool_concrete_powder"] = true,
    ["minecraft:dragon_egg"] = true
}

-- inventory

function slot(n)
    turtle.select(n)
    return turtle.getItemDetail(n)
end

function isInventoryFull()
    for i=1, 16 do
        if t.getItemCount(i) == 0 then
            return false
        end
    end
    return true
end

function selectItem(name)
    for i=1, 16 do
        local data = turtle.getItemDetail(i)
        if data and data.name == name then
            turtle.select(i)
            return true
        end
    end
    return false
end

function getItemCount(name)
    local count = 0
    for i=1, 16 do
        local data = turtle.getItemDetail(i)
        if data and data.name == name then
            count = count + data.count
        end
    end
    return count
end

function dropItem(name)
    for i=1, 16 do
        details = turtle.getItemDetail(i)
    
        if details and details.name == name then
            turtle.select(i)
            turtle.drop()
        end
    end
end

function stackItems()
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

function smartRefuel(combustible, n)
    local n = n or 1
    local fuels = {}
    local prevCursor = turtle.getSelectedSlot()

    for k, v in ipairs(combustible) do
        fuels[v] = true
    end

    local initFuel = turtle.getFuelLevel()
    local currFuel = initFuel
    for i=1, 16 do
        turtle.select(i)
        item = turtle.getItemDetail()
        if item and fuels[item.name] then
            local fuelValue = FUEL_VALUES[item.name]
            local missingFuel = n-(currFuel-initFuel)
            turtle.refuel(math.ceil(missingFuel/fuelValue))
            currFuel = turtle.getFuelLevel()
            if currFuel - initFuel >= n then
              turtle.select(prevCursor)
              return true
            end
        end
    end
    turtle.select(prevCursor)
    return false
end

-- movements
function enoughtFuel(n)
	if turtle.getFuelLevel() <= n then
		return false
	else
		return true
	end
end


    -- back is risky to use because we can't know if the way is clear
function back(n)
    n = n or 1
    for i=1, n do
        if not turtle.back() then
            return false
        end
    end
    return true
end

function forward(n)
    n = n or 1
    for i=1, n do
        if not turtle.forward() then
            return false
        end
    end
    return true
end

function up(n)
    n = n or 1
    for i=1, n do
        if not turtle.up() then
            return false
        end
    end
    return true
end

function down(n)
    n = n or 1
    for i=1, n do
        if not turtle.down() then
            return false
        end
    end
    return true
end

function digForward(n)
	n = n or 1
	for i=1, n do
		if turtle.detect() then
			turtle.dig()
		end
		while GRAVITY[select(2, turtle.inspect()).name] do
			turtle.dig()
		end
		turtle.forward()
	end
	return true
end

function digUp(n)
	n = n or 1
	for i=1, n do
		if  turtle.detectUp() then
			turtle.digUp()
		end
		while GRAVITY[select(2, turtle.inspectUp()).name] do
			turtle.digUp()
		end
		turtle.up()
	end
	return true
end

function digDown(n)
	n = n or 1
	for i=1, n do
		if  turtle.detectDown() then
			turtle.digDown()
		end
		turtle.down()
	end
	return true
end

	-- the turtle will go to the coordonates, knowing that the turtle is at
	-- (0,0,0) and +x is in front, +y is on the right and +z is on the top 
function goTo(x,y,z)
	local dir = 0
	local temp_flip = false
	-- x
	if x >= 0 then
		forward(x)
	else
		flip()
		forward(math.abs(x))
		dir = dir + 2
		temp_flip = true
	end
	-- y
	if y == 0 then
		-- :^)
	elseif (y >= 0 and not temp_flip) or (y <=0 and temp_flip) then
		turtle.turnRight()
		forward(math.abs(y))
		dir = dir +1
	else
		turtle.turnLeft()
		forward(math.abs(y))
		dir = dir -1
	end	
	-- z
	if z >= 0 then
		up(z)
	else
		down(math.abs(z))
	end
	-- return to initial orientation
	if dir >= 0 and dir ~= 3 then
		for i=1, dir do
			turtle.turnLeft()
		end
	else
		turtle.turnRight()
	end
	return true
end

function flip()
    turtle.turnLeft()
    turtle.turnLeft()
	return true
end

-- function create

--volume(length, width, height, bool(turtle dig down or up))
function volume(l,w,h, down)
	-- case where we want to dig down
	down = down or false
	local down_h = -1
	
	local fuel_max = l*w*h + l+w+h+1

	--going back to the initial position of the turtle
	local t_x = 0
	local t_y = 0
	local t_z = h
	
	local way = 1
	
	local forward = true
	local right = true
	
	--only positive parameters
	if l <= 0 or w <= 0 or h <= 0 then
		print("!!! only positive parameters!!!")
		return false
	end
	
	--enough fuel
	if not enoughtFuel(fuel_max) then
		local fuel = fuel_max - turtle.getFuelLevel()
		print("need "..fuel.." fuel, knowing 1 coal is 80 fuel")
		return false
	end
	
	--cycle
	digForward()
	if down then
		digDown()
		down_h = 1
		t_z = h+3
	end
	for i=1, h do
		--start layer
		for j=1, w-1 do
			digForward(l-1)
			if j%2==way then
				turtle.turnRight()
				digForward()
				turtle.turnRight()
			else
				turtle.turnLeft()
				digForward()
				turtle.turnLeft()
			end
			forward = not forward
		end
		digForward(l-1)
		if w%2 == 0 then
			way = 1 - way
		end
		--end layer
		if i ~= h then 
			if down then 
				digDown()
			else
				digUp()
			end
			flip()
			forward = not forward
			right = not right
		end
	end
	-- back home
	if not forward then
		flip()
	end
	
	if forward and right then
		goTo(-(l-1),-(w-1), down_h*(t_z-1))
	elseif forward and not right then
		goTo(-(l-1),0,down_h*(t_z-1))
	elseif not forward and right then
		goTo(0,-(w-1),down_h*(t_z-1))
	elseif not forward and not right then
		goTo(0,0,down_h*(t_z-1))
	end
	turtle.back()
end

	-- line(n) dig a length*heigh line in front of the turtle
function line(l, h, down)
	local m = l*h
	
	if enoughtFuel(m) then
		volume(l,1,h, down)
		return true
	else 
		local fuel = (l*h) - turtle.getFuelLevel()
		print("need "..fuel.." fuel, knowing 1 coal is 80 fuel")
		return false
	end
end

-- test
