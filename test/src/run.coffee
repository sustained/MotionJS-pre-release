require ['shared/core', 'test/all'], (Motion, testList) ->
	jasmineEnv = jasmine.getEnv()
	jasmineEnv.updateInterval = 1000

	trivialReporter = new jasmine.TrivialReporter()
	jasmineEnv.addReporter trivialReporter

	jasmineEnv.specFilter = (spec) -> trivialReporter.specFilter spec

	testList = _.map(testList, (test) -> "test/spec#{test.charAt(0).toUpperCase()}#{test.slice 1}")
	require testList, ->
		defineTest() for defineTest in Array::slice.call arguments
		jQuery -> jasmineEnv.execute()
