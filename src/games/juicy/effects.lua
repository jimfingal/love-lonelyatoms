require 'core.components.transform'
require 'core.components.rendering'
require 'core.components.collider'
require 'core.components.motion'
require 'core.systems.tweensystem'
require 'core.systems.schedulesystem'

require 'core.vector'

require 'enums.scenes'
require 'enums.tags'

require "settings"

require 'math'

EffectDispatcher = class("EffectsDispatcher")

function EffectDispatcher:initialize(world)

    self.world = world
    self.tween_system = world:getSystem(TweenSystem)
    self.schedule_system = world:getSystem(ScheduleSystem)

end


function EffectDispatcher:dropInBricks()

    local bricks = self.world:getEntitiesInGroup(Tags.BRICK_GROUP)

    -- Send bricks up to sky and make them smaller


    local vertical_translation = Vector(0, -300)

    for brick in bricks:members() do

        local transform = brick:getComponent(Transform)
        local shape = brick:getComponent(ShapeRendering):getShape()

        local oldx = transform:getPosition().x
        local oldy = transform:getPosition().y

        local new_position = transform:getPosition() + vertical_translation
        transform:moveTo(new_position:unpack())


        local rotate_tween = 1
        local drop_tween = 1
        local scale_tween = 1

        if Settings.BRICKS_JITTER then
            rotate_tween = 1 + math.random()
            drop_tween = 1 + math.random()
            scale_tween = 1 + math.random()

        end

        self.tween_system:addTween(drop_tween, brick:getComponent(Transform):getPosition(), {x = oldx, y = oldy}, Easing.outBounce)

        if Settings.BRICKS_ROTATE then
            self.tween_system:addTween(rotate_tween, brick:getComponent(Transform), {rotation = 2 * math.pi }, Easing.outBounce)
        end

        if Settings.BRICKS_SCALEIN then

            shape.width = 30
            shape.height = 10
            self.tween_system:addTween(scale_tween, brick:getComponent(ShapeRendering):getShape(), {width = 50, height = 20}, Easing.outBounce)

        end

    end

  
end


function EffectDispatcher:dropInPlayer()

    local player = self.world:getTaggedEntity(Tags.PLAYER)

    -- Send player up to sky and make them smaller

    local vertical_translation = Vector(0, -300)
    local transform = player:getComponent(Transform)
    local shape = player:getComponent(ShapeRendering):getShape()

    local new_position = transform:getPosition() + vertical_translation
    transform:moveTo(new_position:unpack())

    local rotate_tween = 1
    local drop_tween = 1
    local scale_tween = 1

    if Settings.PLAYER_JITTER then
        rotate_tween = 1 + math.random()
        drop_tween = 1 + math.random()
        scale_tween = 1 + math.random()

    end


    self.tween_system:addTween(drop_tween, player:getComponent(Transform):getPosition(), {x = 350, y = 500}, Easing.outBounce)

    if Settings.PLAYER_ROTATE then
        self.tween_system:addTween(rotate_tween, player:getComponent(Transform), {rotation = 2 * math.pi }, Easing.outBounce)
    end

    if Settings.PLAYER_SCALEIN then
        shape.width = 50
        shape.height = 15
        self.tween_system:addTween(scale_tween, player:getComponent(ShapeRendering):getShape(), {width = 100, height = 30}, Easing.outBounce)
    end


end


function EffectDispatcher.cameraShake()
        
    local camera = world:getSystem(CameraSystem)
    local schedule_system = world:getSystem(ScheduleSystem)
    local tween_system = world:getSystem(TweenSystem)

    intensity = 3

    local jitter = function()
        camera.transform:move(math.random(-intensity, intensity), math.random(-intensity, intensity))
    end

    schedule_system:doFor(0.3, 
        jitter,
        function()
            tween_system:addTween(0.1, camera.transform:getPosition(), {x = 0, y = 0}, Easing.linear)
        end
    )

end

function EffectDispatcher.scaleEntity(entity, dx, dy)

    local revert = 
        function()
            world:getSystem(TweenSystem):addTween(0.1, 
                entity:getComponent(Transform):getScale(), 
                {x = 1, y = 1 }, 
                Easing.linear)
        end

    local scaleUp = function()
                world:getSystem(TweenSystem):addTween(0.1, 
                    entity:getComponent(Transform):getScale(), 
                    {x = dx, y = dy }, 
                    Easing.inSine, 
                    revert)
        end

    scaleUp()
end

function EffectDispatcher.rotateEntity(entity)

    local transform = entity:getComponent(Transform)
    local current_rotation = transform:getRotation()

    local target_rotation = 0

    if current_rotation < math.pi then
        target_rotation = 2 * math.pi
    end

    world:getSystem(TweenSystem):addTween(0.1, transform, {rotation = target_rotation }, Easing.linear)

end


--[[
function EffectDispatcher.rotateJitter(entity, intensity)

    local transform = entity:getComponent(Transform)
    local current_rotation = transform:getRotation() + 0

    local rotate_jitter = function()
        transform:rotate(math.random(-intensity, intensity))
    end

    world:getSystem(ScheduleSystem):doFor(0.2, 
        rotate_jitter,
        function()
            world:getSystem(TweenSystem):addTween(0.1, transform, {rotation = current_rotation}, Easing.linear)
        end
    )

end
]]

function EffectDispatcher.allEffects(entity, dx, dy) 
    EffectDispatcher.scaleEntity(entity, dx, dy) 
    EffectDispatcher.rotateEntity(entity) 
end

--[[
    -- [ [ Player effects ]

    -- [ [ Brick Effects]


 
    -- [ [ Ball Effects ]
  local tween_system = world:getSystem(TweenSystem)
    local schedule_system = world:getSystem(ScheduleSystem)


    revertBall = function()
                    world:getSystem(TweenSystem):addTween(0.1, world:getTaggedEntity(Tags.BALL):getComponent(Transform):getScale(), {x = 1, y = 1 }, Easing.linear, getBallBig)
                end
    getBallBig = function()
            world:getSystem(TweenSystem):addTween(0.1, 
                world:getTaggedEntity(Tags.BALL):getComponent(Transform):getScale(), 
                {x = 2, y = 1.5 }, 
                Easing.inSine, 
                revertBall)
    end

    schedule_system:doFor(math.huge, function()
                    transform = world:getTaggedEntity(Tags.BALL):getComponent(Transform)
                    transform.rotation = transform.rotation + 3 * love.timer.getDelta()
                end)

    getBallBig()
--]]

return EffectDispatcher