module Tree

import IO;
import lang::java::m3::AST;
import Node;
import Hash;
import List;
import Type;
// import Lexer;

// Type I Pattern Recognition implementation //
// This AST approach visits each node in a bottom-up fashion
// Each node is then evaluated on its weight
// if its less than the massThreshold, only a weight gets added
// if it's more, then the node is passed to an external function
// The mapAllPossibilities(node n) function checks all possible subtrees
// it returns these subtrees as a hashed value in a list, which is then
// added to the map of all hashed subtrees, if it's already in the list
// the value of the hashkey is then incremented(?)
public real getASTduplication(list[Declaration] ASTs,
                                int cloneType,
                                int massThreshold,
                                real simThreshold,
                                loc projectLocation) {
    map[str hash, tuple[int clones, list[loc] locations] values] hm = ();

    // Type III hashmap type
    // map[str, map[node, list[node]]] hm = ();

    // List representation for tokenized files.
    // list[list[tuple[str, list[loc]]]] files = [];
    for (ast <- ASTs) {
        // Tokenization traversal
        // files += [visitNode(ast, [], 1)];

        bottom-up visit(ast) {
            case node n => {
                <nNew, hm> = calcNode(n, cloneType, hm, massThreshold, simThreshold);
                nNew;
            }
        }
        unsetRec(ast);
    }

    // if (cloneType == 3) {
    //     hm = typeCast(#map[str, map[node, list[node]]], hm);
    //     list[node] clones = [];

           // For some reason hm does not accept keys that are directly taken from its domain. 
    //     for (bucket <- domain(hm)) {
    //         for (nKey <- domain(hm[bucket])) {
    //             clones += hm[bucket][nKey];
    //         }
    //     }

           // For some reason, nodes found in the range of the bucket do not have a source,
           // while they do in the hashmap.
        // set[map[node, list[node]]] buckets = typeCast(#set[map[node, list[node]]], range(hm));
        // for (bucket <- buckets) {
        //     for (cloneList <- range(bucket)) { clones += cloneList; }
        // }
        // set[node] clonesSet = toSet(clones);

    //     for (clone <- clones) {
    //         loc l = typeCast(#loc, getKeywordParameters(clone)["src"]);
    //         totalCloneLines += (l.end.line - l.begin.line) + 1;
    //     }
    //     println("Total node clones: <size(clones)>");
    //     println("Total cloneLines: <totalCloneLines>");
    //     return (totalCloneLines  * 1.0 / totalLines * 1.0) * 100.0;
    // }

    // TODO: also report biggest clone class (weight & lines), clone examples and
    // print a list of locations (one for each bucket) to output file.
    int totalCloneLines = 0;
    int totalLines = 0;
    list[tuple[int clones, list[loc] locations] values] filt = [];
    for(tuple[int clones, list[loc] locations] values <- hm.values) {
        if(values.clones > 0) {
            filt += [values];
        }
        for(loc l <- values.locations) {
            totalLines += (l.end.line - l.begin.line) + 1;
            if(values.clones > 0) {
                totalCloneLines += (l.end.line - l.begin.line) + 1;
            }
        }
    }
    // iprintToFile(projectLocation + "output/output.txt", bucketExamples);

    iprintln(filt);
    println("Total clones: <size(filt)>");
    println("Total cloneLines: <totalCloneLines>");
    println("Total lines: <totalLines>");
    return (totalCloneLines  * 1.0 / totalLines * 1.0) * 100.0;
}
