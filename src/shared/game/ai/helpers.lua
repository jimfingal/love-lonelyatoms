
AIHelpers = {}

function AIHelpers.setVectorTowardOther(vector, position, target)

	vector:copy(target)
	vector:subtract(position)

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

