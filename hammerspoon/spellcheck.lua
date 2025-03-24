-- Gemini Spellcheck for Hammerspoon
-- Spellcheck selected text using Gemini API

local module = {}

-- Replace with your actual Gemini API key
local apiKey = "AIzaSyCVHPNN5J72jIxu5Z9zBEu0tzpqNM8mPwc"

-- Instruction for the spellcheck model
local instruction = [[
Fix typing errors (flipped letters, missed spaces, repeated words) and punctuation, but keep exact capitalization where possible. This is intended for casual, quick keyboard typing rather than formal text. Correct spelling mistakes, missing spaces, and accented characters, especially in languages like French and Spanish. Aim to minimally alter the original writing, preserving the informal tone and style as much as possible.

Examples:

Input: 'im raelly bad at typign when i rush through texts.'
Output: 'im really bad at typing when i rush through texts.'

Input: 'Can you beleive this hapepned again?'
Output: 'Can you believe this happened again?'

Input: 'thsi sentence is a totla disaster but stil understandable.'
Output: 'this sentence is a total disaster but still understandable.'

Input: 'elle aimerais prendre un cafe apres lemidi.'
Output: 'elle aimerait prendre un café après l'après-midi.'

Input: 'hay un probleam con la reservacion que hizimos ayer'
Output: 'hay un problema con la reservación que hicimos ayer'

Input: 'avez vous recu le mail que j'ai envoye hieer?'
Output: 'avez-vous reçu le mail que j'ai envoyé hier ?'

Now fix this text: 
]]

function module.spellcheckText()
    -- Select all text
    hs.eventtap.keyStroke({"cmd"}, "a")
    hs.timer.usleep(5000) -- 5ms delay

    -- Copy selected text
    hs.eventtap.keyStroke({"cmd"}, "c")
    hs.timer.usleep(2000) -- 2ms delay

    -- Get clipboard content
    local text = hs.pasteboard.getContents()

    if not text or text == "" then
        hs.alert.show("No text found in clipboard")
        return
    end

    -- Escape special characters in the text for JSON
    local escapedText = text:gsub('\\', '\\\\'):gsub('"', '\\"'):gsub('\n', '\\n')
    local escapedInstruction = instruction:gsub('\\', '\\\\'):gsub('"', '\\"'):gsub('\n', '\\n')
    
    -- Create the request payload
    local payload = [[{
        "contents": [
            {
                "role": "user",
                "parts": [
                    {
                        "text": "]] .. escapedInstruction .. escapedText .. [[\n\nReturn only fixed text."
                    }
                ]
            }
        ],
        "generationConfig": {
            "temperature": 0.2,
            "maxOutputTokens": 8192
        }
    }]]
    
    -- Set up the API request
    local endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=" .. apiKey
    
    -- Record start time with millisecond precision
    local startTime = hs.timer.secondsSinceEpoch()
    
    -- Create curl command
    local task = hs.task.new("/usr/bin/curl", function(exitCode, stdOut, stdErr)
        -- Calculate elapsed time in milliseconds
        local elapsedTime = hs.timer.secondsSinceEpoch() - startTime
        local elapsedMs = math.floor(elapsedTime * 1000)
        
        if exitCode ~= 0 then
            hs.alert.show("API request failed: " .. (stdErr or "Unknown error"))
            return
        end
        
        -- Parse the JSON response
        local success, response = pcall(function() return hs.json.decode(stdOut) end)
        
        if not success or not response then
            hs.alert.show("Failed to parse API response")
            return
        end
        
        -- Check for errors in the response
        if response.error then
            hs.alert.show("API error: " .. (response.error.message or "Unknown API error"))
            return
        end
        
        -- Extract corrected text
        local correctedText = nil
        if response.candidates and response.candidates[1] and 
           response.candidates[1].content and response.candidates[1].content.parts and 
           response.candidates[1].content.parts[1] then
            correctedText = response.candidates[1].content.parts[1].text
        end
        
        if not correctedText then
            hs.alert.show("Could not extract corrected text from response")
            return
        end
        
        -- Copy corrected text to clipboard
        hs.pasteboard.setContents(correctedText)

        -- Paste back into the text field
        hs.timer.usleep(1000) -- 1ms delay
        hs.eventtap.keyStroke({"cmd"}, "v")

        hs.logger.new("Spellcheck", "info"):i("Spellcheck completed in " .. elapsedMs .. " ms")
    end, {
        "-s",
        "-X", "POST",
        "-H", "Content-Type: application/json",
        "-d", payload,
        endpoint
    })

    task:start()
end

-- Set up the hotkey (Cmd+;)
local hotkey = hs.hotkey.bind({"cmd"}, ";", module.spellcheckText)

-- Return the module
return module