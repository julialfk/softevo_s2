module Tree

import IO;
import lang::java::m3::AST;
import DateTime;
import Node;
import Hash;
import List;
import Set;
import Type;
import Tokenator;
import Duplication;

// Type I Pattern Recognition implementation //
// This AST approach visits each node in a bottom-up fashion
// Each node is then evaluated on its weight
// if its less than the massThreshold, only a weight gets added
// if it's more, then the node is passed to an external function
// The mapAllPossibilities(node n) function checks all possible subtrees
// it returns these subtrees as a hashed value in a list, which is then
// added to the map of all hashed subtrees, if it's already in the list
// the value of the hashkey is then incremented(?)
public int getASTduplication(list[Declaration] ASTs,
                                int cloneType,
                                int massThreshold,
                                real simThreshold,
                                loc projectLocation,
                                bool secondAlg) {
                                    
    datetime startTime = now();
    map[str hash, tuple[int clones, list[loc] locations] values] hm = ();

    // Type III hashmap type
    // map[str, map[node, list[node]]] hm = ();

    // List representation for tokenized files.
    list[list[tuple[str, list[loc]]]] files = [];
    for (ast <- ASTs) {
        // Tokenization traversal
        if (secondAlg) { files += [visitNode(ast, [], cloneType)]; }
        else {
            bottom-up visit(ast) {
                case node n => {
                    <nNew, hm> = calcNode(n, cloneType, hm, massThreshold, simThreshold);
                    nNew;
                }
            }
            unsetRec(ast);
        }
    }

    datetime endTime = now();
    Duration totalTime = endTime - startTime;
    println("Time spent: <totalTime.minutes>:<totalTime.seconds>.<totalTime.milliseconds> (mm:ss.SSS)");
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

    if (secondAlg) {
        // Reformatting the files, since the traversal also returns locations,
        // but we did not have enough time to use the locations to report the biggest clones etc.
        list[list[str]] filesWithoutLoc = [ [ line[0] | line <- file ] | list[tuple[str,list[loc]]] file <- files];
        int totalLines = size(concat(filesWithoutLoc));
        return countDuplicates(filesWithoutLoc, totalLines);
    }

    printReport(projectLocation, hm, cloneType);

    return 0;
}

// This function prints the results of the AST clone detection to file. The following information is printed:
// clonePercentage, numberOfClones, numberOfCloneClasses. biggestClone, biggestCloneClass, exampleClones
private int printReport(loc projectLocation, map[str hash, tuple[int clones, list[loc] locations] values] hm, int cloneType) {
    // TODO: also report biggest clone class (weight & lines), clone examples and
    // print a list of locations (one for each bucket) to output file.
    int totalLines = 0;
    int totalCloneLines = 0;
    int numberOfClones = 0;
    int biggestCloneLines = 0;
    // use the projectLocation as a placeholder to avoid NPE
    tuple[int clones, list[loc] locations] biggestClone = <0, [projectLocation]>;
    int biggestCloneClassSize = 0;
    tuple[int clones, list[loc] locations] biggestCloneClass = <0, [projectLocation]>;
    list[tuple[int clones, list[loc] locations] values] filt = [];
    for(tuple[int clones, list[loc] locations] values <- hm.values) {
        // for each clone class
        if(values.clones > 0) {
            filt += [values];
            int currentLocationSize = size(values.locations);
            if(currentLocationSize > biggestCloneClassSize) { biggestCloneClass = values; biggestCloneClassSize = currentLocationSize;}
            numberOfClones+=currentLocationSize;
        }

        // for each clone inside the clone class
        for(loc l <- values.locations) {
            int currentLines = (l.end.line - l.begin.line) + 1;
            totalLines += currentLines;
            if(values.clones > 0) { 
                if(currentLines > biggestCloneLines) { biggestClone = values; biggestCloneLines = currentLines;}
                totalCloneLines += currentLines;  
            }
        }
    }
    
    iprintToFile(projectLocation + "output/AST_cloneDetection_report_cloneType<cloneType>.txt", (
        "clonePercentage": "<(totalCloneLines  * 1.0 / totalLines * 1.0) * 100.0>%",
        "numberOfClones": numberOfClones,
        "numberOfCloneClasses": size(filt),
        "biggestClone": biggestClone,
        "biggestCloneClass": biggestCloneClass,
        "exampleClones": getOneFrom(filt).locations
        ));

    return 0;
}