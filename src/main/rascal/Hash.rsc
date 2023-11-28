module Hash

import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;
import List;
import Set;
import String;
import Node;
import Main;

// node hashNode(node asts) {
//     for (ast <- asts) {
//         visit(ast) {
//             // case \compilationUnit(list[Declaration] imports, list[Declaration] types) => 
//             // case \compilationUnit(Declaration package, list[Declaration] imports, list[Declaration] types) =>
//             // case \enum(str name, list[Type] implements, list[Declaration] constants, list[Declaration] body) =>
//             // case \enumConstant(str name, list[Expression] arguments, Declaration class) =>
//             // case \enumConstant(str name, list[Expression] arguments) =>
//             // case \class(str name, list[Type] extends, list[Type] implements, list[Declaration] body) =>
//             // case \class(list[Declaration] body) =>
//             // case \interface(str name, list[Type] extends, list[Type] implements, list[Declaration] body) =>
//             // case \field(Type \type, list[Expression] fragments) => 
//             // case \initializer(Statement initializerBody) =>
//             // case \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl) =>
//             case a:\method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions): return();
//             // case \constructor(str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl) =>
//             // case \import(str name) =>
//             // case \package(str name) =>
//             // case \package(Declaration parentPackage, str name) =>
//             // case \variables(Type \type, list[Expression] \fragments) =>
//             // case \typeParameter(str name, list[Type] extendsList) =>
//             // case \annotationType(str name, list[Declaration] body) =>
//             // case \annotationTypeMember(Type \type, str name) =>
//             // case \annotationTypeMember(Type \type, str name, Expression defaultBlock) =>
//             // case \parameter(Type \type, str name, int extraDimensions) =>
//             // case \vararg(Type \type, str name) =>
//         }
//     }
// }

int murmurHash3String(str key) {
    // int seed = 42; // Initial seed value
    // int c1 = 0xcc9e2d51;
    // int c2 = 0x1b873593;
    // int r1 = 15;
    // int r2 = 13;
    // int m = 5;
    // int n = 0xe6546b64;

    // int hash = seed;
    // int len = size(key);

    // for (int i <- [0..len/4]) { 
    //     int startIdx = i * 4;
    //     int k = toInt(substring(key, startIdx, startIdx + 4));
    //     k *= c1;
    //     k = (k << r1) | (k >> (32 - r1));
    //     k *= c2;

    //     hash ^= k;
    //     hash = ((hash << r2) | (hash >> (32 - r2))) * m + n;
    // }

    // int tail = len & 3;
    // int k1 = 0;

    // if (tail >= 1) k1 ^= ord(key[len - 1]);
    // if (tail >= 2) k1 ^= ord(key[len - 2]) << 8;
    // if (tail >= 3) k1 ^= ord(key[len - 3]) << 16;

    // k1 *= c1;
    // k1 = (k1 << r1) | (k1 >> (32 - r1));
    // k1 *= c2;
    // hash ^= k1;

    // hash ^= len;
    // hash ^= (hash >> 16);
    // hash *= 0x85ebca6b;
    // hash ^= (hash >> 13);
    // hash *= 0xc2b2ae35;
    // hash ^= (hash >> 16);

    // return hash;
}