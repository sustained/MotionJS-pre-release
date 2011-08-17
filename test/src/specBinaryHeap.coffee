define [
	'utilities/binaryheap'
], (BinaryHeap) ->
	return ->
		describe 'BinaryHeap', ->
			it 'should work', ->
				incr = 0
				heap = new BinaryHeap()
				list = [10, 3, 4, 8, 2, 9, 7, 1, 2, 6, 5]

				heap.push i for i in list
				heap.remove 2
				expect(heap.pop()).toEqual(++incr) while heap.size() > 0
