// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\GUI\GUIHeavyMachineGunDisplay.lua
// - Dragon

Script.Load("lua/GUIScript.lua")
Script.Load("lua/Utility.lua")

// Global state that can be externally set to adjust the display.
weaponClip     = 0
weaponAmmo     = 0
weaponAuxClip  = 0
weaponVariant  = 1

FontScaleVector = Vector(1, 1, 1) * 1.85
FontScaleReserveVector = Vector(1, 1, 1) * 0.95

bulletDisplay  = nil
grenadeDisplay = nil

class 'GUIHeavyMachineGunDisplay' (GUIScript)

function GUIHeavyMachineGunDisplay:Initialize()

    self.weaponClip     = 0
    self.weaponAmmo     = 0
    self.weaponClipSize = 50
    
    self.onDraw = 0
    self.onHolster = 0

    self.background = GUIManager:CreateGraphicItem()
    //self.background:SetSize( Vector(512, 512, 0) )
    self.background:SetSize( Vector(256, 420, 0) )
    self.background:SetPosition( Vector(0, 0, 0))    
    self.background:SetPosition( Vector(0, 0, 0))    
    self.background:SetTexture("ui/hmgdisplay.dds")
    self.background:SetIsVisible(true)

    // Slightly larger copy of the text for a glow effect
    self.ammoTextBg = GUIManager:CreateTextItem()
    self.ammoTextBg:SetFontName(Fonts.kMicrogrammaDMedExt_Medium)
    //self.ammoTextBg:SetFontName("fonts/HMGFont.fnt")
    self.ammoTextBg:SetFontSize(130)
    self.ammoTextBg:SetFontIsBold(true)
    self.ammoTextBg:SetTextAlignmentX(GUIItem.Align_Center)
    self.ammoTextBg:SetTextAlignmentY(GUIItem.Align_Center)
    self.ammoTextBg:SetPosition(Vector(125, 150, 0))
    self.ammoTextBg:SetColor(Color(0, 0, 1, 0.25))

    // Text displaying the amount of ammo in the clip
    self.ammoText = GUIManager:CreateTextItem()
    self.ammoText:SetFontName(Fonts.kMicrogrammaDMedExt_Medium)
    //self.ammoText:SetFontName("fonts/HMGFont.fnt")
    self.ammoText:SetFontSize(120)
    self.ammoText:SetFontIsBold(true)
    self.ammoText:SetTextAlignmentX(GUIItem.Align_Center)
    self.ammoText:SetTextAlignmentY(GUIItem.Align_Center)
    self.ammoText:SetPosition(Vector(125, 150, 0))
    self.ammoText:SetColor(Color(1, 1, 1, 1))
    
        // Slightly larger copy of the text for a glow effect
    self.ammoTextReserveBg = GUIManager:CreateTextItem()
    //self.ammoTextReserveBg:SetFontName("fonts/HMGFont.fnt")
	self.ammoTextReserveBg:SetFontName(Fonts.kMicrogrammaDMedExt_Medium)
	self.ammoTextReserveBg:SetFontSize(130)
    self.ammoTextReserveBg:SetTextAlignmentX(GUIItem.Align_Center)
    self.ammoTextReserveBg:SetTextAlignmentY(GUIItem.Align_Center)
    self.ammoTextReserveBg:SetPosition(Vector(120, 310, 0))
    self.ammoTextReserveBg:SetColor(Color(0, 0, 1, 0.25))

    // Text displaying the amount of ammo in the clip
    self.ammoTextReserve = GUIManager:CreateTextItem()
    //self.ammoTextReserve:SetFontName("fonts/HMGFont.fnt")
	self.ammoTextReserve:SetFontName(Fonts.kMicrogrammaDMedExt_Medium)
    self.ammoTextReserve:SetFontSize(120)
    self.ammoTextReserve:SetTextAlignmentX(GUIItem.Align_Center)
    self.ammoTextReserve:SetTextAlignmentY(GUIItem.Align_Center)
    self.ammoTextReserve:SetPosition(Vector(120, 310, 0))
    self.ammoTextReserve:SetColor(Color(1, 1, 1, 1))
    
    // Force an update so our initial state is correct.
    self:Update(0)

end

function GUIHeavyMachineGunDisplay:Update(deltaTime)

    PROFILE("GUIHeavyMachineGunDisplay:Update")
    
    // Update the ammo counter.
    
    local ammoFormat = string.format("%02d", self.weaponClip)
		
    self.ammoText:SetText( ammoFormat )
    self.ammoTextBg:SetText( ammoFormat )
    
    // Update the reserve clip.
    local reserveFormat = string.format("%02d", self.weaponAmmo) 
    self.ammoTextReserve:SetText( reserveFormat )
    self.ammoTextReserveBg:SetText( reserveFormat )

end

function GUIHeavyMachineGunDisplay:SetClip(weaponClip)
    self.weaponClip = weaponClip
end

function GUIHeavyMachineGunDisplay:SetClipSize(weaponClipSize)
    self.weaponClipSize = weaponClipSize
end

function GUIHeavyMachineGunDisplay:SetAmmo(weaponAmmo)
    self.weaponAmmo = weaponAmmo
end

function GUIHeavyMachineGunDisplay:SetClipFraction(clipIndex, fraction)

    local offset   = (1 - fraction) * self.clipHeight
    local position = Vector( self.clip[clipIndex]:GetPosition().x, self.clipTop + offset, 0 )
    local size     = self.clip[clipIndex]:GetSize()
    
    self.clip[clipIndex]:SetPosition( position )
    self.clip[clipIndex]:SetSize( Vector( size.x, fraction * self.clipHeight, 0 ) )
    self.clip[clipIndex]:SetTexturePixelCoordinates( position.x, position.y + 256, position.x + self.clipWidth, self.clipTop + self.clipHeight + 256 )

end

/**
 * Called by the player to update the components.
 */
function Update(deltaTime)

    PROFILE("GUIHeavyMachineGunDisplay:Update")

    bulletDisplay:SetClip(weaponClip)
    bulletDisplay:SetAmmo(weaponAmmo)
    bulletDisplay:Update(deltaTime)
    
end

/**
 * Initializes the player components.
 */
function Initialize()

    GUI.SetSize(512, 512)
    //GUI.SetSize(256, 417)

    bulletDisplay = GUIHeavyMachineGunDisplay()
    bulletDisplay:Initialize()
    bulletDisplay:SetClipSize(100)

end

Initialize()