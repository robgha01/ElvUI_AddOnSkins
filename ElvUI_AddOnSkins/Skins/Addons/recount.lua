local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G

local function LoadSkin()
	if not E.private.addOnSkins.Recount then return end

	local function skinFrame(frame)
		frame:SetBackdrop(nil)

		local backdrop = CreateFrame("Frame", nil, frame)
		backdrop:SetFrameLevel(frame:GetFrameLevel() - 1)
		backdrop:Point("BOTTOMLEFT", frame, E.PixelMode and 1 or 0, E.PixelMode and 1 or 0)
		backdrop:Point("TOPRIGHT", frame, E.PixelMode and -1 or 0, -(E.PixelMode and 31 or 30))
		if frame == Recount.MainWindow then
			backdrop:SetTemplate("Default")
		else
			backdrop:SetTemplate("Transparent")
		end
		frame.backdrop = backdrop

		local header = CreateFrame("Frame", nil, backdrop)
		header:Height(22)
		header:Point("TOPLEFT", frame, E.PixelMode and 1 or 0, -(E.PixelMode and 8 or 7))
		header:Point("TOPRIGHT", frame, E.PixelMode and -1 or 0, 0)
		header:SetTemplate("Default", true)

		frame.Title:ClearAllPoints()
		frame.Title:SetPoint("LEFT", header, 6, 0)

		if frame.CloseButton then
			frame.CloseButton:ClearAllPoints()
			if frame ~= Recount.MainWindow then
				S:HandleCloseButton(frame.CloseButton)
				frame.CloseButton:Size(32)
				frame.CloseButton:Point("RIGHT", header, 4, 0)
			else
				frame.CloseButton:Point("RIGHT", header, -6, 0)
			end
		end
	end

	skinFrame(Recount.MainWindow)

	S:HandleCloseButton(Recount.MainWindow.CloseButton)
	Recount.MainWindow.CloseButton.Texture:Size(10)
	S:HandleNextPrevButton(Recount.MainWindow.RightButton, "right", nil, true)
	Recount.MainWindow.RightButton:Size(18)
	S:HandleNextPrevButton(Recount.MainWindow.LeftButton, "left", nil, true)
	Recount.MainWindow.LeftButton:Size(18)

	local buttons = {
		Recount.MainWindow.CloseButton,
		Recount.MainWindow.RightButton,
		Recount.MainWindow.LeftButton,
		Recount.MainWindow.ResetButton,
		Recount.MainWindow.FileButton,
		Recount.MainWindow.ConfigButton,
		Recount.MainWindow.ReportButton
	}

	for i = 1, #buttons do
		local button = buttons[i]
		if button then
			button:GetNormalTexture():SetDesaturated(true)
			button:GetHighlightTexture():SetDesaturated(true)
		end
	end

	Recount.MainWindow.DragBottomLeft:SetNormalTexture(nil)
	Recount.MainWindow.DragBottomRight:SetNormalTexture(nil)

	S:HandleScrollBar(Recount_MainWindow_ScrollBarScrollBar)

	hooksecurefunc(Recount, "HideScrollbarElements", function(self, name)
		_G[name.."ScrollBar"].backdrop:Hide()
		_G[name.."ScrollBar"]:GetThumbTexture().backdrop:Hide()
	end)
	hooksecurefunc(Recount, "ShowScrollbarElements", function(self, name)
		_G[name.."ScrollBar"].backdrop:Show()
		_G[name.."ScrollBar"]:GetThumbTexture().backdrop:Show()
	end)

	if Recount.db.profile.MainWindow.ShowScrollbar then
		Recount:ShowScrollbarElements("Recount_MainWindow_ScrollBar")
	else
		Recount:HideScrollbarElements("Recount_MainWindow_ScrollBar")
	end

	hooksecurefunc(Recount, "AddWindow", function(self, window)
		if window.YesButton and not window.isSkinned then
			SkinFrame(window)
			window.Text:SetPoint("TOP", window.backdrop, 0, -3)

			S:HandleButton(window.YesButton)
			window.YesButton:SetPoint("BOTTOMRIGHT", window, "BOTTOM", -3, 5)
			S:HandleButton(window.NoButton)
			window.NoButton:SetPoint("BOTTOMLEFT", window, "BOTTOM", 3, 5)

			window.isSkinned = true
		end
	end)

	hooksecurefunc(Recount, "ShowReport", function()
		if not Recount_ReportWindow.isSkinned then
			SkinFrame(Recount_ReportWindow)

			S:HandleButton(Recount_ReportWindow.ReportButton)
			S:HandleSliderFrame(Recount_ReportWindow_Slider)

			Recount_ReportWindow.Whisper:StripTextures(true)
			S:HandleEditBox(Recount_ReportWindow.Whisper)
			Recount_ReportWindow.Whisper:Height(16)

			Recount_ReportWindow.isSkinned = true
		end
	end)

	hooksecurefunc(Recount, "ShowConfig", function()
		if not Recount.ConfigWindow.isSkinned then
			SkinFrame(Recount.ConfigWindow)

			Recount.ConfigWindow:StripTextures()

			Recount.ConfigWindow.backdrop:StripTextures()
			Recount.ConfigWindow.backdrop:SetTemplate("Transparent")

			S:HandleSliderFrame(Recount_ConfigWindow_Scaling_Slider)
			S:HandleSliderFrame(Recount_ConfigWindow_RowHeight_Slider)
			S:HandleSliderFrame(Recount_ConfigWindow_RowSpacing_Slider)

			Recount.ConfigWindow.isSkinned = true
		end
	end)
end

S:AddCallbackForAddon("Recount", "Recount", LoadSkin)