#
define ->
	class BinaryHeap
		_defaultScore = (v) -> v

		constructor: (@score = _defaultScore) ->
			@_heap = []

		push: (el) ->
			@_heap.push el
			@up @_heap.length - 1

		pop: ->
			first = @_heap[0]
			last  = @_heap.pop()
			if @_heap.length > 0
				@_heap[0] = last
				@down 0
			first

		clear: ->
			@_heap = []

		remove: (node) ->
			length = @_heap.length
			for i in @_heap
				if i is node
					last = @_heap.pop()
					if _i isnt length - 1
						@_heap[_i] = last
						if @score(last) < @score(node)
							@up _i
						else
							@down _i
					return
			throw new Error 'Node not found'

		size: ->
     		@_heap.length

		up: (n) ->
			element = @_heap[n]
			while n > 0
				parentN = Math.floor((n + 1) / 2) - 1
				parent  = @_heap[parentN]

				if @score(element) < @score(parent)
					@_heap[parentN] = element
					@_heap[n] = parent
					n = parentN
				else
					break
			return

		down: (n) ->
			length = @_heap.length
			element = @_heap[n]
			elemScore = @score element

			loop
				child2N = (n + 1) * 2
				child1N = child2N - 1
				swap = null

				if child1N < length
					child1 = @_heap[child1N]
					child1Score = @score child1
					swap = child1N if child1Score < elemScore
				if child2N < length
					child2 = @_heap[child2N]
					child2Score = @score child2
					swap = child2N if child2Score < (if swap is null then elemScore else child1Score)
				if swap isnt null
					@_heap[n] = @_heap[swap]
					@_heap[swap] = element
					n = swap
				else
					break
