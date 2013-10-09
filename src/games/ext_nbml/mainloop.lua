local wait = coroutine.yield

function fmainloop()
    local func = main_menu
    local arg = "Use arrow keys and left shift key to move.\n"
    while true do
        func,arg = func(arg)
    end
end

function main_menu(message)
    while true do
        gprint((message or "").."M: toggle sound.\n"..
            "1: play \"border of wave and particle.\"\n"..
            "2: play \"flaw of forgiving shrine.\"\n"..
            "Other key: play a random pattern.", 300, 280)
        for foo,bar in pairs(this_frame_keys) do
            if foo~="lshift" and foo~="up" and foo~="down" and
                foo~="right" and foo~="left" and foo~="m" then
                return main_play, foo
            end
        end
        wait()
    end
end

function main_play(key)
    obj_man = ObjMan()
    obj_man:register(nil, {stage_one, key})
    while true do
        obj_man:run()
        --obj_man:draw()
        if #obj_man.objects["player"] == 0 then
            return main_menu, "You died after "..tostring(floor(obj_man.age/6)/10)
                .." seconds =(\n"
        end
        wait()
    end
end
