module HashMapp

import IO;
import util::Math;
import Map;
import String;
import List;
import Set;
import Type;


// For a given subtree, update its number of clones if it is identified as a clone.
// Otherwise, add the subtree as a new entry to the hash map.
// Uses the hashed form of subtrees to minimize memory usage and comparison time.

// Hashmap format:
// hashed root node:
//     hashed subtree: #duplicate occurences subtree
map[str, map[str, int]] updateHashMap(map[str, map[str, int]] hm, tuple[list[str] tree, int weight] subtree, int cloneType, int massThreshold) {
    if (subtree.weight < massThreshold) {
        return hm;
    }
    str rootNode = subtree.tree[0];
    // Type 1 and 2 clones have to be of the same weight.
    if (cloneType == 1 || cloneType == 2) { rootNode += toString(subtree.weight); }
    str hashedSubtree = md5Hash(subtree.tree);
    if(rootNode in hm) {
        hm[rootNode][hashedSubtree] = countDuplicates(hm[rootNode], hashedSubtree);
        return hm;
    }
    return hm + (rootNode: (hashedSubtree: 0));

    // TODO: create a version that does not hash the subtree for type 3 clones.
}


// Check if the subtree was already added to the hash map and
// return the number of clones the entry should be updated to.
int countDuplicates(map[str, int] subtreeBucket, str hashedSubtree) {
    if (hashedSubtree in subtreeBucket) {
        if (subtreeBucket[hashedSubtree] == 0) {
            return 2;
        }
        return subtreeBucket[hashedSubtree] + 1;
    }
    return 0;

    // TODO: remove subtrees of current tree from counter.
}