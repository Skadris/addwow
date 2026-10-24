local MIN_SCALE = 0.4
local MAX_SCALE = 1
local DEFAULT_SCALE = 1

local function clampScale(scale)
    return math.max(MIN_SCALE, math.min(MAX_SCALE, scale))
end

local function applyScale(scale)
    scale = clampScale(scale)
    UIParent:SetScale(scale)
    SKDUIscaleDB.scale = scale
end

local panel = CreateFrame("Frame", "SKDUIscalePanel", UIParent, "BasicFrameTemplateWithInset")
panel:SetSize(320, 150)
panel:SetPoint("CENTER")
panel:SetMovable(true)
panel:EnableMouse(true)
panel:RegisterForDrag("LeftButton")
panel:SetScript("OnDragStart", panel.StartMoving)
panel:SetScript("OnDragStop", panel.StopMovingOrSizing)
panel:Hide()
panel.TitleText:SetText("SKDUIscale")

local description = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
description:SetPoint("TOPLEFT", panel, "TOPLEFT", 20, -40)
description:SetText("UI scale")

local valueText = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
valueText:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -20, -40)

local slider = CreateFrame("Slider", "SKDUIscaleSlider", panel, "OptionsSliderTemplate")
slider:SetPoint("TOPLEFT", panel, "TOPLEFT", 30, -70)
slider:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -30, -70)
slider:SetMinMaxValues(MIN_SCALE, MAX_SCALE)
slider:SetValueStep(0.01)
slider:SetObeyStepOnDrag(true)
slider.Low:SetText("0.4")
slider.High:SetText("1.0")
slider.Text:SetText("")

local resetButton = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
resetButton:SetSize(100, 24)
resetButton:SetPoint("BOTTOM", panel, "BOTTOM", 0, 14)
resetButton:SetText("Reset to 1.0")
resetButton:SetScript("OnClick", function()
    slider:SetValue(DEFAULT_SCALE)
end)

slider:SetScript("OnValueChanged", function(self, value)
    value = math.floor(value * 100 + 0.5) / 100
    valueText:SetText(string.format("%.2f", value))
    applyScale(value)
end)

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function()
    if type(SKDUIscaleDB) ~= "table" then
        SKDUIscaleDB = {}
    end

    local savedScale = tonumber(SKDUIscaleDB.scale) or DEFAULT_SCALE
    applyScale(savedScale)
    slider:SetValue(clampScale(savedScale))
end)

SLASH_SKDUIscale1 = "/SKDUIscale"
SlashCmdList.SKDUIscale = function()
    if panel:IsShown() then
        panel:Hide()
    else
        panel:Show()
    end
end
