module Compare

import IO;
import lang::java::m3::AST;
import Node;
import Map;
import List;
import Set;
import Type;

/*
    Similarity = 2 x S / (2 x S + L + R)
    where:
        S = number of shared nodes
        L = number of different nodes in sub-tree 1
        R = number of different nodes in sub-tree 2
*/
real calcSimilarity(node n1, node n2) {
    list[str] subtree1 = typeCast(#tuple[list[str], int], getKeywordParameters(n1)["subtree"])[0];
    list[str] subtree2 = typeCast(#tuple[list[str], int], getKeywordParameters(n2)["subtree"])[0];

    list[str] sharedNodes = subtree1 & subtree2;
    int nSharedNodes = size(sharedNodes);
    int diffN1 = size(subtree1 - sharedNodes);
    int diffN2 = size(subtree2 - sharedNodes);

    real similarity = (2.0 * nSharedNodes / (2.0 * nSharedNodes + diffN1 + diffN2)) * 100.0;

    return similarity;
}