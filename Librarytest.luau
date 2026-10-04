--// Uiv2 Plain UI Library Test
--// No game-specific functions. Just testing the UI components.

local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/guyeditor2-boop/Scripts/refs/heads/main/Library/Uiv2.luau"
))()

--// Create Window
local Window = Library:CreateWindow({
    Title = "Uiv2 Test",
    Subtitle = "Plain UI Library Testing",
    Theme = Library.Themes.Purple
})

--==================================================
-- MAIN TAB
--==================================================

local Main = Window:CreateTab("Main", "◆")

Main:CreateSection("Basic Components")

Main:CreateParagraph({
    Title = "Uiv2 Library Test",
    Content = "This window is only for testing the UI library. " ..
        "No game functions or external features are included."
})

Main:CreateLabel("Library loaded successfully.")

Main:CreateButton({
    Name = "Test Button",
    Callback = function()
        Window:Notify({
            Title = "Button Test",
            Content = "The button is working!",
            Type = "Success",
            Duration = 3
        })
    end
})

Main:CreateToggle({
    Name = "Test Toggle",
    Default = false,
    Callback = function(value)
        Window:Notify({
            Title = "Toggle Changed",
            Content = "State: " .. tostring(value),
            Type = value and "Success" or "Warning",
            Duration = 2
        })
    end
})

Main:CreateSlider({
    Name = "Test Slider",
    Min = 0,
    Max = 100,
    Default = 50,
    Rounding = 1,

    Callback = function(value)
        print("Slider:", value)
    end
})

Main:CreateDropdown({
    Name = "Test Dropdown",
    Options = {
        "Option 1",
        "Option 2",
        "Option 3",
        "Option 4"
    },

    Default = "Option 1",

    Callback = function(value)
        print("Dropdown:", value)
    end
})

--==================================================
-- CONTROLS TAB
--==================================================

local Controls = Window:CreateTab("Controls", "⚙")

Controls:CreateSection("Interaction Tests")

Controls:CreateButton({
    Name = "Notification Test",
    Callback = function()
        Window:Notify({
            Title = "Notification",
            Content = "If you can see this, notifications work.",
            Type = "Success",
            Duration = 4
        })
    end
})

Controls:CreateToggle({
    Name = "Example Toggle",
    Default = true,

    Callback = function(state)
        print("Example Toggle:", state)
    end
})

Controls:CreateSlider({
    Name = "UI Scale Test",
    Min = 0.6,
    Max = 1.4,
    Default = 1,
    Rounding = 0.05,

    Callback = function(value)
        Window:SetScale(value)
    end
})

Controls:CreateDropdown({
    Name = "Theme Test",
    Options = {
        "Dark",
        "Purple",
        "Red",
        "Blue"
    },

    Default = "Purple",

    Callback = function(theme)
        if theme == "Dark" then
            Window:SetTheme(Library.Themes.Dark)

        elseif theme == "Purple" then
            Window:SetTheme(Library.Themes.Purple)

        elseif theme == "Red" then
            Window:SetTheme(Library.Themes.Red)

        elseif theme == "Blue" then
            Window:SetTheme(Library.Themes.Blue)
        end
    end
})

--==================================================
-- INFO TAB
--==================================================

local Info = Window:CreateTab("Info", "ⓘ")

Info:CreateSection("Library Information")

Info:CreateParagraph({
    Title = "What is being tested?",
    Content = "Window creation, tabs, buttons, toggles, " ..
        "sliders, dropdowns, notifications, themes and scaling."
})

Info:CreateLabel("Mobile / PC responsive UI")

Info:CreateLabel("Window dragging")

Info:CreateLabel("Minimize button")

Info:CreateLabel("Close button")

Info:CreateLabel("Theme switching")

Info:CreateLabel("UI scaling")

--==================================================
-- STARTUP NOTIFICATION
--==================================================

Window:Notify({
    Title = "Uiv2 Test",
    Content = "Test interface loaded successfully.",
    Type = "Success",
    Duration = 4
})
