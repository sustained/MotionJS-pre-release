require ['core', 'test/all'], (Motion, testList) ->
	jasmineEnv = jasmine.getEnv()
	jasmineEnv.updateInterval = 1000

	trivialReporter = new jasmine.TrivialReporter()
	jasmineEnv.addReporter trivialReporter

	jasmineEnv.specFilter = (spec) -> trivialReporter.specFilter spec

	testList = _.map(testList, (test) -> "test/#{test}.spec")

	require testList, ->
		jQuery -> jasmineEnv.execute()
