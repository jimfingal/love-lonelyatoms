
require 'external.middleclass'
require 'core.entity.entitybuilder'

BackgroundSoundBuilder  = class('BackgroundSoundBuilder', EntityBuilder)

function BackgroundSoundBuilder:initialize(world)
    EntityBuilder.initialize(self, world, 'background sound')
    return self
end

function BackgroundSoundBuilder:create()

	EntityBuilder.create(self)
   
    local asset_manager = self.world:getAssetManager()
    local bsnd = "You_Kill_My_Brother_-_07_-_Micro_Invasion_-_You_Kill_My_Brother_-_Go_Go_Go.mp3"

    local this_sound = asset_manager:loadSound(Assets.BACKGROUND_SOUND, bsnd)
    this_sound:setVolume(0.25)
    this_sound:setLooping(true)
    this_sound:play()
    
    self.entity:addComponent(SoundComponent():addSound(Assets.BACKGROUND_SOUND, this_sound))
    self.entity:tag(Tags.BACKGROUND_SOUND)
    self.entity:addToGroup(Tags.PLAY_GROUP)

end