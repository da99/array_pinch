_ = require "underscore"

class Pinch
  @compare: (obj, target, i, count) ->
    if typeof(target) is "function"
      target(obj, i, count)
    else
      obj is target

  constructor: (hay) ->
    @hay = hay
    
  describe_slice:  (finders, offset) ->
    start = finders[0]
    end   = finders[1]
    if !start or !end
      throw new Error("Both start and end finders needed: #{finders}")
    
    arr = @hay
    final = 
      start_index: null
      end_index: null
      length: 0
    
    offset ?= 0
    end_limit = arr.length - 1
    i = (offset - 1)
    
    while i < end_limit and (final.length is 0)
      i += 1
      count = 0
      start_i  = i
      end_i    = null
      is_start = @constructor.compare(arr[i], start, i, count)
      
      if is_start
        next_i   = i+1
        while next_i < end_limit
          count += 1
          is_end = @constructor.compare(arr[next_i], end, next_i, count)
          
          next_i += 1
          if is_end
            end_i = next_i
            break

      if end_i
        final.start_index = start_i
        final.end_index   = end_i
        final.slice       = arr.slice(start_i, end_i)
        final.length      = final.slice.length
        final.indexs      = _.range( final.start_index, final.end_index )
        break

    return null if final.length is 0
    final

  alter_all: (meth, args...) ->
    new_arr = @hay
    alter = () ->
      new_arr = module.exports(new_arr)[meth](args...)
      new_arr
    
    while !_.isEqual(new_arr, alter())
      new_arr

    new_arr

  remove_all: (args...) ->
    @alter_all("remove", args...)
    
  replace_all: (args...) ->
    @alter_all "replace", args...

  remove: (args...) ->
    @replace args...
    
  replace: (finders, replace) ->
    return @hay if @hay.length < finders.length
    arr = @hay.slice(0)
    i = -1
    l = arr.length
    while i < l
      i += 1
      
      meta = module.exports(arr).describe_slice(finders, i)
      break unless meta
      i = meta.end_index - 1
      splice_args = [ meta.start_index, meta.length ]
      
      if typeof(replace) is 'function'
        splice_args.push replace(meta.slice) 
      else if typeof(replace) != 'undefined'
        splice_args.push replace
        
      arr.splice splice_args...
      l = arr.length
      break

    arr

    
module.exports = (hay) ->
  new Pinch(hay)
