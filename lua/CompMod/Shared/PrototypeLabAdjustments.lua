// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\PrototypeLabAdjustments.lua
// - Dragon

local originalPrototypeLabGetItemList
originalPrototypeLabGetItemList = Class_ReplaceMethod("PrototypeLab", "GetItemList",
	function(self, forPlayer)
    
		return { kTechId.Jetpack, kTechId.DualMinigunExosuit, kTechId.DualRailgunExosuit, }
		
	end
)