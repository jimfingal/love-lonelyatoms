
AIHelpers = {}

function AIHelpers.setVectorTowardOther(vector, entity, target)

	local entity_position = entity:getComponent(Transform):getPosition()
	local target_position = target:getComponent(Transform):getPosition()

	vector:copy(target_position)
	vector:subtract(entity_position)

end

function AIHelpers.setVectorAwayFromOther(vector, entity, target)

   	AIHelpers.setVectorTowardOther(vector, entity, target)

  	vector:negative()

end

function AIHelpers.scaleVectorToMaxAcceleration(vector, entity)

	vector:normalize_inplace()
  	vector:multiply(entity:getComponent(Motion).maxAcceleration:len())

end

function AIHelpers.scaleVectorToMaxVelocity(vector, entity)

	vector:normalize_inplace()
  	vector:multiply(entity:getComponent(Motion).maxVelocity:len())

end


return AIHelpers

