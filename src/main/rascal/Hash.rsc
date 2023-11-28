module Hash

import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;
import List;
import Set;
import String;
import Node;
import Main;

int hashNode(node n) {
    switch (n) {
        // Declarations
        case \compilationUnit(list[Declaration] imports, list[Declaration] types): return 1;
        case \compilationUnit(Declaration package, list[Declaration] imports, list[Declaration] types): return 2;
        case \enum(str name, list[Type] implements, list[Declaration] constants, list[Declaration] body): return 3;
        case \enumConstant(str name, list[Expression] arguments, Declaration class): return 4;
        case \enumConstant(str name, list[Expression] arguments): return 5;
        case \class(str name, list[Type] extends, list[Type] implements, list[Declaration] body): return 6;
        case \class(list[Declaration] body): return 7;
        case \interface(str name, list[Type] extends, list[Type] implements, list[Declaration] body): return 8;
        case \field(Type \type, list[Expression] fragments): return 9; 
        case \initializer(Statement initializerBody): return 10;
        case \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl): return 11;
        case \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions): return 12;
        case \constructor(str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl): return 13;
        case \import(str name): return 14;
        case \package(str name): return 15;
        case \package(Declaration parentPackage, str name): return 16;
        case \variables(Type \type, list[Expression] \fragments): return 17;
        case \typeParameter(str name, list[Type] extendsList): return 18;
        case \annotationType(str name, list[Declaration] body): return 19;
        case \annotationTypeMember(Type \type, str name): return 20;
        case \annotationTypeMember(Type \type, str name, Expression defaultBlock): return 21;
        case \parameter(Type \type, str name, int extraDimensions): return 22;
        case \vararg(Type \type, str name): return 23;

        // Expressions
        case \arrayAccess(Expression array, Expression index): return 24;
        case \newArray(Type \type, list[Expression] dimensions, Expression init): return 25;
        case \newArray(Type \type, list[Expression] dimensions): return 26;
        case \arrayInitializer(list[Expression] elements): return 27;
        case \assignment(Expression lhs, str operator, Expression rhs): return 28;
        case \cast(Type \type, Expression expression): return 29;
        case \characterLiteral(str charValue): return 30;
        case \newObject(Expression expr, Type \type, list[Expression] args, Declaration class): return 31;
        case \newObject(Expression expr, Type \type, list[Expression] args): return 32;
        case \newObject(Type \type, list[Expression] args, Declaration class): return 33;
        case \newObject(Type \type, list[Expression] args): return 34;
        case \qualifiedName(Expression qualifier, Expression expression): return 35;
        case \conditional(Expression expression, Expression thenBranch, Expression elseBranch): return 36;
        case \fieldAccess(bool isSuper, Expression expression, str name): return 37;
        case \fieldAccess(bool isSuper, str name): return 38;
        case \instanceof(Expression leftSide, Type rightSide): return 39;
        case \methodCall(bool isSuper, str name, list[Expression] arguments): return 40;
        case \methodCall(bool isSuper, Expression receiver, str name, list[Expression] arguments): return 41;
        case \null(): return 42;
        case \number(str numberValue): return 43;
        case \booleanLiteral(bool boolValue): return 44;
        case \stringLiteral(str stringValue): return 45;
        case \type(Type \type): return 46;
        case \variable(str name, int extraDimensions): return 47;
        case \variable(str name, int extraDimensions, Expression \initializer): return 48;
        case \bracket(Expression expression): return 49;
        case \this(): return 50;
        case \this(Expression thisExpression): return 51;
        case \super(): return 52;
        case \declarationExpression(Declaration declaration): return 53;
        case \infix(Expression lhs, str operator, Expression rhs): return 54;
        case \postfix(Expression operand, str operator): return 55;
        case \prefix(str operator, Expression operand): return 56;
        case \simpleName(str name): return 57;
        case \markerAnnotation(str typeName): return 58;
        case \normalAnnotation(str typeName, list[Expression] memberValuePairs): return 59;
        case \memberValuePair(str name, Expression \value): return 60;
        case \singleMemberAnnotation(str typeName, Expression \value): return 61;

        // Statements
        case \assert(Expression expression): return 62;
        case \assert(Expression expression, Expression message): return 63;
        case \block(list[Statement] statements): return 64;
        case \break(): return 65;
        case \break(str label): return 66;
        case \continue(): return 67;
        case \continue(str label): return 68;
        case \do(Statement body, Expression condition): return 69;
        case \empty(): return 70;
        case \foreach(Declaration parameter, Expression collection, Statement body): return 71;
        case \for(list[Expression] initializers, Expression condition, list[Expression] updaters, Statement body): return 72;
        case \for(list[Expression] initializers, list[Expression] updaters, Statement body): return 73;
        case \if(Expression condition, Statement thenBranch): return 74;
        case \if(Expression condition, Statement thenBranch, Statement elseBranch): return 75;
        case \label(str name, Statement body): return 76;
        case \return(Expression expression): return 77;
        case \return(): return 78;
        case \switch(Expression expression, list[Statement] statements): return 79;
        case \case(Expression expression): return 80;
        case \defaultCase(): return 81;
        case \synchronizedStatement(Expression lock, Statement body): return 82;
        case \throw(Expression expression): return 83;
        case \try(Statement body, list[Statement] catchClauses): return 84;
        case \try(Statement body, list[Statement] catchClauses, Statement \finally): return 85;
        case \catch(Declaration exception, Statement body): return 86;
        case \declarationStatement(Declaration declaration): return 87;
        case \while(Expression condition, Statement body): return 88;
        case \expressionStatement(Expression stmt): return 89;
        case \constructorCall(bool isSuper, Expression expr, list[Expression] arguments): return 90;
        case \constructorCall(bool isSuper, list[Expression] arguments): return 91;

        // Types
        case arrayType(Type \type): return 92;
        case parameterizedType(Type \type): return 93;
        case qualifiedType(Type qualifier, Expression simpleName): return 94;
        case simpleType(Expression typeName): return 95;
        case unionType(list[Type] types): return 96;
        case wildcard(): return 97;
        case upperbound(Type \type): return 98;
        case lowerbound(Type \type): return 99;
        case \int(): return 100;
        case short(): return 101;
        case long(): return 102;
        case float(): return 103;
        case double(): return 104;
        case char(): return 105;
        case string(): return 106;
        case byte(): return 107;
        case \void(): return 108;
        case \boolean(): return 109;

        // Modifiers
        case \private(): return 110;
        case \public(): return 111;
        case \protected(): return 112;
        case \friendly(): return 113;
        case \static(): return 114;
        case \final(): return 115;
        case \synchronized(): return 116;
        case \transient(): return 117;
        case \abstract(): return 118;
        case \native(): return 119;
        case \volatile(): return 120;
        case \strictfp(): return 121;
        case \annotation(Expression \anno): return 122;
        case \onDemand(): return 123;
        case \default(): return 124;
    }
    return 0;
}

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