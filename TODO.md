* Add a Schedule class
	* allows functions to be scheduled to run after/every n frames/seconds/miliseconds
	* should probably run on frame enter
	* API will probably be like:
		schedule.every(60).frames(fn)
		schedule.after(10).seconds(fn)
		etc.
