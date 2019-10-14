import macros, strutils

proc lex(s:string):(seq[string], int) =
  let
    l = s.len
  var
    i = 0
    curr = ""
    res : seq[string] = @[]
    formats = 0
  template addChunk() =
    if (curr.len != 0):
      res.add(curr)
      curr = ""
  while i < l :
    if i < l-1 and s[i] == '%':
      addChunk
      res.add(s[i] & s[i+1])
      formats.inc
      i.inc 2
    else:
      curr.add(s[i])
      i.inc
  addChunk
  return (res, formats)

# static:
#   echo lex("Some string %s, some number %d")

macro printf(s:string, args: varargs[typed]):untyped =
  let (chunks, numFs) = lex $s
  if numFs != args.len:
    error "# of format specifiers: " & $numFs & ", does not match # of supplied arguments: " & $args.len
  var curr = 0
  result = newStmtList()
  var res = genSym(nsKVar, "res")
  result.add(newVarStmt(res, newLit ""))
  template argIs(t:typedesc): bool =
    typeKind(getType(args[curr])) == typeKind(getType(t))
  template err(s:string) =
    error "Argument of type " & $getTypeImpl(args[curr]) & " can't be used with format specifier " & s & ".", args[curr]
  template build(n:NimNode) =
    result.add(newCall("add", res, n))
    inc curr
  template help(s:string) =
    error "Try " & s, args[curr]
    inc curr
  for c in chunks:
    case c
    of "%d" :
      if argIs(int):
        build newCall("intToStr", args[curr])
      else:
        err("%d")
    of "%s" :
      if argIs(string):
        build args[curr]
      else:
        err("%s")
    # of "%_":
    #   if argIs(string):
    #     help("%s")
    #   elif argIs(int):
    #     help("%d")
    else:
      result.add(newCall("add", res, newLit c))
  result.add(newCall("echo", res))

# printf("some string %s, some number %d")
# printf("some string %s, some number %d", "astring", 1)
# printf("some string %s, some number %d", 1, "astring")
# printf# ("some string %_, some number %d", "astring", 1)
