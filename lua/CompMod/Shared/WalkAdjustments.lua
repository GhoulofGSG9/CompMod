// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\WalkAdjustments.lua
// - Dragon

local originalMarineOnCreate
originalMarineOnCreate = Class_ReplaceMethod("Marine", "OnCreate",
	function(self)
		originalMarineOnCreate(self)
		InitMixin(self, WalkMixin)
	end
)

//Tap into this because NS2+ hooks the normal handlebuttons for marines

local originalSprintMixinUpdateSprintingState = SprintMixin.UpdateSprintingState
function SprintMixin:UpdateSprintingState(input)
	originalSprintMixinUpdateSprintingState(self, input)
	self:UpdateWalkMode(input)
end

function Marine:GetMaxSpeed(possible)

    if possible then
        return Marine.kRunMaxSpeed
    end

	//These variable names are not super amazing...
	//Run is sprinting, and walk is normal walk.
	//So then what is the toggled 'walk'?  SlowWalk? :D
	
    local sprintingScalar = self:GetSprintingScalar()
    local maxSprintSpeed = Marine.kWalkMaxSpeed + (Marine.kRunMaxSpeed - Marine.kWalkMaxSpeed) * sprintingScalar
    local maxSpeed = ConditionalValue(self:GetIsSprinting(), maxSprintSpeed, Marine.kWalkMaxSpeed)
    maxSpeed = ConditionalValue(self:GetIsWalking(), kMarineMaxSlowWalkSpeed, maxSpeed)
	
    // Take into account our weapon inventory and current weapon. Assumes a vanilla marine has a scalar of around .8.
    local inventorySpeedScalar = self:GetInventorySpeedScalar() + .17    
    local useModifier = self.isUsing and 0.5 or 1
    
    if self.catpackboost then
        maxSpeed = maxSpeed + kCatPackMoveAddSpeed
    end
    
    return maxSpeed * self:GetSlowSpeedModifier() * inventorySpeedScalar  * useModifier
    
end

function Marine:GetPlayFootsteps()
    return Player.GetPlayFootsteps(self) and not self:GetIsWalking()
end

local networkVars = { }

AddMixinNetworkVars(WalkMixin, networkVars)

Shared.LinkClassToMap("Marine", Marine.kMapName, networkVars, true)