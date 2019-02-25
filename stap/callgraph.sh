if [ -z "$1" ]
then
  echo "Usage: $0 <executable> <function name>"
  exit 1
fi

> a.dot
echo 'digraph code {' >> a.dot
echo 'graph [bgcolor=white fontsize=8 fontname="Courier"];' >> a.dot
echo 'node [fillcolor=gray style=filled shape=box];' >> a.dot
echo 'edge [arrowhead="vee"];' >> a.dot

sudo stap ~/callgraphs/callgraph.stp "process(\"$1\").function(\"*\")" "$2" -c "$1" | sort| uniq >> a.dot

echo '}' >> a.dot

dot -Tpng a.dot > aa.png
viewnior aa.png
