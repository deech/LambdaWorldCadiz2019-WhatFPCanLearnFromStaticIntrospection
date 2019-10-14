import json, tables

proc addType(json: JsonNode): JsonNode =
  var res = copy(json)
  case json.kind
  of JString: newJString "string"
  of JInt: newJString "int"
  of JFloat: newJString "float"
  of JObject:
    var o = res
    for k,v in getFields(json):
      o[k] = addType(v)
    o
  of JArray:
    var res : seq[JsonNode] = @[]
    for e in getElems(json):
      res.add(addType(e))
    % res
  else: newJString "something else"

let sample {.compileTime.} : JsonNode =
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

static:
  echo sample.pretty
  echo sample.addType.pretty
