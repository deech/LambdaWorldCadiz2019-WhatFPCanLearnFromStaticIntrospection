proc say_hello(s:string): string =
  when nimVM:
    "Hello to " & s & " at compile time!"
  else:
    "Hello to " & s & " at runtime!"

static:
  echo say_hello("Lambda World Cadiz")

echo say_hello("Lambda World Cadiz")
