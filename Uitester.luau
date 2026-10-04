local Library = loadstring(game:HttpGet("YOUR_RAW_LIBRARY_URL"))()

local Window = Library:CreateWindow({
    Title = "Example Hub",
    Subtitle = "Compact UI",
    Theme = "Dark"
})

local Main = Window:CreateTab("Main", "⌂")

Main:CreateSection("Main Controls")

Main:CreateButton({
    Name = "Test Button",
    Callback = function()
        Window:Notify({
            Title = "Success",
            Content = "Button works!",
            Duration = 3
        })
    end
})

Main:CreateToggle({
    Name = "Auto Farm",
    Default = false,
    Flag = "AutoFarm",
    Callback = function(value)
        print("Auto Farm:", value)
    end
})

Main:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 100},
    Default = 16,
    Increment = 1,
    Callback = function(value)
        print("Speed:", value)
    end
})

Main:CreateDropdown({
    Name = "Select Mode",
    Options = {
        "Easy",
        "Medium",
        "Hard"
    },
    Callback = function(value)
        print("Selected:", value)
    end
})

Main:CreateInput({
    Name = "Player Name",
    PlaceholderText = "Enter player...",
    Callback = function(value)
        print("Input:", value)
    end
})

Main:CreateKeybind({
    Name = "Toggle UI",
    Default = Enum.KeyCode.RightShift,
    Callback = function()
        print("Keybind pressed")
    end
})

Main:CreateColorPicker({
    Name = "UI Color",
    Default = Color3.fromRGB(145, 90, 255),
    Callback = function(color)
        print(color)
    end
})

local Settings = Window:CreateTab("Settings", "⚙")

Settings:CreateSection("Interface")

Settings:CreateButton({
    Name = "Minimize",
    Callback = function()
        Window:Minimize()
    end
})

Settings:CreateButton({
    Name = "Purple Theme",
    Callback = function()
        Window:SetTheme("Purple")
    end
})

Window:CreateSearch()

Window:Notify({
    Title = "Example Hub",
    Content = "UI loaded successfully!",
    Duration = 3
})
