return {
    creatures = {
        corprus = {
            'corprus_stalker',
            'corprus_lame',
        },
        ash = {
            'ash_slave',
            'ash_ghoul',
            'ash_zombie'
        }
    },
    --Types of items to be transferred from NPC to Creature
    itemFilters = {
        {   
            --Keys
            objectType = tes3.objectType.miscItem,
            isKey = true
        },
        {
            --Repair Items
            objectType = tes3.objectType.repairItem
        },
        {
            --Notes - TODO: Remove this once Endoran has added new ones
            objectType = tes3.objectType.book,
            type = 1,
            value = 1
        },
        {
            --Lockpicks
            objectType = tes3.objectType.lockpick
        },
        {
            --Probes
            objectType = tes3.objectType.probe
        },
    },
    --New items to be added to creature
    newItems = {
        lowercase_npc_id = { "gold_001", "misc_com_bottle_10"}
    }
}