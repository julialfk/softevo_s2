module HashMapp

import IO;

// usage: hm = add(hm, <"new", [0]>);
map[str, list[int]] add(map[str, list[int]] hm, tuple[str key, list[int] values] newPair) {
    return hm + (md5Hash(newPair.key): newPair.values);
}

// usage: hm = hasKey(hm, "new");
bool hasKey(map[str keys, list[int] values] hm, str key) {
    for(pairkey <- hm.keys) {
        if(md5Hash(key) == pairkey) {
            return true;
        }
    }
    return false ;
}