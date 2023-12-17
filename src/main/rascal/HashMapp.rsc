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
// hashed subtree: <#duplicate occurences subtree, [locations]>
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
    if (hashedSubtree in hm) {
        cloneFound = true;
        tuple[int weight, list[loc] locations] values = hm[hashedSubtree];
        if (values.weight == 0) { hm[hashedSubtree] =  <2, values.locations + location>; }
        else { hm[hashedSubtree] = <values.weight + 1, values.locations + location>; }
        hm = subsumptSubclones(hm, subtreeInfo.childHashes);
    } else {
        hm[hashedSubtree] =  <0, location>;
    }
    return <hm, cloneFound>;
}


// Remove previously counted children of clones from the hashmap.
map[str, tuple[int, list[loc]]] subsumptSubclones(map[str hash, tuple[int weight, list[loc] locations] values] hm,
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


// Type III hashmapp
// Update the hashmap with the new subtree and subsumpt its child trees.

// Hashmap format:
// hashed root node: <root node, [root nodes of clones]>
map[str, map[node, list[node]]] updateHashMap3(map[str hashKey, map[node, list[node]] values] hm, 
                                                node n,
                                                list[node] children,
                                                int massThreshold,
                                                real simThreshold) {
    if (typeCast(#tuple[list[str], int], getKeywordParameters(n)["subtree"])[1] < massThreshold) { return hm; }

    bool cloneFound = false;
    <hm, cloneFound> = add2HashMap(n, hm, simThreshold);
    if (cloneFound) { hm = subsumptSubclones3(n, children, hm); }
    return hm;
}


// For a given subtree, update its clones if it is identified as a clone.
// Otherwise, add the subtree as a new entry to the hash map.
tuple[map[str, map[node, list[node]]] hm, bool cloneFound]
    add2HashMap(node n, map[str hashKey, map[node, list[node]] values] hm, real simThreshold) {
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


// Check the bucket for clones for a given subtree.
list[node] findClones(node n, str hashKey, map[str hashKey, map[node, list[node]] values] hm, real simThreshold) {
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


// Remove the clone connection from the parent's and parent's clones' subtrees.
map[str, map[node, list[node]]] subsumptSubclones3(node parent, list[node] children, map[str, map[node, list[node]]] hm) {
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