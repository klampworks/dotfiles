#include <fstream>
#include <boost/graph/graphviz.hpp>
#include <boost/graph/properties.hpp>

typedef boost::property < boost::vertex_name_t, std::string > vertex_p;
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

  std::istringstream gvgraph(argv[1]);
  boost::read_graphviz(gvgraph,graph,dp,"node_id");
  boost::write_graphviz_dp(std::cout, graph, dp);
}

