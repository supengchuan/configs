-- 英文词条前后空格处理
-- 1) 当前候选是英文时：只要前一次上屏内容非空且末尾不是空白字符，就补前置空格（中文/英文/符号前都加）
-- 2) 前一次上屏是英文时：当前候选即使不是英文，只要不是纯数字且末尾不是空白字符，也补前置空格
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

local function is_pure_digits(text)
    return text and text:match("^%d+$")
end

function F.func(input, env)
    local latest_text = env.engine.context.commit_history:latest_text()
    local has_prev = latest_text and #latest_text > 0
    local prev_end_space = has_prev and ends_with_space(latest_text)
    local prev_end_en = has_prev and ends_with_english(latest_text)

    for cand in input:iter() do
        local c = cand
        local add_space = false

        if is_english(c.text) then
            if has_prev and not prev_end_space then
                add_space = true
            end
        elseif prev_end_en and not prev_end_space then
            if not is_pure_digits(c.text) and not ends_with_space(c.text) then
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
