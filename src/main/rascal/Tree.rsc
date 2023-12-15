module Tree

import IO;
import lang::java::m3::AST;
import Node;
import Map;
import Hash;
import List;
import Type;
import Lexer;

// AST //
public real getASTduplication(list[Declaration] ASTs, int clonetype) {
    real result = 0.0;
    switch (clonetype) {
        case 1: result = getASTtypeI(ASTs);
    }
    return result;
}

// Type I Pattern Recognition implementation //
// This AST approach visits each node in a bottom-up fashion
// Each node is then evaluated on its weight
// if its less than the massThreshold, only a weight gets added
// if it's more, then the node is passed to an external function
// The mapAllPossibilities(node n) function checks all possible subtrees
// it returns these subtrees as a hashed value in a list, which is then
// added to the map of all hashed subtrees, if it's already in the list
// the value of the hashkey is then incremented(?)
private real getASTtypeI(list[Declaration] ASTs) {
    int massThreshold = 5;
    // list[str] hashedsubtrees = [];
    map[str, map[str, int]] hm = ();
    list[list[tuple[str, list[loc]]]] files = [];
    for (ast <- ASTs) {
        files += [visitNode(ast, [], 1)];
        // bottom-up visit(ast) {
        //     case node n => {
        //         tuple[node nNew, map[str, map[str, int]] hmNew] result = calcNode(n, 1, hm, massThreshold);
        //         hm = result.hmNew;
        //         result.nNew;
        //     }
        //         // println(n);
        //         // println(getChildren(n));
        //         // println(size(getChildren(n)));
        //         // tuple[str hash, map[list[str], int] subtrees] newParameters = calcNode(n, 1);
        //         // n = setKeywordParameters(n, getKeywordParameters(n) + ("hash": newParameters.hash) + ("subtrees": newParameters.subtrees));
        //         // println(getKeywordParameters(n));
        //         // println(getKeywordParameters(n));
        //         // if (arity(n) == 0) {
        //             // leaves don't have subtrees, skip asap
        //             // n = setKeywordParameters(n, getKeywordParameters(n) + ("weight": 1));
        //         // }
        //         // else {
        //             // tuple[int weight, list[str] subtrees] subtree = mapAllPossibilities(n, massThreshold);
        //             // n = setKeywordParameters(n, getKeywordParameters(n) + ("weight": subtree.weight, "node": hashNode(n)));
        //             // hashedsubtrees += subtree.subtrees;
        //         // }
        //         // list[value] children = getChildren(n);
        //         // if (size(children) != arity(n)) {
        //         //     println("children = <size(children)>\n");
        //         //     println("arity = <arity(n)>\n");
        //         //     println(getKeywordParameters(n));
        //         // }
        // }
        unsetRec(ast);
    }
    iprintToFile(|project://lab2/output/output.txt|,files);
    return 0.0;
}

// Debug Scratch pad:
            // case node n: {
                // map[str k, value v] keywords = getKeywordParameters(n);
                // for(str key <- keywords.k) {
                //         println("<key>: <keywords[key]>, ");
                // };
                //     println("\n-------------");
            // }

// this function does the subtree magick
private tuple[int weight, list[str] subtrees] mapAllPossibilities(node parent, int massThreshold) {

    return <3,["blob", "wlop"]>;
}

// Type II Pattern Recognition implementation //


// Type III Pattern Recognition implementation //