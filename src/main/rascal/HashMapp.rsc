module HashMapp

import IO;
import List;


// Type I & II hashmapp
// For a given subtree, update its number of clones if it is identified as a clone.
// Otherwise, add the subtree as a new entry to the hash map.
// Uses the hashed form of subtrees to minimize memory usage and comparison time.

// Hashmap format:
// hashed root node:
//     hashed subtree: #duplicate occurences subtree
// map[str, int]hm = updateHashMap(("nodea", 1), <["nodea"], 1>, 1, 3)
map[str, tuple[int, list[loc]]] updateHashMap(map[str hash, tuple[int weight, list[loc] locations] values] hm, tuple[list[str] tree, str childHash, int weight] subtree, int massThreshold, list[loc] location) {
    if (subtree.weight < massThreshold) {
        return hm;
    }

    str hashedSubtree = md5Hash(subtree.tree);
    // TODO: remove subtrees of current tree from counter.
    if (hashedSubtree in hm) {
        tuple[int weight, list[loc] locations] values = hm[hashedSubtree];
        if (values.weight == 0) {
            hm[hashedSubtree] =  <2, values.locations + location>;
        } else {
            hm[hashedSubtree] = <values.weight + 1, values.locations + location>;
        }
    } else {
        hm[hashedSubtree] =  <0, location>;
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
