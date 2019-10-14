import strutils, sequtils, macros, sugar, sets

type
  O1 = object
    o1user_id : int
    o1Ids : seq[int]
    o1age: int
    o1user_address : string

proc gatherFields(t:typedesc): seq[(string,string)] {.compileTime.} =
  var o : t
  for n,v in fieldPairs(o):
    result.add((n,$v.type))

static:
  let o1 = gatherFields(O1)
  # echo o1
  # echo o1.filterIt(it[0].toLower.contains("ids") and it[1] == $seq[int])

type
  O2 = object
    id : int
    ids : seq[int]
    age: int
    address : string
    email: string

static:
  let o1 = gatherFields(O1)
  var o1stripped : seq[(string,string)]
  for f in o1:
    var s = f[0].toLower
    s.removePrefix("o1")
    s.removePrefix("user")
    s.removePrefix("_")
    o1stripped.add((s,f[1]))
  let o2 = gatherFields(O2)
  echo o1Stripped.toHashSet - o2.toHashSet
  echo o2.toHashSet - o1Stripped.toHashSet

