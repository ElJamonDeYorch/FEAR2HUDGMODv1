    if SERVER then
        return
    end


surface.CreateFont("MyFont", {
    font = "Bureau Agency FB Bold",
    size = 50,
    weight = 500,
    italic = true
})

surface.CreateFont("MyFont2", {
    font = "Bureau Agency FB Bold",
    size = 57,
    weight = 700,
    italic = true
})

surface.CreateFont("MyFont3", {
    font = "Bureau Agency FB Bold",
    size = 35,
    weight = 500,
    italic = false
})

surface.CreateFont("MyFont4", {
    font = "Bureau Agency FB Bold",
    size = 25,
    weight = 500,
    italic = false
})


hook.Add("HUDPaint", "DrawRotatedText", function()
    local client = LocalPlayer()
    local ammoCount = client:GetAmmoCount(10)
    local screenWidth = ScrW()
    local screenHeight = ScrH()
    local angle = 10
    local text = tostring(ammoCount)

    local lowAmmoThreshold = 0  -- Adjust this value to set the threshold for low ammo

    local outlineColor = Color(19, 38, 44, 100) -- Outline color
    local color = Color(201, 253, 255, 255)

    -- Check if ammo is low and change text color to red
    if ammoCount <= lowAmmoThreshold then
        color = Color(255, 0, 0, 255)
	outlineColor = Color(7, 1, 1, 100)
    end

    surface.SetFont("MyFont")
    local textWidth, textHeight = surface.GetTextSize(text)

    local rotationMatrix = Matrix()
    rotationMatrix:Translate(Vector(screenWidth - 245, screenHeight - 135, 0))
    rotationMatrix:Rotate(Angle(0, angle, 0))
    rotationMatrix:Translate(Vector(-screenWidth + 250, -screenHeight + 160, 0))

    cam.Start2D()
        render.PushFilterMin(TEXFILTER.ANISOTROPIC)
        render.PushFilterMag(TEXFILTER.ANISOTROPIC)

        cam.PushModelMatrix(rotationMatrix)
            draw.SimpleTextOutlined(
                text,
                "MyFont",
                screenWidth - 250,
                screenHeight - 160,
                color,
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_CENTER,
                4, -- Outline thickness
                outlineColor -- Outline color
            )
        cam.PopModelMatrix()

        render.PopFilterMin()
        render.PopFilterMag()
    cam.End2D()
end)





hook.Add("HUDPaint", "DrawRotatedText2", function()
    local client = LocalPlayer()
    local activeWeapon = client:GetActiveWeapon()

    if IsValid(activeWeapon) and client:Alive() then
        local ammoCount = client:GetAmmoCount(activeWeapon:GetPrimaryAmmoType())
        local screenWidth = ScrW()
        local screenHeight = ScrH()
        local color = Color(78, 115, 143, 255)
        local angle = 5
		local outlineColor = Color(19,38,44, 100) -- Outline color

        local text = tostring(ammoCount)

        surface.SetFont("MyFont")
        local textWidth, textHeight = surface.GetTextSize(text)

        local rotationMatrix = Matrix()
        rotationMatrix:Translate(Vector(screenWidth - 435, screenHeight - 175, 0))
        rotationMatrix:Rotate(Angle(0, angle, 0))
        rotationMatrix:Translate(Vector(-screenWidth + 250, -screenHeight + 160, 0))

        cam.Start2D()
            render.PushFilterMin(TEXFILTER.ANISOTROPIC)
            render.PushFilterMag(TEXFILTER.ANISOTROPIC)

            render.SetMaterial(Material("color"))

            cam.PushModelMatrix(rotationMatrix)
            draw.SimpleTextOutlined(
                text,
                "MyFont",
                screenWidth - 250,
                screenHeight - 160,
                color,
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_CENTER,
                4, -- Outline thickness
                outlineColor -- Outline color
            )
                surface.SetTextColor(color)
                surface.SetTextPos(screenWidth - 250 - textWidth / 2, screenHeight - 160 - textHeight / 2)
                surface.DrawText(text)
            cam.PopModelMatrix()

            render.PopFilterMin()
            render.PopFilterMag()
        cam.End2D()
    end
end)


hook.Add("HUDPaint", "DrawRotatedAmmoText3", function()
    local client = LocalPlayer()
    local weapon = client:GetActiveWeapon()
    if not IsValid(weapon) then return end
    
    local ammoCount = weapon:Clip1()
    local maxAmmo = weapon:GetMaxClip1()
    local ammoPercentage = ammoCount / maxAmmo
    local lowAmmoThreshold = 0.35

    local screenWidth = ScrW()
    local screenHeight = ScrH()

    local angle = 5  -- Desired rotation angle in degrees
    local outlineColor = Color(19, 38, 44, 100) -- Outline color
    local text = tostring(ammoCount)
    local ammoTextColor = Color(201, 253, 255, 255)

    if ammoPercentage <= lowAmmoThreshold then
        ammoTextColor = Color(255, 55, 55, 255)
        outlineColor = Color(5, 1, 1, 100) -- Red outline color for low ammo
    end

    surface.SetFont("MyFont")
    local textWidth, textHeight = surface.GetTextSize(text)

    local rotationMatrix = Matrix()
    rotationMatrix:Translate(Vector(screenWidth - 482, screenHeight - 205, 0))
    rotationMatrix:Rotate(Angle(0, angle, 0))
    rotationMatrix:Translate(Vector(-screenWidth + 505, -screenHeight + 225, 0))

    cam.Start2D()
        render.PushFilterMin(TEXFILTER.ANISOTROPIC)
        render.PushFilterMag(TEXFILTER.ANISOTROPIC)

        cam.PushModelMatrix(rotationMatrix)
            draw.SimpleTextOutlined(
                text,
                "MyFont",
                screenWidth - 505,
                screenHeight - 225,
                ammoTextColor,
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_CENTER,
                4, -- Outline thickness
                outlineColor -- Outline color
            )
        cam.PopModelMatrix()

        render.PopFilterMin()
        render.PopFilterMag()
    cam.End2D()
end)





-- Define las dimensiones originales de tu HUD
local originalWidth = 1024
local originalHeight = 768

-- Función para dibujar el HUD
local function DrawHUD()
    local client = LocalPlayer()
    if not client:Alive() then
        return
    end

    -- Obtiene las dimensiones actuales de la pantalla
    local screenWidth = ScrW()
    local screenHeight = ScrH()

    -- Calcula la relación de escala
    local scaleX = screenWidth / originalWidth
    local scaleY = screenHeight / originalHeight

    -- Ajusta las dimensiones y posiciones en función de la relación de escala
    local adjustedWidth = originalWidth * scaleX
    local adjustedHeight = originalHeight * scaleY
    local adjustedX = (screenWidth - adjustedWidth) /2
    local adjustedY = (screenHeight - adjustedHeight) / 2
    local angle = 30

    local squareSize = 200
    local healthBarTexture = Material("yorch/healthbar") -- Normal health bar texture
    local AlmostHealthBarTexture = Material("yorch/healthbar75") -- Low health bar texture with desired color
    local lowHealthBarTexture = Material("yorch/healthbar50") -- Low health bar texture with desired color
    local criticalHealthBarTexture = Material("yorch/healthbar25") -- Low health bar texture with desired color


-- Define the alpha pulse effect parameters
local alphaFrequency = 1.0    -- Adjust the frequency of the alpha pulse
local alphaAmplitude = 100    -- Adjust the amplitude of the alpha pulse

-- Calculate the alpha pulse effect
local time = CurTime() * alphaFrequency
local alpha = 255 - math.abs(math.sin(time) * alphaAmplitude)

-- Dibuja el cuadrado texturizado en el HUD with alpha pulse effect
surface.SetDrawColor(255, 255, 255, alpha)
surface.SetMaterial(Material("yorch/beckethud"))
surface.DrawTexturedRect(adjustedX, adjustedY, adjustedWidth, adjustedHeight)

    -- Dibujar la barra de vida con color según la salud
    local health = LocalPlayer():Health() -- Obtener la vida del jugador local
    local maxHealth = LocalPlayer():GetMaxHealth()
    local healthPercentage = health / maxHealth
     local barWidth = 213
    local barHeight = 85
    local barX = adjustedX + barWidth + 40
    local barY = adjustedY + barHeight + 794 -- Separación entre el cuadrado y la barra
    -- Inside your HUD drawing function
    local textureToUse = healthBarTexture -- Default to normal health bar texture
if healthPercentage < 0.25 then
    textureToUse = criticalHealthBarTexture -- Switch to critical health texture at 25%
elseif healthPercentage < 0.5 then
    textureToUse = lowHealthBarTexture -- Switch to low health texture at 50%
elseif healthPercentage < 0.9 then
    textureToUse = AlmostHealthBarTexture -- Switch to normal health texture at 75%
end
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(textureToUse)
    surface.DrawTexturedRectUV(barX, barY, barWidth * (health / 100), barHeight, 0, 0, health / 100, 1)




    local barWidth = 212
    local barHeight = 84
    local barX = adjustedX + barWidth + 41
    local barY = adjustedY + barHeight + 795 -- Separación entre el cuadrado y la barra
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(Material("yorch/healthbackground"))
    surface.DrawTexturedRectUV(barX, barY, barWidth, barHeight, 0, 0, 1, 1)


    local barWidth = 36
    local barHeight = 25
    local barX = adjustedX + barWidth + 376
    local barY = adjustedY + barHeight + 868 -- Separación entre el cuadrado y la barra
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(Material("yorch/healthcross"))
    surface.DrawTexturedRectUV(barX, barY, barWidth, barHeight, 0, 0, 1, 1)



    local barWidth = 214
    local barHeight = 86
    local barX = adjustedX + barWidth + -18
    local barY = adjustedY + barHeight + 800 -- Separación entre el cuadrado y la barra
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(Material("yorch/armorbackground"))
    surface.DrawTexturedRectUV(barX, barY, barWidth, barHeight, 0, 0, 1, 1)


    local armor = LocalPlayer():Armor()
    local armorBarWidth = 212
    local armorBarHeight = 84
    local armorBarX = adjustedX + barWidth + -18
    local armorBarY = adjustedY + barHeight + 802 -- Separación entre el cuadrado y la barra
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(Material("yorch/armorbar"))
    surface.DrawTexturedRectUV(armorBarX, armorBarY, armorBarWidth * (armor / 200), armorBarHeight, 0, 0, armor / 200, 1)


    local barWidth = 300
    local barHeight = 123
    local barX = adjustedX + barWidth + -117
    local barY = adjustedY + barHeight + 739 -- Separación entre el cuadrado y la barra
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(Material("yorch/background"))
    surface.DrawTexturedRectUV(barX, barY, barWidth, barHeight, 0, 0, 1, 1)

local weapon = client:GetActiveWeapon()
if IsValid(weapon) then
    local barWidth = 79
    local barHeight = 75
    local barX = adjustedX + barWidth + 1260
    local barY = adjustedY + barHeight + 770 -- Separación entre el cuadrado y la barra
    surface.SetDrawColor(255, 255, 255, 255)
    
    local weaponType = weapon:GetClass() -- Get the class name of the active weapon
    local materialPath = "yorch/rifleshell" -- Default material path

    -- Modify the material path only for the bullets
    if weaponType == "weapon_pistol" then
        -- If it's a pistol, use a different material path for bullets
        materialPath = "yorch/pistolshell"
    elseif weaponType == "weapon_shotgun" then
        -- If it's a rifle, use a different material path for bullets
        materialPath = "yorch/shotgunshell"
   elseif weaponType == "weapon_fear2shotgun" then
        -- If it's a rifle, use a different material path for bullets
        materialPath = "yorch/shotgunshell"
   elseif weaponType == "weapon_ar2" then
        -- If it's a rifle, use a different material path for bullets
        materialPath = "yorch/rifleshell"
   elseif weaponType == "weapon_arfear2" then
        -- If it's a rifle, use a different material path for bullets
        materialPath = "yorch/rifleshell"
   elseif weaponType == "weapon_smg1" then
        -- If it's a rifle, use a different material path for bullets
        materialPath = "yorch/rifleshell"
   elseif weaponType == "weapon_smgfear2" then
        -- If it's a rifle, use a different material path for bullets
        materialPath = "yorch/rifleshell"
   elseif weaponType == "weapon_pistolfear2" then
        -- If it's a rifle, use a different material path for bullets
        materialPath = "yorch/pistolshell"
   elseif weaponType == "weapon_nailgunfear2" then
        -- If it's a rifle, use a different material path for bullets
        materialPath = "yorch/pistolshell"
   elseif weaponType == "weapon_fear2sniper" then
        -- If it's a rifle, use a different material path for bullets
        materialPath = "yorch/pistolshell"
   elseif weaponType == "weapon_crossbow" then
        -- If it's a rifle, use a different material path for bullets
        materialPath = "yorch/pistolshell"
   elseif weaponType == "weapon_357" then
        -- If it's a rifle, use a different material path for bullets
        materialPath = "yorch/pistolshell"
    end

    surface.SetMaterial(Material(materialPath))
    surface.DrawTexturedRectUV(barX, barY, barWidth, barHeight, 0, 0, 1, 1)

    -- The rest of the script for separator and grenade remains unchanged
    local barWidth = 39
    local barHeight = 44
    local barX = adjustedX + barWidth + 1405
    local barY = adjustedY + barHeight + 825
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(Material("yorch/separator"))
    surface.DrawTexturedRectUV(barX, barY, barWidth, barHeight, 0, 0, 1, 1)

    local barWidth = 54
    local barHeight = 61
    local barX = adjustedX + barWidth + 1560
    local barY = adjustedY + barHeight + 835
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(Material("yorch/grenade"))
    surface.DrawTexturedRectUV(barX, barY, barWidth, barHeight, 0, 0, 1, 1)
end

end



-- Hook para dibujar el HUD en cada frame
hook.Add("HUDPaint", "MiHUD", DrawHUD)


surface.CreateFont("MyFont", {
    font = "Bureau Agency FB Bold",
    size = 50,
    weight = 1000,
    italic = true
})

local tab = {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 1,
	[ "$pp_colour_contrast" ] = 2,
	[ "$pp_colour_colour" ] = 0,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
}

-- Healing Effect
local healingEffectActive = false
local healingEffectStartTime = 0
local healingEffectDuration = 0.3
local healingEffectMaxDuration = 1

hook.Add("RenderScreenspaceEffects", "HealingEffect", function()
    if healingEffectActive then
        local currentTime = CurTime()
        local lerpAmount = 1 - math.min((currentTime - healingEffectStartTime) / healingEffectDuration, 1)

        local tab = {
            ["$pp_colour_addr"] = Lerp(lerpAmount, 0, 0.01),
            ["$pp_colour_addg"] = Lerp(lerpAmount, 0, 0.005),
            ["$pp_colour_addb"] = Lerp(lerpAmount, 0, 0.005),
            ["$pp_colour_brightness"] = Lerp(lerpAmount, 0.05, 0.1),
            ["$pp_colour_contrast"] = Lerp(lerpAmount, 0.5, 2),
            ["$pp_colour_colour"] = Lerp(lerpAmount, 0.05, 1),
            ["$pp_colour_mulr"] = Lerp(lerpAmount, 255, 0),
            ["$pp_colour_mulg"] = Lerp(lerpAmount, 0, 0),
            ["$pp_colour_mulb"] = Lerp(lerpAmount, 0, 0)
        }

        DrawColorModify(tab)

        if currentTime - healingEffectStartTime > healingEffectMaxDuration then
            healingEffectActive = false
        end
    end
end)

-- Call this function to start the healing effect
local function StartHealingEffect()
    healingEffectActive = true
    healingEffectStartTime = CurTime()
end

-- Call this function to stop the healing effect
local function StopHealingEffect()
    healingEffectActive = false
end

-- Example of how to activate the effect when picking up a healing item
hook.Add("HUDItemPickedUp", "HealingPickedUpEffect", function(itemName)
    if itemName == "item_healthvial" or itemName == "item_healthkit" then
        StartHealingEffect()
        timer.Simple(healingEffectDuration, function()
            StopHealingEffect()
        end)
    end
end)

-- Armor Effect
local armorEffectActive = false
local armorEffectStartTime = 0
local armorEffectDuration = 0.3
local armorEffectMaxDuration = 1

hook.Add("RenderScreenspaceEffects", "ArmorEffect", function()
    if armorEffectActive then
        local currentTime = CurTime()
        local lerpAmount = 1 - math.min((currentTime - armorEffectStartTime) / armorEffectDuration, 1)

        local tab = {
            ["$pp_colour_addr"] = Lerp(lerpAmount, 0, 0.001),
            ["$pp_colour_addg"] = Lerp(lerpAmount, 0, 0.04),
            ["$pp_colour_addb"] = Lerp(lerpAmount, 0, 0.05),
            ["$pp_colour_brightness"] = Lerp(lerpAmount, 0.05, 0.1),
            ["$pp_colour_contrast"] = Lerp(lerpAmount, 0.5, 2),
            ["$pp_colour_colour"] = Lerp(lerpAmount, 0.05, 1),
            ["$pp_colour_mulr"] = Lerp(lerpAmount, 0, 0),
            ["$pp_colour_mulg"] = Lerp(lerpAmount, 75, 0),
            ["$pp_colour_mulb"] = Lerp(lerpAmount, 255, 0)
        }

        DrawColorModify(tab)

        if currentTime - armorEffectStartTime > armorEffectMaxDuration then
            armorEffectActive = false
        end
    end
end)

-- Call this function to start the armor effect
local function StartArmorEffect()
    armorEffectActive = true
    armorEffectStartTime = CurTime()
end

-- Call this function to stop the armor effect
local function StopArmorEffect()
    armorEffectActive = false
end

-- Example of how to activate the effect when picking up an armor battery
hook.Add("HUDItemPickedUp", "ArmorPickedUpEffect", function(itemName)
    if itemName == "item_battery" then
        StartArmorEffect()
        timer.Simple(armorEffectDuration, function()
            StopArmorEffect()
        end)
    end
end)


local healingItemImageVial = Material("yorch/HealthHUD")
local healingItemImageKit = Material("yorch/HealthHUD")

hook.Add("HUDPaint", "HealingItemImage", function()
    local client = LocalPlayer()
    local healingItemDistance = 100  -- Adjust the distance at which the image appears

    for _, ent in pairs(ents.FindInSphere(client:GetPos(), healingItemDistance)) do
        if ent:GetClass() == "item_healthvial" then
            local itemPos = (ent:WorldSpaceCenter() + Vector(2, 3, 5)):ToScreen()

            -- Draw the image at the health vial's position
            surface.SetMaterial(healingItemImageVial)
            surface.SetDrawColor(Color(255, 255, 255, 255))
            surface.DrawTexturedRect(itemPos.x - 32, itemPos.y - 32, 150, 130)  -- Adjust size as needed
        elseif ent:GetClass() == "item_healthkit" then
            local itemPos = (ent:WorldSpaceCenter() + Vector(2, 3, 5)):ToScreen()

            -- Draw the image at the health kit's position
            surface.SetMaterial(healingItemImageKit)
            surface.SetDrawColor(Color(255, 255, 255, 255))
            surface.DrawTexturedRect(itemPos.x - 32, itemPos.y - 32, 150, 130)  -- Adjust size as needed
        end
    end
end)




local weaponImage = Material("yorch/weaponhud")  -- Replace with the path to your weapon image

hook.Add("HUDPaint", "WeaponImage", function()
    local client = LocalPlayer()
    local weaponDistance = 100  -- Adjust the distance at which the image appears

    for _, ent in pairs(ents.FindInSphere(client:GetPos(), weaponDistance)) do
        -- Replace "weapon_..." with the appropriate class name for the weapon entity
        if string.find(ent:GetClass(), "weapon_") and ent:GetOwner() == NULL then
            local weaponPos = (ent:WorldSpaceCenter() + Vector(0, 0, 5)):ToScreen()

            -- Draw the image at the weapon's position
            surface.SetMaterial(weaponImage)
            surface.SetDrawColor(Color(255, 255, 255, 255))
            surface.DrawTexturedRect(weaponPos.x - 32, weaponPos.y - 32, 124, 124)  -- Adjust size as needed
        end
    end
end)








local armorBatteryImage = Material("yorch/ArmorHUD")

hook.Add("HUDPaint", "ArmorBatteryImage", function()
    local client = LocalPlayer()
    local armorBatteryDistance = 100  -- Adjust the distance at which the image appears

    for _, ent in pairs(ents.FindInSphere(client:GetPos(), armorBatteryDistance)) do
        if ent:GetClass() == "item_battery" then
            local batteryPos = (ent:WorldSpaceCenter() + Vector(2, 3, 5)):ToScreen()

            -- Draw the image at the battery's position
            surface.SetMaterial(armorBatteryImage)
            surface.SetDrawColor(Color(255, 255, 255, 255))
            surface.DrawTexturedRect(batteryPos.x - 32, batteryPos.y - 32, 124, 124)  -- Adjust size as needed
        end
    end
end)

local function GetHealthPercentage(player)
    if IsValid(player) and player:IsPlayer() then
        return player:Health() / player:GetMaxHealth()
    end
    return 0
end











local drawPlayerImagesConVar = CreateConVar("f2hud_draw_playerhealth", "1", FCVAR_ARCHIVE, "Enable or disable drawing player images")

hook.Add("HUDPaint", "DrawPlayerImages", function()
    if not drawPlayerImagesConVar:GetBool() then
        return
    end

    local client = LocalPlayer()
    local playerList = player.GetAll()

    local GOOD_HEALTH_THRESHOLD = 0.75
    local MEDIUM_HEALTH_THRESHOLD = 0.5
    local path_to_additional_image = "yorch/vidagif/imageforgif"
    local path_to_additional_image2 = "yorch/vidagif/imageforgif2"
    local path_to_zero_health_image = "yorch/vidagif/PlayerDead"

local function GetImageBasedOnHealth(healthPercentage)
    if healthPercentage <= 0 then
        return Material("yorch/vidagif/PlayerDead")  -- Replace with the actual path
    elseif healthPercentage >= GOOD_HEALTH_THRESHOLD then
        return Material("yorch/vidagif/GoodHealthPlayerNPC")
    elseif healthPercentage >= MEDIUM_HEALTH_THRESHOLD then
        return Material("yorch/vidagif/MediumHealthPlayerNPC")
    else
        return Material("yorch/vidagif/LowHealthPlayerNPC")
    end
end

    for _, player in pairs(playerList) do
        if player ~= client and player:GetPos():DistToSqr(client:GetPos()) < 500000 then
            local healthPercentage = GetHealthPercentage(player)
            local healthImage = GetImageBasedOnHealth(healthPercentage)

            local headPos = player:GetBonePosition(player:LookupBone("ValveBiped.Bip01_Spine2")):ToScreen()
            local x = headPos.x
            local y = headPos.y

            local imageSize = 40

            surface.SetMaterial(healthImage)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect(x - imageSize - -10, y - imageSize, imageSize, imageSize)

            -- Draw the additional image with scaling
            local additionalImage = Material(path_to_additional_image)
            local additionalImageWidth = 80
            local additionalImageHeight = 30
            surface.SetMaterial(additionalImage)
            surface.DrawTexturedRect(x - additionalImageWidth - -25, y - additionalImageHeight, additionalImageWidth, additionalImageHeight)

            -- Draw player name
            local playerName = player:Nick()
            surface.SetFont("MyFont3")
            local textWidth, textHeight = surface.GetTextSize(playerName)
            surface.SetTextPos(x - textWidth, y - additionalImageHeight - -30)
            surface.SetTextColor(Color(100, 200, 100, 255)) -- Set the color (green in this case)
            surface.DrawText(playerName)
        end
    end
end)






local speakingPlayers = {} -- Table to keep track of speaking players

-- This function draws an image and player name on the HUD
local function DrawVoipImage()
    local rotationAngle = 10 -- Adjust the rotation angle in degrees
    surface.SetDrawColor(1, 1, 1, 255)
    surface.SetMaterial(Material("yorch/vidagif/soundwave"))
    surface.DrawTexturedRectRotated(300, 850, 124, 32, rotationAngle) -- Static rotation

    local rotationAngle = 10 -- Adjust the rotation angle in degrees
    surface.SetDrawColor(1, 1, 1, 255)
    surface.SetMaterial(Material("yorch/vidagif/soundwavebackground"))
    surface.DrawTexturedRectRotated(300, 850, 256, 12, rotationAngle) -- Static rotation

    for _, ply in ipairs(speakingPlayers) do
        local playerName = ply:GetName()
        draw.SimpleText(playerName, "MyFont4", 300, 830, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

-- Hook to capture when a player starts talking
hook.Add("PlayerStartVoice", "DrawVoipImage_PlayerStartVoice", function(ply)
    if ply == LocalPlayer() then
        table.insert(speakingPlayers, ply)
        hook.Add("HUDPaint", "DrawVoipImage_HUDPaint", DrawVoipImage) -- Start drawing the image on HUD
    end
end)

-- Hook to capture when a player stops talking
hook.Add("PlayerEndVoice", "DrawVoipImage_PlayerEndVoice", function(ply)
    if ply == LocalPlayer() then
        speakingPlayers = {}
        hook.Remove("HUDPaint", "DrawVoipImage_HUDPaint") -- Stop drawing the image on HUD
    end
end)

local function DrawVoipImage()
    local rotationAngle = 10 -- Adjust the rotation angle in degrees
    local screenWidth = ScrW()
    local screenHeight = ScrH()

    local rotationMatrix = Matrix()
    rotationMatrix:Translate(Vector(screenWidth - 435, screenHeight - 175, 0))
    rotationMatrix:Rotate(Angle(0, rotationAngle, 0))
    rotationMatrix:Translate(Vector(-screenWidth + 250, -screenHeight + 160, 0))

    cam.Start2D()
        render.PushFilterMin(TEXFILTER.ANISOTROPIC)
        render.PushFilterMag(TEXFILTER.ANISOTROPIC)

        cam.PushModelMatrix(rotationMatrix)

        surface.SetDrawColor(1, 1, 1, 255)
        surface.SetMaterial(Material("yorch/vidagif/soundwave"))
        surface.DrawTexturedRectRotated(300, 850, 124, 32, rotationAngle) -- Static rotation

        surface.SetDrawColor(1, 1, 1, 255)
        surface.SetMaterial(Material("yorch/vidagif/soundwavebackground"))
        surface.DrawTexturedRectRotated(300, 850, 256, 12, rotationAngle) -- Static rotation

        for _, ply in ipairs(speakingPlayers) do
            local playerName = ply:GetName()
            surface.SetFont("MyFont4")
            local textWidth, textHeight = surface.GetTextSize(playerName)
            local textX = 300
            local textY = 830

            draw.SimpleText(
                playerName,
                "MyFont4",
                textX,
                textY,
                Color(255, 255, 255, 255),
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_CENTER
            )

            surface.SetTextPos(textX - textWidth / 2, textY - textHeight / 2)
            surface.DrawText(playerName)
        end

        cam.PopModelMatrix()

        render.PopFilterMin()
        render.PopFilterMag()
    cam.End2D()
end





-- hook.Add("PlayerStartVoice", "ImageOnVoice", function()
--     hook.Add("HUDPaint", "ImageOnVoice", iconfunc)
-- end)

-- hook.Add("PlayerEndVoice", "ImageOnVoice", function()
--     hook.Remove("HUDPaint", "ImageOnVoice")
-- end)









hook.Add( "HUDDrawTargetID", "HidePlayerInfo", function()

	return false

end )


function HideHud (name)
	for k, v in pairs ({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"}) do
	     if name == v then
		 return false
	     end
	end
end
hook.Add("HUDShouldDraw", "HideDefaultHud", HideHud) 