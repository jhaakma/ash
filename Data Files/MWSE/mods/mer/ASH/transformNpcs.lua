local config = require('mer.ASH.config')

local function doTransform(ref)
    return ref.baseObject.objectType == tes3.objectType.npc
    and ref.disabled ~= true
end

local function getTransformType(ref)
    if ref.baseObject.race then
        return ref.baseObject.race.id:lower() == 'dark elf' 
            and 'ash' or 'corprus'
    end
end

local function validateObjectAgainstFilter(object, filters)
    for key, value in pairs(filters) do
        if object[key] ~= value then
            return false
        end
    end
    return true
end


local function transferItems(source, target, filters)
    for _, stack in pairs(source.object.inventory) do
        if stack.object.canCarry ~= false then
            if validateObjectAgainstFilter(stack.object, filters) then
                tes3.transferItem{from=source, to=target, item=stack.object, count=stack.count}
            end
        end
    end
end

local function createCreatureRef(npc, creatureList)
    local creatureId = table.choice(creatureList)
    return tes3.createReference{
        object = creatureId,
        position = npc.position:copy(),
        orientation = npc.orientation:copy(),
        cell = npc.cell
    }
end

local function transferInventory(npc, creature)
    for _, filter in ipairs(config.itemFilters) do
        transferItems(npc, creature, filter)
    end
end

local function removeNPC(npc)
    mwscript.disable({reference = npc, modify = true})
    npc.mobile:stopCombat()
    npc.mobile.fight = 0
    npc.object.aiConfig.fight = 0
    mwscript.setDelete{ reference = npc, delete = true}
end

local function addItems(npc, creature) 
    local items = config.newItems[npc.baseObject.id:lower()]
    if not items then return end
    for _, item in ipairs(items) do
        tes3.addItem{
            reference = creature,
            item = item,
            updateGUI = false
        }
    end
end

local function addData(npc, creature)
    creature.data.npcName = npc.object.name
    creature.data.npcRef = npc
end

local function handleNPCTransformation(e)
    local creatureList = config.creatures[getTransformType(e.reference)]
    if doTransform(e.reference) and creatureList then
        local npc = e.reference
        local creature = createCreatureRef(npc, creatureList)
        transferInventory(npc, creature)
        addItems(npc, creature)
        addData(npc, creature)
        removeNPC(npc)
    end
end

event.register("mobileActivated", handleNPCTransformation)

