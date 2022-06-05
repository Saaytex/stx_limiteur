ESX = nil

------ FONCTIONNALITÉS
local toucheslimiteur = true
local menulimiteur = true

------ 
local elements = {}
local isInVehicle = false
speed = 0
local regulateur = -10

------ TOUCHES
local activlimiteur = 314    ------- +
local desactivlimiteur = 315 ------- -       | Pour changer les touches : https://docs.fivem.net/docs/game-references/controls/
local openmenu = 246         ------- Y

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------ Limiteur de vitesse -----------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0) 
    if regulateur == 50 then
    else      
        speedo(regulateur)
      end
    end
end)

function speedo(vit)
    local ped = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(ped, false)  
    local currSpeed = GetEntitySpeed(vehicle)*3.6
    speed = vit/3.62
   
    local vehicleModel = GetEntityModel(vehicle)
    local float Max = GetVehicleMaxSpeed(vehicleModel)  
    if (vit == 0) then
    SetEntityMaxSpeed(vehicle, Max)
    end      
  if currSpeed > vit then
  else
   
    if (vit == 0) then
    SetEntityMaxSpeed(vehicle, Max)
    else
    if vit == 0 and currSpeed < 5 then  
    else
      SetEntityMaxSpeed(vehicle, speed)
  end
    end
end
end

----------------------------------------------------------------------------------
---------------------------------------TEST---------------------------------------
----------------------------------------------------------------------------------

--Citizen.CreateThread(function()
--  while true do
--    Citizen.Wait(0)
--    if IsControlJustPressed(1, 168) and IsPedInAnyVehicle(GetPlayerPed(-1)) then
--      ouvert = false
--      local ped = PlayerPedId()
--      local pedVehicle = GetVehiclePedIsIn(ped, false)
--      local vehicleSpeed = math.ceil(GetEntitySpeed(pedVehicle) * 3.6)
--      regulateur = vehicleSpeed
--      Notify("Limiteur :~r~ "..regulateur .."KMH         Ralentissé !")
--    if regulateur < 60 then
--      regulateur = 60
--      Notify("Impossible de baissé la vitesse en dessous de ~r~60 KMH")
--    elseif IsControlJustPressed(1, 168) and ouvert == false then
--    Notify("désactivé")
--    ouvert = true
--    end
--    end
--    end
--end)


--Citizen.CreateThread(function()
--  while true do
--    Citizen.Wait(0)
--    if IsControlJustPressed(1, 167) and  IsPedInAnyVehicle(GetPlayerPed(-1)) then
--      local ped = PlayerPedId()
--      local pedVehicle = GetVehiclePedIsIn(ped, false)
--      local vehicleSpeed = math.ceil(GetEntitySpeed(pedVehicle) * 3.6)
--      regulateur = vehicleSpeed +5
--      Notify("Limiteur :~g~ "..regulateur .."KMH")
--    end
--    end
--end)
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

if toucheslimiteur == true then
--------------------------------------- Activé le Limiteur
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if IsDisabledControlJustPressed(1, activlimiteur) and IsPedInAnyVehicle(GetPlayerPed(-1)) then
      local ped = PlayerPedId()
      local pedVehicle = GetVehiclePedIsIn(ped, false)
      local vehicleSpeed = math.ceil(GetEntitySpeed(pedVehicle) * 3.6)
      Notify("Limiteur activé :~o~ "..vehicleSpeed.." KMH")
      regulateur = vehicleSpeed
    elseif IsDisabledControlJustPressed(1, activlimiteur) then
      Notify("~r~Vous devez être dans un véhicule pour utiliser le limiteur !")
    end
  end
end)

--------------------------------------- Désactivé le Limiteur
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if IsControlJustPressed(1, desactivlimiteur) and IsPedInAnyVehicle(GetPlayerPed(-1)) then
      regulateur = 600000
      Notify("~r~Limiteur désactivé")
    elseif IsControlJustPressed(1, desactivlimiteur) then
      Notify("~r~Vous devez être dans un véhicule pour utiliser le limiteur !")
    end
  end
end)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------- MENU ------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

if menulimiteur == true then

local function sendNotification(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(true, false)
end

Citizen.CreateThread(function()
    while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(5000)
    end
end)

-- Menus
local SaaytexMenu = {
    Base = { Title = "~u~Limiteur de vitesse" },
    Data = { currentMenu = "Menu Limiteur :" },
    Events = {
        onSelected = function(self, _, btn, PMenu, menuData, currentButton, currentSlt, result)
            ------------------------------------------------------------------------------------
            if btn.name == "~g~Activé le limiteur" then
                local ped = PlayerPedId()
                local pedVehicle = GetVehiclePedIsIn(ped, false)
                local vehicleSpeed = math.ceil(GetEntitySpeed(pedVehicle) * 3.6)
                Notify("Limiteur activé :~o~ "..vehicleSpeed.." KMH")
                regulateur = vehicleSpeed
            ------------------------------------------------------------------------------------
            elseif btn.name == "Augmenté de 5 KMH" and regulateur > 6000 or regulateur < 0 then
                Notify("Il faut tout d'abord                  \"~g~Activé le limiteur~s~\"")
            elseif btn.name == "Augmenté de 5 KMH" and regulateur < 6000 and regulateur > 0 then
                regulateur = regulateur + 5
                Notify("Limiteur :~g~ "..regulateur.." KMH")
            ------------------------------------------------------------------------------------
            elseif btn.name == "Baissé de 5 KMH" and regulateur > 6000 or regulateur < 0 then
                Notify("Il faut tout d'abord                  \"~g~Activé le limiteur~s~\"")
            elseif btn.name == "Baissé de 5 KMH" and regulateur < 6000 and regulateur > 0 then
                regulateur = regulateur - 5
                Notify("Limiteur :~r~ "..regulateur.." KMH")
            ------------------------------------------------------------------------------------
            elseif btn.name == "~r~Désactivé Limiteur" then
                regulateur = 600000
                Notify("~r~Limiteur désactivé !")
            end
        end
        
    },

    Menu = {
        ["Menu Limiteur :"] = {
            b = {
                {name = "~g~Activé le limiteur", ask = "→→→", askX = true},
                {name = "Augmenté de 5 KMH", ask = "→→→", askX = true},
                {name = "Baissé de 5 KMH", ask = "→→→", askX = true},
                {name = "~r~Désactivé Limiteur", ask = "→→→", askX = true},
            }
        },
    }
}

-- Ouverture du Menu
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, openmenu) and IsPedInAnyVehicle(GetPlayerPed(-1)) then
            CreateMenu(SaaytexMenu)
        elseif IsControlJustPressed(1, openmenu) then
          Notify("~r~Vous devez être dans un véhicule pour utiliser le limiteur !")
        end
    end
end)

end