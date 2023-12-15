module Compare

import IO;
import lang::java::m3::AST;
import Node;
import Map;
import List;

void dumpDupes() {
    ast = "f"("10"("1","2"), "abc"("a","b"));
    bottom-up visit(ast) {
        case node n: {
            if (arity(n) == 0) {
                // leaves don't have subtrees, skip asap
                n = setKeywordParameters(n, getKeywordParameters(n) + ("weight": 1));
                // totalLeaves += 1;
            } else {
                // int nodeWeight = determineWeight(n);
                n = setKeywordParameters(n, getKeywordParameters(n) + ("weight": 1)); }
                println(n);
                println(arity(n));
        }
    }

}

void testCombinations() {
    list[list[str]] input = [["a", "b", "c"], ["d", "e", "f"], ["g", "h", "i"]];
    list[list[str]] result = [[]];

    for(list[str] sublist <- input) {
        list[list[str]] newResult = [];
        for(str element <- sublist) {
            for(list[str] combination <- result) {
                list[str] newCombination = combination + [element];
                newResult += [newCombination];
            }
        }
        result = newResult;
    }

    println(size(result));
}


// list[list[&T]] subsequences(list[&T] lst) {
//     if (isEmpty(lst)) {
//         return [[]]; // subsequences [] = [[]]
//     }
    
//     list[&T] rest = tail(lst); // xs
//     list[list[&T]] subs = subsequences(rest); // subsequences xs
//     list[list[&T]] mapResult = [];
//     for (list[&T] sub <- subs) {
//         mapResult += [[lst[0]] + sub] + [sub];
//     }
//     return mapResult;
// }

// list[list[&T]] addSub(list[&T] lst, list[&T] sub) { return [lst[0]] + sub; }


list[list[int]] subsequences(list[list[int]] input) {
    list[list[int]] output = [[]];
    input += [[], [0]];
    for (list[int] childTrees <- input) {
        list[list[int]] outputTemp = [];
        for (int childTree <- childTrees) {
            for (list[int] partialTree <- output) {
                outputTemp += [partialTree + [childTree]];
            }
        }
        output += outputTemp;
    }

    return output;
}

list[list[int]] partialSubsequences(list[int] lst) {
    list[list[int]] result = [];
    int len = size(lst);

    for (int i <- [0..len]) {
        for (int j <- [i..len]) {
            result += [lst[i..j+1]];
            iprintln([lst[i..j+1]]);
        }
    }

    return result;
}