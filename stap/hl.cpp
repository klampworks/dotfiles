#include <iostream>
#include <fstream>
#include <boost/graph/graphviz.hpp>
#include <boost/graph/properties.hpp>
#include <boost/graph/properties.hpp>

/* http://madebyevan.com/obscure-cpp-features/
 * Functions as template parameters */ 
std::string Black() { return "black"; }
std::string Gray() { return "gray"; }
std::string Red() { return "red"; }
std::string Filled() { return "filled"; }
std::string Box() { return "box"; }

template <std::string (*T)()>
struct DefaultString {
  std::string s;
  DefaultString() : s(T()) {}
};

template <std::string (*T)()>
std::istream& operator>>(std::istream &is, DefaultString<T> &obj) {
  is >> obj.s;
  return is;
}

template <std::string (*T)()>
std::ostream& operator<<(std::ostream &os, const DefaultString<T> &obj) {
  os << obj.s;
  return os;
}

namespace boost {
  enum vertex_color2_t { vertex_color2 };
  template <> struct property_kind<vertex_color2_t> {
      typedef vertex_property_tag type;
  };

  enum vertex_fillcolor_t { vertex_fillcolor };
  template <> struct property_kind<vertex_fillcolor_t> {
      typedef vertex_property_tag type;
  };

  enum vertex_style_t { vertex_style };
  template <> struct property_kind<vertex_style_t> {
      typedef vertex_property_tag type;
  };

  enum vertex_shape_t { vertex_shape };
  template <> struct property_kind<vertex_shape_t> {
      typedef vertex_property_tag type;
  };
}

typedef boost::property < boost::vertex_name_t, std::string,
          boost::property < boost::vertex_fillcolor_t, DefaultString<Gray>,
          boost::property < boost::vertex_style_t, DefaultString<Filled>,
          boost::property < boost::vertex_shape_t, DefaultString<Box>,
          boost::property < boost::vertex_color2_t, DefaultString<Black> > > > > > vertex_p;

typedef boost::property < boost::edge_weight_t, double > edge_p;
typedef boost::property < boost::graph_name_t, std::string > graph_p;
typedef boost::adjacency_list < boost::vecS, boost::vecS, boost::directedS,
  vertex_p, edge_p, graph_p > graph_t;

int main(int argc, char **argv)
{
  graph_t graph(0);
  boost::dynamic_properties dp;

  boost::property_map<graph_t, boost::vertex_name_t>::type name =
    get(boost::vertex_name, graph);
  dp.property("node_id",name);

  boost::property_map<graph_t, boost::vertex_color2_t>::type mass =
    get(boost::vertex_color2, graph);
  dp.property("color",mass);

  boost::property_map<graph_t, boost::vertex_fillcolor_t>::type fillcolor =
    get(boost::vertex_fillcolor, graph);
  dp.property("fillcolor", fillcolor);

  boost::property_map<graph_t, boost::vertex_style_t>::type style =
    get(boost::vertex_style, graph);
  dp.property("style", style);

  boost::property_map<graph_t, boost::vertex_shape_t>::type shape =
    get(boost::vertex_shape, graph);
  dp.property("shape", shape);

  boost::property_map<graph_t, boost::edge_weight_t>::type weight =
    get(boost::edge_weight, graph);
  dp.property("weight",weight);

  boost::ref_property_map<graph_t*,std::string>
    gname(get_property(graph,boost::graph_name));
  dp.property("name",gname);

  std::istringstream gvgraph(argv[1]);
  bool status = boost::read_graphviz(gvgraph,graph,dp,"node_id");

  boost::graph_traits<graph_p>::vertex_iterator vi, vi_end;
  for(boost::tie(vi, vend) = vertices(graph); vi != vend; ++vi)
      std::cout << p[*vi] << " is the parent of " << *vi << std::endl;
  boost::write_graphviz_dp(std::cout, graph, dp);
}

