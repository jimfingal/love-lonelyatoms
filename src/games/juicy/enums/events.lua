-- Events that are triggered during the game. When an event is triggered, 
-- it is sent to the MessageSystem, which forwards the message on 
-- entities that need to respond to the event.

Events = {}

Events.BALL_COLLISION_PLAYER = "ballcollisionplayer"
Events.BALL_COLLISION_WALL = "ballcollisionwall"
Events.BALL_COLLISION_BRICK = "ballcollisionbrick"

return Events