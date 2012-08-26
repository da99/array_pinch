
path = require "path"
assert = require 'assert'
pinch = require "array_pinch"

is_2 = (val) ->
  val is 2
is_5 = (val) ->
  val is 5

assert_obj_equal = (a, b) =>
  for k,v of a
    assert.deepEqual v, b[k]

describe "array_pinch", () ->

  describe ".describe_slice", () ->
    
    it "returns null if slice is not found", () ->
      results = pinch([ 1, 3, 3, 4 ]).describe_slice [is_2, is_5]
      assert.equal results, null

    it "returns an object describing the slice", () ->
      results = pinch([1,2,3,4,5,6]).describe_slice [is_2, is_5]

      assert_obj_equal results, {
        slice:       [2,3,4,5],
        start_index: 1
        end_index:   5
        length:      4
        indexs:      [1, 2, 3, 4]
      }

    it "starts search based on given offset", () ->
      results = pinch([1,2,3,4,5,6,1,2,3,4,5,6]).describe_slice [is_2, is_5], 5
      
      assert_obj_equal results, {
        start_index: 7,
        end_index:   11,
        length:      4,
        slice:       [2, 3, 4, 5]
        indexs:      [7, 8, 9, 10]
      }
     
    it "passes index of element to finder function", () ->
      i_s = []
      func = (v, i) ->
        i_s.push i
        false
      pinch([0,2,4,6]).describe_slice [func,func]
      assert.deepEqual i_s, [0,1,2,3]

    it "passes index/position of sequence as 3rd argument to finder", () ->
      i_s = []
      
      is_2 = (v, i, j) ->
        i_s.push j
        v is 2
        
      is_6 = (v, i, j) ->
        i_s.push j
        v is 6
        
      pinch([0,2,4,6,8]).describe_slice [is_2, is_6]
      assert.deepEqual i_s, [0,0,1,2]

  describe ".replace_all", () ->
    
    it "replaces all sequences", () ->
      hay = [ 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6 ]
      results = pinch(hay).replace_all [ is_2, is_5 ], "gone"
      assert.deepEqual results, [ 1, "gone", 6, 1, "gone", 6 ]
      
  describe ".replace", () ->
    
    it "replaces elements", () ->

      results = pinch([ 1, 2, 3, 4, 5 ]).replace [ 2, 4 ], "missing"
      assert.deepEqual results, [ 1, "missing",  5 ]

    it "replaces only one sequence", () ->
      hay = [ 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6 ]
      results = pinch(hay).replace [ is_2, is_5 ], "gone"
      assert.deepEqual results, [ 1, "gone", 6, 1, 2, 3, 4, 5, 6 ]
    
    it "replaces elements using functions for comparison", () ->

      results = pinch([ 1, 2, 3, 4, 5, 6 ]).replace [is_2, is_5], "missing"
      assert.deepEqual results, [ 1, "missing",  6 ]

    it "replaces elements with return of callback", () ->

      results = pinch([ 1, 2, 3, 4, 5, 6 ]).replace [ is_2, is_5 ], (slice, props) ->
        slice.join(",")
        
      assert.deepEqual results, [ 1, "2,3,4,5",  6 ]
      
    it "returns a new array, not altering the original", () ->
      orig = [ 1, 2, 3, 4, 5, 6 ]
      target = orig.slice(0)
      results = pinch(orig).replace [ is_2, is_5 ], "new"
        
      assert.deepEqual orig, target
      
  describe ".remove_all", () ->
    
    it "removes all sequences", () ->
      hay = [ 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6 ]
      results = pinch(hay).remove_all [ is_2, is_5 ]
      assert.deepEqual results, [ 1, 6, 1, 6 ]

  describe ".remove", () ->
    
    it "removes elements based on callback", () ->

      results = pinch([ 1, 2, 3, 4, 5, 6 ]).remove [ is_2, is_5 ]
      assert.deepEqual results, [ 1,  6 ]

    it "removes only one sequence", () ->
      hay = [ 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6 ]
      results = pinch(hay).remove [ is_2, is_5 ]
      assert.deepEqual results, [ 1, 6, 1, 2, 3, 4, 5, 6 ]
     
    it "returns a new array, not altering the original", () ->
      orig = [ 1, 2, 3, 4, 5, 6 ]
      target = orig.slice(0)
      results = pinch(orig).remove [ is_2, is_5 ]
        
      assert.deepEqual orig, target

     
