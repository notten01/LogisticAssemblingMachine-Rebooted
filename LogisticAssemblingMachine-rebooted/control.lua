global.ControlMap = global.ControlMap or {}

rotation = 0

-- custom functions
function newLam (entity, input, output, inserterA, inserterB, power)
    lam = {assembler = entity, inputchest = input, outputchest = output, activeRecipe = nil, inserterA = inserterA, inserterB = inserterB, power = power}
    return lam
end

function updateLam(lam)
    if (lam.assembler == nil) then
        log("None existing (nil) Lam attempting to update logsitcs settings!")
        return;
    end

    recipe = lam.assembler.get_recipe()
    
    if (recipe == nil and lam.activeRecipe == nil) then
        return --idle and remains idle
    end
    
    if (recipe == nil and lam.activeRecipe ~= nil) then
        clearLamRequest(lam)
        lam.activeRecipe = nil
    elseif (recipe ~= nil and lam.activeRecipe == nil) then
        setLogistics(lam, recipe)
    elseif (recipe.name ~= lam.activeRecipe) then
        clearLamRequest(lam)
        setLogistics(lam, recipe)
    end
end

function removeLam(lam) 
    -- don't destroy the assembler, the game will do that itself!
    lam.inputchest.destroy()
    lam.outputchest.destroy()
    lam.activeRecipe = nil
    lam.inserterA.destroy()
    lam.inserterB.destroy()
    lam.power.destroy()
end

function clearLamRequest(lam)
    -- clear logistic requests
    for i = lam.inputchest.request_slot_count, 1, -1 do
        lam.inputchest.clear_request_slot(i)
    end
    -- make the chest 'sneeze'
    for name, count in pairs(lam.inputchest.get_inventory(defines.inventory.chest).get_contents()) do
        lam.inputchest.surface.spill_item_stack(lam.inputchest.position, {name = name, count = count}, false, lam.inputchest.force, false)
    end
    lam.inputchest.clear_items_inside()
end

function setLogistics(lam, recipe)
    i = 1
    for _, v in pairs(recipe.ingredients) do
        if v.type == "item" then
            lam.inputchest.set_request_slot({name = v.name, count=v.amount}, i)
            i = i+1
        end
    end
    lam.activeRecipe = recipe.name
end

-- game functions

local function on_placement( entity )
   local ins20 = entity.surface.create_entity{name="assembling-provider", position={(entity.position.x)+1,(entity.position.y)-0.8}, force=entity.force}
   ins20.destructible = false
   
   local ins21 = entity.surface.create_entity{name="assembling-requester", position={(entity.position.x)-0.8,(entity.position.y)-0.8}, force=entity.force}
   ins21.destructible = false
   
   local ins22 = entity.surface.create_entity{name="invisible-inserter", position={(entity.position.x)-1.5,(entity.position.y)}, force=entity.force}
   ins22.destructible = false
   ins22.minable = false
   
   local ins23 = entity.surface.create_entity{name="invisible-inserter-2", position={(entity.position.x)+0.5,(entity.position.y)}, force=entity.force}
   ins23.destructible = false
   ins23.minable = false

   local ins24 = entity.surface.create_entity{name="invisible-substation", position={(entity.position.x),(entity.position.y)}, force=entity.force}
   ins24.destructible = false
   ins24.minable = false
   
   newLam = newLam(entity, ins21, ins20, ins22, ins23, ins24)
   global.ControlMap[entity.unit_number] = newLam
   
   return true
end

script.on_event(defines.events.on_built_entity, function(event)
      if (event.created_entity.name == "logistic-assembling-machine" or event.created_entity.name == "logistic-chemical-plant") then
      on_placement( event.created_entity ) end	  
end)

script.on_event(defines.events.on_robot_built_entity, function(event)
     if (event.created_entity.name == "logistic-assembling-machine" or event.created_entity.name == "logistic-chemical-plant") then
      on_placement( event.created_entity ) end	  
	    
end)

script.on_event(defines.events.script_raised_revive, function(event)
  local entity = event.entity or event.created_entity
  if (entity.name == "logistic-assembling-machine" or entity.name == "logistic-chemical-plant") then
    on_placement(entity)
  end
end)

script.on_event(defines.events.script_raised_built, function(event)
  local entity = event.entity or event.created_entity
  if (entity.name == "logistic-assembling-machine" or entity.name == "logistic-chemical-plant") then
    on_placement(entity)
  end
end)

script.on_event(defines.events.on_player_mined_entity, function(event)
    if (event.entity.name == "logistic-assembling-machine" or event.entity.name == "logistic-chemical-plant") then
        removeLam(global.ControlMap[event.entity.unit_number])
        global.ControlMap[event.entity.unit_number] = nil 
	end	
end
)

script.on_event(defines.events.on_robot_mined_entity, function(event)
    if (event.entity.name == "logistic-assembling-machine" or event.entity.name == "logistic-chemical-plant") then
        removeLam(global.ControlMap[event.entity.unit_number])
        global.ControlMap[event.entity.unit_number] = nil
    end	
end
)
  
script.on_event(defines.events.on_entity_died, function(event)
    if (event.entity.name == "logistic-assembling-machine" or event.entity.name == "logistic-chemical-plant") then
        removeLam(global.ControlMap[event.entity.unit_number])
        global.ControlMap[event.entity.unit_number] = nil 
    end	
end
)

script.on_event(defines.events.on_tick, function(event)
    if rotation < 60 then
        rotation = rotation+1
    end
    rotation = 0
    for _, lam in pairs(global.ControlMap) do
        updateLam(lam)
    end
end
)