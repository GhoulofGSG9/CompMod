// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\ArmoryAdjustments.lua
// - Dragon

local originalArmoryGetItemList
originalArmoryGetItemList = Class_ReplaceMethod("Armory", "GetItemList",
	function(self, forPlayer)
    
		local itemList = originalArmoryGetItemList(self, forPlayer)
		local shotgunLoc = 1
		local flamerLoc = 1
		local glLoc = 1
		
		for i = 1, #itemList do
			if itemList[i] == kTechId.Shotgun then
				shotgunLoc = i
			end
			if itemList[i] == kTechId.Flamethrower then
				flamerLoc = i
			end
			if itemList[i] == kTechId.GrenadeLauncher then
				glLoc = i
			end
		end
		
		if glLoc > 1 then
			table.remove(itemList, glLoc)
			if flamerLoc > glLoc then
				flamerLoc = flamerLoc - 1
			end
		end
		if flamerLoc > 1 then
			table.remove(itemList, flamerLoc)
		end
		
		table.insert(itemList, shotgunLoc + 1, kTechId.Flamethrower)
		
		if self:GetTechId() == kTechId.AdvancedArmory then
			table.insert(itemList, shotgunLoc + 2, kTechId.HeavyMachineGun)
			table.insert(itemList, shotgunLoc + 3, kTechId.GrenadeLauncher)
		end
		
		return itemList
		
	end
)

local oldArmoryGetTechButtons = Armory.GetTechButtons
function Armory:GetTechButtons(techId)

    local techButtons = oldArmoryGetTechButtons(self, techId)
	
	techButtons[4] = kTechId.FlamethrowerTech
    if self:GetTechId() == kTechId.AdvancedArmory then
        //techButtons[6] = kTechId.GrenadeLauncherTech
		techButtons[5] = kTechId.HeavyMachineGunTech
    end

    return techButtons
    
end

function Armory:OnResearchComplete(researchId)

    if researchId == kTechId.AdvancedArmoryUpgrade then
        self:SetTechId(kTechId.AdvancedArmory)
		
		local techTree = self:GetTeam():GetTechTree()
        local researchNode = techTree:GetTechNode(kTechId.GrenadeLauncherTech)
        
        if researchNode then     
   
            researchNode:SetResearchProgress(1.0)
            techTree:SetTechNodeChanged(researchNode, string.format("researchProgress = %.2f", self.researchProgress))
            researchNode:SetResearched(true)
            techTree:QueueOnResearchComplete(kTechId.GrenadeLauncherTech, self)
            
        end
		
    end
    
end

//Setting a global when the armory upgrades... impacts all armories...
local kArmoryHealthbarHeight = gArmoryHealthHeight
local kAdvancedArmoryHealthbarHeight = 1.7

function Armory:GetHealthbarOffset()
	if self:GetTechId() == kTechId.AdvancedArmory then
		return kAdvancedArmoryHealthbarHeight
	end
    return kArmoryHealthbarHeight
end