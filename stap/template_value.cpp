#include <iostream>
#include <cassert>

std::string Black() {
  return "black";
}

std::string Red() {
  return "red";
}

template<std::string(*T)()>
struct DefaultString {
  std::string s;
  DefaultString() : s(T()) {}
};

int main()
{
  DefaultString<Black> black1, black2, black3;
  assert(black1.s == black2.s && black2.s == black3.s);
  std::cout << black1.s << std::endl;

  DefaultString<Red> red;
  std::cout << red.s << std::endl;

  DefaultString<Black> colour;
  std::cout << colour.s << std::endl;

  colour.s = "white";
  std::cout << colour.s << std::endl;
}

