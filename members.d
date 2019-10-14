import std.stdio;

struct S
{
  int anInt;
  string aString;
};

pragma(msg, __traits(allMembers,S));
pragma(msg, typeof(__traits(getMember, S, "anInt")));
pragma(msg, typeof(__traits(getMember, S, "foo")));

class C
{
  int anInt;
  string aString;
}
pragma(msg, __traits(allMembers,C));

void main() {}
