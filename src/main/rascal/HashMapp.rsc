module HashMapp

import IO;

// usage: hm = add(hm, <"new", [0]>);
// If the key is already in the hashmap, add the subtree hashes to the existing bucket
// If it is not in the hashmap, add it.
map[str, list[str]] add(map[str, list[str]] hm, tuple[str key, list[str] subtreehashes] newPair) {
    if(hasKey(hm, newPair.key)) {
        str hashedKey = md5Hash(newPair.key);
        hm[hashedKey] = hm[hashedKey] + newPair.subtreehashes;
        return hm;
    }
    return hm + (md5Hash(newPair.key): newPair.subtreehashes);
}

// usage: hm = hasKey(hm, "new");
bool hasKey(map[str keys, list[str] subtreehashes] hm, str key) {
    return md5Hash(key) in hm ;
}