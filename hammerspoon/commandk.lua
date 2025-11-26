-- Quick Prompt → LLM → Paste (Gemini)
-- 1) You press a hotkey
-- 2) A small input asks what to do ("summarize", "translate to fr", "explain like I'm 5", etc.)
-- 3) It sends:  <your prompt> + the currently selected text  → Gemini
-- 4) By default it replaces the selection with the result (or preview if you choose)

local module = {}

-- ===== Config =====
-- Prefer env var to avoid hardcoding keys in dotfiles:
local apiKey    = GEMINI_API_KEY -- put your key in the env, or set here
local modelName = "gemini-flash-lite-latest"
local temperature = 0.2
local maxTokens   = 8000

-- Change this if you want preview by default
local defaultReplaceSelection = true

-- ===== Helpers =====
local function jescape(s)
  return (s or "")
    :gsub('\\','\\\\')
    :gsub('"','\\"')
    :gsub('\n','\\n')
    :gsub('\r','\\r')
end

local function reactivate(app)
    if app and app.activate then
      app:activate(true)      -- bring to front, all windows
      hs.timer.usleep(120000) -- ~120ms to let focus settle
    end
  end

local function buildPayload(userPrompt, selectedText)
  -- You control the instruction; we add minimal rails so the model returns just the text
  local text = "Instruction: " .. userPrompt ..
               "\n\nText:\n" .. selectedText ..
               "\n\nReturn only the final result (no explanations, no markdown fences)."
  return [[{
    "contents": [{"role": "user", "parts": [{"text": "]] .. jescape(text) .. [["}]}],
    "generationConfig": {
      "temperature": ]] .. tostring(temperature) .. [[,
      "maxOutputTokens": ]] .. tostring(maxTokens) .. [[
    }
  }]]
end

local function callGemini(userPrompt, selectedText, onDone, onError)
  if apiKey == "" then
    onError("Missing GEMINI_API_KEY (set an env var or edit the script).")
    return
  end
  local endpoint = "https://generativelanguage.googleapis.com/v1beta/models/"
                    .. modelName .. ":generateContent?key=" .. apiKey
  local payload = buildPayload(userPrompt, selectedText)

  local start = hs.timer.secondsSinceEpoch()
  local task = hs.task.new("/usr/bin/curl", function(exitCode, stdout, stderr)
    local ms = math.floor((hs.timer.secondsSinceEpoch() - start) * 1000)
    if exitCode ~= 0 then
      onError("API request failed: " .. (stderr or "unknown error"))
      return
    end
    local ok, resp = pcall(function() return hs.json.decode(stdout) end)
    if not ok or not resp then
      onError("Failed to parse API response")
      return
    end
    if resp.error then
      onError("API error: " .. (resp.error.message or "Unknown"))
      return
    end
    local outText = resp
      and resp.candidates and resp.candidates[1]
      and resp.candidates[1].content and resp.candidates[1].content.parts
      and resp.candidates[1].content.parts[1]
      and resp.candidates[1].content.parts[1].text
    if not outText or outText == "" then
      onError("Empty response from model")
      return
    end
    hs.logger.new("LLMQuickPrompt", "info"):i("Done in " .. ms .. " ms")
    onDone(outText)
  end, { "-s","-X","POST","-H","Content-Type: application/json","-d", payload, endpoint })
  task:start()
end

local function copySelection()
    -- Save original clipboard so we can restore later
    local originalClipboard = hs.pasteboard.getContents()
    local originalChange = hs.pasteboard.changeCount()
  
    -- Send ⌘C
    hs.eventtap.keyStroke({"cmd"}, "c")
  
    -- Wait up to ~500 ms for changeCount to update; poll a few times
    local attempts, maxAttempts = 0, 8
    local gotChange = false
    while attempts < maxAttempts do
      hs.timer.usleep(80000) -- 80 ms per try
      if hs.pasteboard.changeCount() ~= originalChange then
        gotChange = true
        break
      end
      attempts = attempts + 1
    end
  
    -- Read whatever is available (even if changeCount didn't tick)
    local now = hs.pasteboard.getContents()
  
    -- If we truly have nothing textual, bail out
    if not now or (type(now) == "string" and now:match("^%s*$")) then
      return nil, originalClipboard
    end
  
    -- We have text; return it + the original clipboard for later restore
    return now, originalClipboard
  end

  local function pasteReplace(text, originalClipboard)
    hs.pasteboard.setContents(text)
    hs.timer.usleep(3000)  -- give pasteboard a tick
    hs.eventtap.keyStroke({"cmd"}, "v")
    hs.timer.doAfter(0.12, function()
      if originalClipboard ~= nil then hs.pasteboard.setContents(originalClipboard) end
    end)
  end

local function previewResult(text, originalClipboard)
  -- show a quick chooser so you can Paste / Copy / Alert
  local choices = {
    {text="Paste here", subText="Replace current selection", action="paste"},
    {text="Copy",       subText="Only copy to clipboard",   action="copy"},
    {text="Alert",      subText="Peek result",              action="alert"},
  }
  local chooser = hs.chooser.new(function(choice)
    if not choice then return end
    if choice.action == "paste" then
      pasteReplace(text, originalClipboard)
    elseif choice.action == "copy" then
      hs.pasteboard.setContents(text)
      hs.alert.show("Copied")
    else
      hs.alert.show(text, 2.5)
    end
  end)
  chooser:choices(choices)
  chooser:rows(#choices)
  chooser:width(25)
  chooser:placeholderText("Result ready")
  chooser:show()
end

-- put near the top of the module
local inFlight = false

local function copySelection()
    -- Save original clipboard so we can restore later
    local originalClipboard = hs.pasteboard.getContents()
    local originalChange = hs.pasteboard.changeCount()
  
    -- Send ⌘C
    hs.eventtap.keyStroke({"cmd"}, "c")
  
    -- Wait up to ~500 ms for changeCount to update; poll a few times
    local attempts, maxAttempts = 0, 8
    local gotChange = false
    while attempts < maxAttempts do
      hs.timer.usleep(80000) -- 80 ms per try
      if hs.pasteboard.changeCount() ~= originalChange then
        gotChange = true
        break
      end
      attempts = attempts + 1
    end
  
    -- Read whatever is available (even if changeCount didn't tick)
    local now = hs.pasteboard.getContents()
  
    -- If we truly have nothing textual, bail out
    if not now or (type(now) == "string" and now:match("^%s*$")) then
      return nil, originalClipboard
    end
  
    -- We have text; return it + the original clipboard for later restore
    return now, originalClipboard
  end

  function module.runQuickPrompt()
    if inFlight then
      hs.alert.show("LLM: already running")
      return
    end
  
    -- Remember the target app BEFORE we open the prompt (so we can return focus to it)
    local targetApp = hs.application.frontmostApplication()
  
    -- 1) Ask for the prompt first
    local btn, prompt = hs.dialog.textPrompt(
      "Command on selection",
      "Describe what to do (e.g., “summarize in 3 bullets”, “translate to French”, “explain simply”).\nPrefix '!' to auto-paste, '?' to preview.",
      "",
      "Run",
      "Cancel"
    )
  
    if btn ~= "Run" or not prompt or prompt:match("^%s*$") then
      return
    end
  
    -- Re-activate the target app before trying to copy
    reactivate(targetApp)
  
    -- 2) Copy selection (now that focus is back on the original app)
    local selected, originalClipboard = copySelection()
    if not selected then
      hs.alert.show("Please select text first")
      return
    end
  
    -- 3) prefix controls
    local forceReplace, forcePreview = false, false
    if prompt:sub(1,1) == "!" then
      forceReplace = true; prompt = prompt:sub(2):gsub("^%s+","")
    elseif prompt:sub(1,1) == "?" then
      forcePreview = true; prompt = prompt:sub(2):gsub("^%s+","")
    end
  
    local shouldReplace = defaultReplaceSelection
    if forceReplace then shouldReplace = true end
    if forcePreview then shouldReplace = false end
  
    -- 4) Call the model
    inFlight = true
    callGemini(
      prompt,
      selected,
      function(output)
        if shouldReplace then
          -- Focus may have drifted again while the API call ran; bring the app back, then paste
          reactivate(targetApp)
          pasteReplace(output, originalClipboard)
        else
          previewResult(output, originalClipboard)
        end
        inFlight = false
      end,
      function(err)
        hs.alert.show(err)
        inFlight = false
      end
    )
  end

-- Set up the hotkey (Cmd+;)
local hotkey = hs.hotkey.bind({"cmd","alt"}, "k", module.runQuickPrompt)


return module