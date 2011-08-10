define [
	'shared/utilities/binaryheap'
], (BinaryHeap) ->
	return ->
		describe 'BinaryHeap', ->
			it 'should work', ->
				heap = new BinaryHeap()
				unsorted = [10, 3, 4, 8, 2, 9, 7, 1, 2, 6, 5]

				heap.push i for i in unsorted
				heap.remove 2

				incr = 0
				expect(heap.pop()).toEqual(++incr) while heap.size() > 0
