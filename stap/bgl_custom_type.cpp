#include <fstream>
#include <boost/graph/graphviz.hpp>
#include <boost/graph/properties.hpp>

struct Colour {
  std::string s;
  Colour() : s("blue") {}
};

std::istream& operator>>(std::istream &is, Colour &obj) {
  is >> obj.s;
  return is;
}

std::ostream& operator<<(std::ostream &os, const Colour &obj) {
  os << obj.s;
  return os;
}

namespace boost {
  enum vertex_my_colour_t { vertex_my_colour };
  template <> struct property_kind<vertex_my_colour_t> {
      typedef vertex_property_tag type;
  };
}

typedef boost::property < boost::vertex_name_t, std::string,
  boost::property < boost::vertex_my_colour_t, Colour > > vertex_p;
typedef boost::no_property edge_p;
typedef boost::property < boost::graph_name_t, std::string > graph_p;

typedef boost::adjacency_list < boost::vecS, boost::vecS, boost::directedS,
  vertex_p, edge_p, graph_p > graph_t;

int main(int argc, char **argv)
{
  graph_t graph(0);
  boost::dynamic_properties dp;

  boost::property_map<graph_t, boost::vertex_name_t>::type name =
    get(boost::vertex_name, graph);
  dp.property("node_id", name);

  boost::ref_property_map<graph_t*,std::string>
    gname(get_property(graph,boost::graph_name));
  dp.property("name", gname);

  boost::property_map<graph_t, boost::vertex_my_colour_t>::type my_colour =
    get(boost::vertex_my_colour, graph);
  dp.property("color", my_colour);

  std::istringstream gvgraph(argv[1]);
  boost::read_graphviz(gvgraph,graph,dp,"node_id");
  boost::write_graphviz_dp(std::cout, graph, dp);
}

