import std.regex;
import std.stdio;
import std.container;
import std.algorithm;
import std.range;
import std.file;
void main()
{
  const prime = import("largeprime.txt");
  auto r = ctRegex!(`^(11+?)\1+$`);
  if (match(prime, r))
    writeln("not prime");
  else
    writeln("prime");
}
