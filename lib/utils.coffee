
isData = (val) -> val isnt undefined and typeof(val) isnt 'function'
merge = (target, sources...) ->
	for source, index in sources
		for own key, value of source 
			if isData(value) then target[key] = value
	target
exports.isData = isData
exports.merge = merge
#merge exports, {merge: merge, isData: isData}
