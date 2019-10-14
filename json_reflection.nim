import json, tables, sequtils, typetraits, macros

proc toTuple(json: JsonNode): NimNode =
  case json.kind
  of JObject:
    var o = newTree(nnkTupleConstr)
    for k,v in getFields(json):
      o.add nnkExprColonExpr.newTree(newIdentNode(k), toTuple(v))
    return o
  of JArray:
    if getElems(json).len == 0:
      error "Can't determine type of array"
    else:
      var res : seq[JsonNodeKind] = @[]
      for e in getElems(json):
        res.add(e.kind)
      let allTypes = deduplicate(res)
      if allTypes.len > 1:
        error "Found multiple types in array: " & $allTypes
      else:
        let arr = newNimNode(nnkBracket)
        for e in getElems(json):
          arr.add(toTuple(e))
        return newTree(nnkPrefix, newIdentNode "@", arr)
  of JString: return newLit(getStr(json))
  of JInt: return newLit getInt(json)
  of JFloat: return newLit getFloat(json)
  else: error "something else"

let sample {.compileTime.} =
  %*
  {
    "id": "a12345",
    "age": 30,
    "address":
      {
        "street": "10 Main St.",
        "zip": 54321
      },
    "grades" : [100,80,50]
  }

macro toTuple(): untyped =
  let json = sample
  toTuple(json)

static:
  echo ""
#  echo toTuple()
#  echo toTuple().type
#  echo toTuple().type.getTypeInst.lispRepr(indented=true)

let real =
  %*
  {
    "id": "11111-xxxx-1111",
    "age": 25,
    "address":
      {
        "street": "10 Some Real Street",
        "zip": 12345
      },
    "grades" : [10,10,10]
  }

echo to(real,toTuple().type)
