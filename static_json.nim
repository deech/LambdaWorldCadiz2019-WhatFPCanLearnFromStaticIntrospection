import json, macros

type
  J = object
    key: int

static:
  let json =
    """
    {
        "key": 3.14
    }
    """
  echo getTypeImpl(getTypeInst(J))
  echo  to(parseJson(json), J)
