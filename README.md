
array\_pinch
=============

Find a slice in an array matching a start/end pair and remove or replace them.

    arr = [1,2,3,4,5,6]
    pinch(arr).remove [3,5]
    # ===> [ 1, 2, 6 ]

Differences with array\_surgeon
===============================

The npm package, `array_surgeon`, requires you to be more explicit:

    arr = [1,2,3,4,5,6]
    surgeon(arr).remove [3,4,5]
    # ===> [ 1, 2, 6 ]



Installation & Usage
====

    shell> npm install array_pinch

    pinch = require 'array_pinch'

    hay = [ 1, 2, 3, 4, 5, 6 ]
    
    // You can use a regular array
    pinch(hay).remove [ 2, 5 ]
    # ==> [ 1, 6 ]
   
    pinch(hay).replace [ 2, 5 ], "missing"
    # ==> [ 1, "missing", 6 ]


Using Functions for Comparison
==============================

You can also use a function for comparision:

    is_2 = (val) ->
      val is 2
      
    is_5 = (val) ->
      val is 5
      
    pinch(hay).remove [ is_2, is_5 ]
    # ==> [ 1,  6 ]
   
    pinch(hay).replace [ is_2, is_5 ], "missing"
    # ==> [ 1, "missing", 6 ]

The comparison function also accepts two other arguments:

  * arr\_i: the position of the value within the array.
  * finder\_i: the position of the comparison function within the array of finders.

Example:

    is_2 = (val, arr_i, finder_i) ->
      console.log "Checking #{val} at position #{arr_i} with finder at #{finder_i}"
      val is 2


Get Info on a Slice
================
You can also get info on the first slice that matches your slice:

    pinch(hay).describe_slice [ is_2, is_5 ]
    
    # ==> 
    { 
      start_index: 1, 
      end_index:   4, 
      length:      4,
      slice:       [2, 3, 4, 5]
    }
   
  
