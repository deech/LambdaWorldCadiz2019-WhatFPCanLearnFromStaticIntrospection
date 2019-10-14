import std.regex;
import std.stdio;
import std.file;

void main()
{
  const learnXInY = readText("learn-x-in-y.txt");
  auto r = regex(`^.*/([^/]+)/?$`);
  // auto r = r"[\w\.+-]+@[\w\\.-]+\.[\w\.-]+";
  int count = 0;
  foreach(m; matchAll(learnXInY,r))
    { count ++; }
  writeln(count);
}
