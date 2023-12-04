module Compare

import IO;
import lang::java::m3::AST;
import Node;
import Map;

void dumpDupes() {
    ast = "f"("10"("1","2"), "abc"("a","b"));
    bottom-up visit(ast) {
        case node n: {
            if (arity(n) == 0) {
                // leaves don't have subtrees, skip asap
                n = setKeywordParameters(n, getKeywordParameters(n) + ("weight": 1));
                // totalLeaves += 1;
            } else {
                // int nodeWeight = determineWeight(n);
                n = setKeywordParameters(n, getKeywordParameters(n) + ("weight": 1)); }
                println(n);
                println(arity(n));
        }
    }

}