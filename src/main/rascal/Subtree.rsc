module Subtree

import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;
import List;
import Set;
import String;
import Node;
import Map;
import Type;
import HashMapp;


// Form a subtree from the parent node and all children subtrees and
// update the hashmap with the new subtree.
tuple[tuple[tuple[list[str] tree, int weight] subtree, list[str] childHash] subtreeInfo,
        map[str hash, tuple[int weight, list[loc] locations] values] hm]
    getSubtree(str parentHash, node n, map[str, tuple[int, list[loc]]] hm, int massThreshold, list[str] childHashes) {
    tuple[tuple[list[str] tree, int weight] subtree, list[str] childHash] subtreeInfo = <<[parentHash], 1>, childHashes>;
    list[value] children = getChildren(n);

    list[loc] location = [];
    map[str, value] nodeKeywordParameters = getKeywordParameters(n);
    if(size(nodeKeywordParameters) > 0 && "src" in nodeKeywordParameters) {
        location = [nodeKeywordParameters["src"]];
    }

    // Keeps track of children that are nested in list parameters of a node.
    list[node] nestedChildren = [];

    for(child <- children) {
        switch (child) {
            case list[value] c: nestedChildren += c;
            case node c: subtreeInfo = getSubtreeChild(c, subtreeInfo, massThreshold);
        }
    }
    for (node child <- nestedChildren) { subtreeInfo = getSubtreeChild(child, subtreeInfo, massThreshold);}

    return <subtreeInfo, updateHashMap(hm, subtreeInfo, massThreshold, location)[0]>;
}


// Extract the subtree from the child and update the subtree of the parent with the child subtree.
tuple[tuple[list[str] subtree, int weight] subtree, list[str] children]
    getSubtreeChild(node child, tuple[tuple[list[str] tree, int weight] subtree, list[str] childHashes] parentTree, int massThreshold) {
    childKeywords = getKeywordParameters(child);
    if (childKeywords["hash"] == "") { return parentTree; }
    tuple[list[str] subtree, int weight] subtreeChild = typeCast(#tuple[list[str], int], getKeywordParameters(child)["subtree"]);
    // create list of hashed children to pass to updateHashmap for possible deletion
    if(subtreeChild.weight >= massThreshold) {
        parentTree.childHashes += [md5Hash(subtreeChild.subtree)];
    }

    return <<parentTree.subtree.tree + subtreeChild.subtree,
                parentTree.subtree.weight + subtreeChild.weight>,
                parentTree.childHashes>;
}

// Creates a subtree representation of partial code blocks with subsequent lines.
// E.g. a block of 3 lines will be transformed into a list of blocks:
// [[0],[0,1],[0,1,2],[1],[1,2],[2]]
// The first nChildren can be combined with the first lines/children of the parent.
tuple[map[str hash, tuple[int weight,list[loc] locations] values] hm, list[str] childHashes]
    lineSubsequences(list[value] lines,
                        int cloneType,
                        map[str hash, tuple[int weight,list[loc] locations] values] hm,
                        int massThreshold) {
    // Convert the list of nodes to a list of subtrees and their locations.
    list[tuple[tuple[list[str], int], loc]] subtrees = [];
    for (node line <- lines) {
        subtrees += [<typeCast(#tuple[list[str], int], getKeywordParameters(line)["subtree"]), getKeywordParameters(line)["src"]>];
    }

    // Map of start and end subtree index of found clones of the highest level.
    map[tuple[int, int], str] clones = ();
    // Map of start and end subtree index of subsets to be removed from the hm.
    map[tuple[int, int], str] cloneChildren = ();
    tuple[map[str, tuple[int, list[loc]]] hm, bool cloneFound] hmUpdate = <hm, false>;
    int len = size(subtrees);

    // Create slices within the block by shifting the start and end line.
    for (int i <- [0..len]) {
        // Take the location of the first line and replace the end with the end of the last line.
        loc location = subtrees[i][1];
        for (int j <- [i..len]) {
            if(j != i) {
                location.end.line = subtrees[j][1].end.line;
                location.end.column = subtrees[j][1].end.column;
            }
            // Create the next subsequence by merging each subtree within the slice.
            tuple[tuple[list[str] tree, int weight] subtree, list[str] childHashes] nextSubtree = <<[],0>, []>;
            for (tuple[tuple[list[str] tree, int weight] subtree, loc location] subtreeInfo <- subtrees[i..j+1]) {
                nextSubtree = <<nextSubtree.subtree.tree + subtreeInfo.subtree.tree,
                                nextSubtree.subtree.weight + subtreeInfo.subtree.weight>,
                                nextSubtree.childHashes>;
            }
            hmUpdate = updateHashMap(hmUpdate.hm, nextSubtree, massThreshold, [location]);
            
            if (hmUpdate.cloneFound && nextSubtree.subtree.weight >= massThreshold) {
                for (cloneIndex <- domain(clones)) {
                    // Move subset of current set to cloneChildren.
                    if (cloneIndex[0] >= i && cloneIndex[1] <= j) {
                        cloneChildren += (cloneIndex: clones[cloneIndex]);
                    }
                    // Move current set, which is a subset of a previously found clone, to cloneChildren.
                    if (i >= cloneIndex[0] && j <= cloneIndex[1]) {
                        cloneChildren += (<i,j>: md5Hash(nextSubtree.subtree.tree));
                        break;
                    }
                }
                clones += (<i,j>: md5Hash(nextSubtree.subtree.tree));
            }
        }
    }

    hm = subsumptSubclones(hmUpdate.hm, toList(range(cloneChildren)));
    return <hm, toList(range(clones))>;
}


// Form a subtree from the parent node and all children subtrees and
// update the hashmap with the new subtree.
tuple[node n, map[str hashKey, &T values] hm]
    getSubtree3(str parentHash, node n, map[str, &T] hm, int massThreshold, real simThreshold) {
    tuple[tuple[list[str] tree, int weight] subtree, list[node] children] subtreeInfo = <<[parentHash], 1>, []>;
    list[value] children = getChildren(n);

    // Keeps track of children that are nested in list parameters of a node.
    list[node] nestedChildren = [];

    for(child <- children) {
        switch (child) {
            case list[value] c: nestedChildren += c;
            case node c: subtreeInfo = getSubtreeChild3(c, subtreeInfo, massThreshold);
        }
    }
    for (node child <- nestedChildren) { subtreeInfo = getSubtreeChild3(child, subtreeInfo, massThreshold);}
    n = setKeywordParameters(n, getKeywordParameters(n) + ("hash": parentHash) + ("subtree": subtreeInfo.subtree));

    return <n, updateHashMap3(hm, n, subtreeInfo.children, massThreshold, simThreshold)>;
}


// Extract the subtree from the child and update the subtree of the parent with the child subtree.
tuple[tuple[list[str] subtree, int weight] subtree, list[&T] children]
    getSubtreeChild3(node child, tuple[tuple[list[str] tree, int weight] subtree, list[&T] children] parentTree, int massThreshold) {
    childKeywords = getKeywordParameters(child);
    if (childKeywords["hash"] == "") { return parentTree; }
    tuple[list[str] subtree, int weight] subtreeChild = typeCast(#tuple[list[str], int], getKeywordParameters(child)["subtree"]);
    // create list of hashed children to pass to updateHashmap for possible deletion
    if(subtreeChild.weight >= massThreshold) {
        parentTree.children += [child];
    }

    return <<parentTree.subtree.tree + subtreeChild.subtree,
                parentTree.subtree.weight + subtreeChild.weight>,
                parentTree.children>;
}
