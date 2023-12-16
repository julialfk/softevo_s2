module HashMapp

import IO;
import List;
import Map;
import Set;
import String;
import Type;
import Node;
import Compare;


// Type I & II hashmapp
// For a given subtree, update its number of clones if it is identified as a clone.
// Otherwise, add the subtree as a new entry to the hash map.
// Uses the hashed form of subtrees to minimize memory usage and comparison time.

// Hashmap format:
// hashed root node:
//     hashed subtree: #duplicate occurences subtree
// map[str, int]hm = updateHashMap(("nodea", 1), <["nodea"], 1>, 1, 3)
tuple[map[str, tuple[int, list[loc]]] hm, bool cloneFound]
    updateHashMap(map[str hash, tuple[int weight, list[loc] locations] values] hm,
                    tuple[tuple[list[str] tree, int weight] subtree, list[str] childHashes] subtreeInfo,
                    int massThreshold,
                    list[loc] location) {
    if (subtreeInfo.subtree.weight < massThreshold) {
        return <hm, false>;
    }

    bool cloneFound = false;
    str hashedSubtree = md5Hash(subtreeInfo.subtree.tree);
    // TODO: remove subtrees of current tree from counter.
    if (hashedSubtree in hm) {
        cloneFound = true;
        tuple[int weight, list[loc] locations] values = hm[hashedSubtree];
        if (values.weight == 0) {
            hm[hashedSubtree] =  <2, values.locations + location>;
        } else {
            hm[hashedSubtree] = <values.weight + 1, values.locations + location>;
        }
        hm = subtractSubclones(hm, subtreeInfo.childHashes);
    } else {
        hm[hashedSubtree] =  <0, location>;
    }
    return <hm, cloneFound>;
}


map[str, &T] updateHashMap3(map[str hashKey, &T values] hm, 
                    node n,
                    list[&T] children,
                    int massThreshold,
                    real simThreshold) {
    if (typeCast(#tuple[list[str], int], getKeywordParameters(n)["subtree"])[1] < massThreshold) { return hm; }

    bool cloneFound = false;
    <hm, cloneFound> = add2HashMap(n, hm, simThreshold);
    if (cloneFound) { hm = subtractSubclones3(n, children, hm); }
    return hm;
}


tuple[map[str, map[node, list[node]]] hm, bool cloneFound]
    add2HashMap(node n, map[str hashKey, map[node, list[node]] values] hm, real simThreshold) {
    // println("in add2HashMap");
    tuple[list[str] tree, int weight] subtreeInfo = typeCast(#tuple[list[str], int], getKeywordParameters(n)["subtree"]);
    str hashKey = subtreeInfo.tree[0];
    bool cloneFound = false;

    if (hashKey in hm) {
        list[node] clones = findClones(n, hashKey, hm, simThreshold);
        hm[hashKey] += (n:clones);
        if (!isEmpty(clones)) { cloneFound = true; }
    } else {
        hm[hashKey] = (n:[]);
    }

    return <hm, cloneFound>;
}


list[node] findClones(node n, str hashKey, map[str hashKey, map[node, list[node]] values] hm, real simThreshold) {
    // println("in findClones");
    set[node] potentialClones = domain(hm[hashKey]);
    list[node] clones = [];
    for (potentialClone <- potentialClones) {
        if (calcSimilarity(n, potentialClone) >= simThreshold) {
            // Connect the clones to each other.
            clones += [potentialClone];
            hm[hashKey][potentialClone] += [n];
        }
    }

    return clones;
}


// Remove previously counted children of clones from the hashmap.
map[str, tuple[int, list[loc]]] subtractSubclones(map[str hash, tuple[int weight, list[loc] locations] values] hm,
                                                    list[str] childHashes) {
    for (child <- childHashes) {
        if (child notin hm) { continue; }
        if (hm[child].weight == 2) {
            hm[child].weight = 0;
            continue;
        }
        if (hm[child].weight > 2) {
            hm[child].weight -= 1;
        }
    }

    return hm;
}


// Remove the clone connection from the parent's and parent's clones' subtrees.
map[str, map[node, list[node]]] subtractSubclones3(node parent, list[node] children, map[str, map[node, list[node]]] hm) {
    // println("in subtractSubclones");
    for (child <- children) {
        str hashKeyChild = typeCast(#str, getKeywordParameters(child)["hash"]);
        str hashKeyParent = typeCast(#str, getKeywordParameters(parent)["hash"]);
        list[node] clones = hm[hashKeyChild][child];
        list[node] clonesParent = hm[hashKeyParent][parent];

        // Disconnections should also be made for the parent's clones' children.
        for (node clone <- clonesParent) {
            list[value] cloneChildren = getChildren(clone);
            for (cloneChild <- cloneChildren) {
                switch(cloneChild) {
                    case list[value] c: clones += typeCast(#list[node], c);
                    case node c: clones += c;
                }
            }
        }

        for (node clone <- clones) {
            // Current child is not a clone of another subtree.
            if (clone in hm[hashKeyChild]) { hm[hashKeyChild][clone] -= child; }
            // Another subtree is a clone of the current child only if it is not a sibling
            // nor a subtree of the parent's clone.
            if (clone in clones && child in hm[hashKeyChild]) { hm[hashKeyChild][child] -= clone; }
        }
    }
    return hm;
}

// Type III hashmapp
// map[str, map[str, list[int]]] updateHashMapp(map[str, map[str, list[int]]] hm, tuple[list[str] tree, list[str] hashedChildren, int weight] subtree, int massThreshold) {
//     if (subtree.weight < massThreshold) {
//         return hm;
//     }
//     str rootNode = subtree.tree[0];
//     rootNode += toString(subtree.weight);
//     str hashedSubtree = md5Hash(subtree.tree);
//     // removes subtrees?
//     // count dupes with formula
//     return hm + (rootNode: (hashedSubtree: [0]));
// }
