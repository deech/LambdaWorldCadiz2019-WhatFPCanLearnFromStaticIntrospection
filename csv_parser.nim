import streams, parsecsv, strutils

proc readCsv(s:string): seq[seq[string]] =
  var p: CsvParser
  p.open(newStringStream(s),"input")
  while p.readRow():
   result.add(p.row)
  p.close

# const parsed = readCsv(staticRead("large.csv"))
let parsed = readCsv(readFile("large.csv"))

echo "A number: "
var idx = stdin.readline.parseInt
echo parsed[idx]

echo "A number: "
idx = stdin.readline.parseInt
echo parsed[idx]
