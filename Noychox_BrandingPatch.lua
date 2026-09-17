-- Noychox Premium — correção visual e textual
-- Execute este trecho depois de criar a janela WindUI.

local function safeSet(instance, property, value)
    pcall(function()
        if instance and instance[property] ~= nil then
            instance[property] = value
        end
    end)
end

local function replaceText(value)
    if type(value) ~= "string" then
        return value
    end

    local replacements = {
        ["Anonymous"] = "Premium",
        ["anonimus"] = "Premium",
        ["Anonimus"] = "Premium",
        ["Noychox â¢ Premium Script"] = "Script Premium desenvolvido por Noychox.",
        ["NÃ£o foi possÃ­vel pegar esse ovo. Tente novamente."] = "Não foi possível pegar este ovo. Tente novamente.",
        ["InvencÃ­vel ante guards (desync)."] = "Invencível contra os guardas (desync).",
        ["Feito por Noychox"] = "Desenvolvido por Noychox",
        ["Place / Hatch"] = "Colocar e chocar",
        ["Place Egg"] = "Colocar ovo",
        ["Auto Place (Every 5)"] = "Colocação automática (a cada 5)",
        ["Get Out Treadmill"] = "Sair da esteira",
        ["Reset Character State"] = "Redefinir estado do personagem",
        ["Unload Script"] = "Descarregar script",
        ["Single Steal"] = "Roubo individual",
    }

    return replacements[value] or value
end

local function applyNoychoxBranding(window)
    pcall(function()
        if not window then
            return
        end

        -- Identidade da janela: nome consistente e ícone de coroa premium.
        if window.SetTitle then
            window:SetTitle("Noychox Premium")
        end
        if window.EditOpenButton then
            window:EditOpenButton({
                Title = "Noychox Premium",
                Icon = "crown",
                IconThemed = true,
            })
        end

        -- Remove o modo Anonymous para que a conta não seja apresentada como anônima.
        if window.User and window.User.SetAnonymous then
            window.User:SetAnonymous(false)
        end

        local roots = {}
        if type(gethui) == "function" then
            local ok, ui = pcall(gethui)
            if ok and ui then table.insert(roots, ui) end
        end
        table.insert(roots, game:GetService("CoreGui"))
        local playerGui = game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if playerGui then table.insert(roots, playerGui) end

        for _, root in ipairs(roots) do
            for _, object in ipairs(root:GetDescendants()) do
                if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
                    local corrected = replaceText(object.Text)
                    if corrected ~= object.Text then
                        safeSet(object, "Text", corrected)
                    end
                    if object.Text == "Premium" then
                        safeSet(object, "TextColor3", Color3.fromRGB(255, 215, 90))
                    end
                elseif object:IsA("ImageLabel") or object:IsA("ImageButton") then
                    -- Substitui avatares/imagens genéricas por um ícone de coroa da biblioteca.
                    local name = string.lower(object.Name or "")
                    if string.find(name, "avatar") or string.find(name, "profile") or string.find(name, "user") then
                        safeSet(object, "Image", "rbxassetid://0")
                        safeSet(object, "ImageColor3", Color3.fromRGB(255, 215, 90))
                    end
                end
            end
        end
    end)
end

-- Execute após a criação da variável Window.
task.defer(function()
    applyNoychoxBranding(Window)
    task.wait(0.4)
    applyNoychoxBranding(Window)
    task.wait(1)
    applyNoychoxBranding(Window)
end)

return applyNoychoxBranding
