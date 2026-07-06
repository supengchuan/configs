-- 中文模式下按 Esc：有输入码时取消输入；无输入码时切换到英文模式并放行 Esc
local processor = {}

function processor.func(key, env)
    if key:release() or key:repr() ~= "Escape" then
        return 2
    end

    local context = env.engine.context
    if context:get_option("ascii_mode") then
        return 2
    end

    if context:is_composing() then
        context:clear()
        return 1
    end

    context:set_option("ascii_mode", true)
    return 2
end

return processor
