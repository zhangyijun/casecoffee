describe 'utils', ->
	noit = (descr, func) -> descr
	utils = require '../lib/utils'
	isData = utils.isData
	merge = utils.merge
	func = Array.prototype.slice

	it 'isData', ->
		expect(isData('string')).toBe true
		expect(isData(0)).toBe true
		expect(isData(false)).toBe true
		expect(isData(null), 'null keep as data').toBe true

		expect(isData(undefined), 'undefined ignore').toBe false
		expect(isData(func), 'function not data').toBe false

	it 'merge', ->
		src1 = {a: 1, b: 2}
		src2 = {x: 'a', y: 'b'}
		src3 = {z: 'c'}
		src4 = {z: undefined}
		src5 = {z: func}

		dest = {}
		merge dest, src1, src2, src3, src4, src5
		expect(dest.a).toBe 1
		expect(dest.z).toBe 'c'
