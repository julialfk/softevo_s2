module Tree

import IO;
import lang::java::m3::AST;
import Node;
import Hash;
import List;
import Type;
// import Lexer;

// AST //
// public real getASTduplication(list[Declaration] ASTs, int totalLines, int clonetype) {
//     real result = 0.0;
//     switch (clonetype) {
//         case 1: result = getASTtypeI(ASTs, totalLines);
//         case 2: result = getASTtypeI()
//     }
//     return result;
// }

// Type I Pattern Recognition implementation //
// This AST approach visits each node in a bottom-up fashion
// Each node is then evaluated on its weight
// if its less than the massThreshold, only a weight gets added
// if it's more, then the node is passed to an external function
// The mapAllPossibilities(node n) function checks all possible subtrees
// it returns these subtrees as a hashed value in a list, which is then
// added to the map of all hashed subtrees, if it's already in the list
// the value of the hashkey is then incremented(?)
public real getASTduplication(list[Declaration] ASTs, int totalLines, int cloneType) {
    int massThreshold = 15;
    real simThreshold = 0.9;
    hm = ();
    if (cloneType == 1 || cloneType == 2) { hm = typeCast(#map[str, tuple[int, list[loc]]], hm); }
    else { hm = typeCast(#map[str, map[node, list[node]]], hm); }
    // list[list[tuple[str, list[loc]]]] files = [];
    for (ast <- ASTs) {
        // files += [visitNode(ast, [], 1)];
        bottom-up visit(ast) {
            case node n => {
                <nNew, hm> = calcNode(n, cloneType, hm, massThreshold, simThreshold);
                nNew;
            }
        }
        unsetRec(ast);
    }

    // int totalCloneLines = 0;
    // list[tuple[int clones, list[loc] locations] values] filt = [];
    // for(tuple[int clones, list[loc] locations] values <- hm.values) {
    //     if(values.clones > 0) {
    //         filt += [values];
    //         for(loc l <- values.locations) {
    //             totalCloneLines += (l.end.line - l.begin.line) + 1;
    //         }
    //     }
    // }
    iprintToFile(|project://lab2/output/output.txt|,hm);

    // iprintln(filt);
    // println("Total node clones: <size(filt)>");
    // println("Total cloneLines: <totalCloneLines>");
    // return (totalCloneLines  * 1.0 / totalLines * 1.0) * 100.0;
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
// private tuple[int weight, list[str] subtrees] mapAllPossibilities(node parent, int massThreshold) {

//     return <3,["blob", "wlop"]>;
// }

// Type II Pattern Recognition implementation //


// Type III Pattern Recognition implementation //