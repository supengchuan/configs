-- 英文词条前后空格处理
-- 1) 当前候选是英文时：只要前一次上屏内容非空且末尾不是空白字符，就补前置空格
-- 2) 前一次上屏是英文时：当前候选包含中文且末尾不是空白字符，就补前置空格
-- 3) 标点、符号候选直接放行，避免英文后输入标点时被 shadow candidate 拦住
local F = {}

local function is_english(text)
    return text and text:match("^[%a']+$")
end

local function ends_with_english(text)
    return text and #text > 0 and text:match("[%a']$")
end

local function ends_with_space(text)
    return text and text:find("%s$")
end

local function has_cjk(text)
    return text and text:find("[\228-\233][\128-\191][\128-\191]")
end

local function is_symbol_candidate(cand)
    return cand.type == "punct"
        or cand.type == "punctuator"
        or cand.type == "symbol"
end

local function needs_space_after_english(text)
    return has_cjk(text) and not ends_with_space(text)
end

function F.func(input, env)
    local latest_text = env.engine.context.commit_history:latest_text()
    local has_prev = latest_text and #latest_text > 0
    local prev_end_space = has_prev and ends_with_space(latest_text)
    local prev_end_en = has_prev and ends_with_english(latest_text)

    for cand in input:iter() do
        local c = cand
        local add_space = false

        if is_symbol_candidate(cand) then
            add_space = false
        elseif is_english(c.text) then
            if has_prev and not prev_end_space then
                add_space = true
            end
        elseif prev_end_en and not prev_end_space then
            if needs_space_after_english(c.text) then
                add_space = true
            end
        end

        if add_space then
            c = c:to_shadow_candidate(
                "en_spacer",
                " " .. c.text,
                c.comment
            )
        end

        yield(c)
    end
end

return F
