// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Server\AlienAdjustments.lua
// - Dragon

//Not truly healable if you're not hurt...
function Alien:GetIsHealableOverride()
	return self:GetIsAlive() and self:AmountDamaged() > 0
end

local originalAlienGetIsHealableOverride
originalAlienGetIsHealableOverride = Class_ReplaceMethod("Alien", "UpdateAutoHeal",
	function(self)
	
		PROFILE("Alien:UpdateAutoHeal")
		local stime = Shared.GetTime()
		
		if self:GetIsHealable() and ( not self.timeLastAlienAutoHeal or self.timeLastAlienAutoHeal + kAlienRegenerationTime <= stime ) then

			local healRate = 1
			local hasRegenUpgrade = GetHasRegenerationUpgrade(self)
			local shellLevel = GetShellLevel(self:GetTeamNumber())
			local maxHealth = self:GetBaseHealth()
			
			hasRegenUpgrade = hasRegenUpgrade and (self.lastTakenDamageTime == nil or stime > self.lastTakenDamageTime + kAlienRegenBlockonDamage)
			
			if hasRegenUpgrade and shellLevel > 0 then
				healRate = Clamp(kAlienRegenerationPercentage * maxHealth, kAlienMinRegeneration, kAlienMaxRegeneration) * (shellLevel/3)
			else
				healRate = Clamp(kAlienInnateRegenerationPercentage * maxHealth, kAlienMinInnateRegeneration, kAlienMaxInnateRegeneration) 
			end
			
			if self:GetIsInCombat() then
				healRate = healRate * kAlienRegenerationCombatModifier
			end

			self:AddHealth(healRate, false, false, not hasRegenUpgrade)  
			self.timeLastAlienAutoHeal = stime
		
		end 

	end
)

function PlayerHallucinationMixin:OnKill()
   self:TriggerEffects("death_hallucination")
   self:SetBypassRagdoll(true)
end