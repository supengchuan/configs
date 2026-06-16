-- Enter 上屏英文原始输入时自动补前置空格
local processor = {}

local function is_english(text)
    return text and text:match("^[%a']+$")
end

local function ends_with_space(text)
    return text and text:find("%s$")
end

function processor.func(key, env)
    if key:release() or key:repr() ~= "Return" then
        return 2
    end

    local engine = env.engine
    local context = engine.context
    if not context:is_composing() then
        return 2
    end

    local input = context.input
    if not is_english(input) then
        return 2
    end

    local latest_text = engine.context.commit_history:latest_text()
    local has_prev = latest_text and #latest_text > 0
    local prev_end_space = has_prev and ends_with_space(latest_text)
    local commit_text = input

    if has_prev and not prev_end_space then
        commit_text = " " .. commit_text
    end

    engine:commit_text(commit_text)
    context:clear()
    return 1
end

return processor
