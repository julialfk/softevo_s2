module Hash

import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;
import List;
import Set;
import String;
import Node;
import Main;
import Type;

// str hashNode(node n) {
    // map[str,value] params = getKeywordParameters(n);
    // if ("decl" in params) {
    //     println("<params["decl"]> = <typeOf(params["decl"])>");
    //     // return params["decl"].path;
    // }
    // switch (n) {
    //     // Declarations
    //     case \compilationUnit(list[Declaration] imports, list[Declaration] types): return 1;
    //     case \compilationUnit(Declaration package, list[Declaration] imports, list[Declaration] types): return 2;
    //     case \enum(str name, list[Type] implements, list[Declaration] constants, list[Declaration] body): return 3;
    //     case \enumConstant(str name, list[Expression] arguments, Declaration class): return 4;
    //     case \enumConstant(str name, list[Expression] arguments): return 5;
    //     case \class(str name, list[Type] extends, list[Type] implements, list[Declaration] body): return 6;
    //     case \class(list[Declaration] body): return 7;
    //     case \interface(str name, list[Type] extends, list[Type] implements, list[Declaration] body): return 8;
    //     case \field(Type \type, list[Expression] fragments): return 9; 
    //     case \initializer(Statement initializerBody): return 10;
    //     case \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl): return 11;
    //     case \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions): return 12;
    //     case \constructor(str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl): return 13;
    //     case \import(str name): return 14;
    //     case \package(str name): return 15;
    //     case \package(Declaration parentPackage, str name): return 16;
    //     case \variables(Type \type, list[Expression] \fragments): return 17;
    //     case \typeParameter(str name, list[Type] extendsList): return 18;
    //     case \annotationType(str name, list[Declaration] body): return 19;
    //     case \annotationTypeMember(Type \type, str name): return 20;
    //     case \annotationTypeMember(Type \type, str name, Expression defaultBlock): return 21;
    //     case \parameter(Type \type, str name, int extraDimensions): return 22;
    //     case \vararg(Type \type, str name): return 23;

    //     // Expressions
    //     case \arrayAccess(Expression array, Expression index): return 24;
    //     case \newArray(Type \type, list[Expression] dimensions, Expression init): return 25;
    //     case \newArray(Type \type, list[Expression] dimensions): return 26;
    //     case \arrayInitializer(list[Expression] elements): return 27;
    //     case \assignment(Expression lhs, str operator, Expression rhs): return 28;
    //     case \cast(Type \type, Expression expression): return 29;
    //     case \characterLiteral(str charValue): return 30;
    //     case \newObject(Expression expr, Type \type, list[Expression] args, Declaration class): return 31;
    //     case \newObject(Expression expr, Type \type, list[Expression] args): return 32;
    //     case \newObject(Type \type, list[Expression] args, Declaration class): return 33;
    //     case \newObject(Type \type, list[Expression] args): return 34;
    //     case \qualifiedName(Expression qualifier, Expression expression): return 35;
    //     case \conditional(Expression expression, Expression thenBranch, Expression elseBranch): return 36;
    //     case \fieldAccess(bool isSuper, Expression expression, str name): return 37;
    //     case \fieldAccess(bool isSuper, str name): return 38;
    //     case \instanceof(Expression leftSide, Type rightSide): return 39;
    //     case \methodCall(bool isSuper, str name, list[Expression] arguments): return 40;
    //     case \methodCall(bool isSuper, Expression receiver, str name, list[Expression] arguments): return 41;
    //     case \null(): return 42;
    //     case \number(str numberValue): return 43;
    //     case \booleanLiteral(bool boolValue): return 44;
    //     case \stringLiteral(str stringValue): return 45;
    //     case \type(Type \type): return 46;
    //     case \variable(str name, int extraDimensions): return 47;
    //     case \variable(str name, int extraDimensions, Expression \initializer): return 48;
    //     case \bracket(Expression expression): return 49;
    //     case \this(): return 50;
    //     case \this(Expression thisExpression): return 51;
    //     case \super(): return 52;
    //     case \declarationExpression(Declaration declaration): return 53;
    //     case \infix(Expression lhs, str operator, Expression rhs): return 54;
    //     case \postfix(Expression operand, str operator): return 55;
    //     case \prefix(str operator, Expression operand): return 56;
    //     case \simpleName(str name): return 57;
    //     case \markerAnnotation(str typeName): return 58;
    //     case \normalAnnotation(str typeName, list[Expression] memberValuePairs): return 59;
    //     case \memberValuePair(str name, Expression \value): return 60;
    //     case \singleMemberAnnotation(str typeName, Expression \value): return 61;

    //     // Statements
    //     case \assert(Expression expression): return 62;
    //     case \assert(Expression expression, Expression message): return 63;
    //     case \block(list[Statement] statements): return 64;
    //     case \break(): return 65;
    //     case \break(str label): return 66;
    //     case \continue(): return 67;
    //     case \continue(str label): return 68;
    //     case \do(Statement body, Expression condition): return 69;
    //     case \empty(): return 70;
    //     case \foreach(Declaration parameter, Expression collection, Statement body): return 71;
    //     case \for(list[Expression] initializers, Expression condition, list[Expression] updaters, Statement body): return 72;
    //     case \for(list[Expression] initializers, list[Expression] updaters, Statement body): return 73;
    //     case \if(Expression condition, Statement thenBranch): return 74;
    //     case \if(Expression condition, Statement thenBranch, Statement elseBranch): return 75;
    //     case \label(str name, Statement body): return 76;
    //     case \return(Expression expression): return 77;
    //     case \return(): return 78;
    //     case \switch(Expression expression, list[Statement] statements): return 79;
    //     case \case(Expression expression): return 80;
    //     case \defaultCase(): return 81;
    //     case \synchronizedStatement(Expression lock, Statement body): return 82;
    //     case \throw(Expression expression): return 83;
    //     case \try(Statement body, list[Statement] catchClauses): return 84;
    //     case \try(Statement body, list[Statement] catchClauses, Statement \finally): return 85;
    //     case \catch(Declaration exception, Statement body): return 86;
    //     case \declarationStatement(Declaration declaration): return 87;
    //     case \while(Expression condition, Statement body): return 88;
    //     case \expressionStatement(Expression stmt): return 89;
    //     case \constructorCall(bool isSuper, Expression expr, list[Expression] arguments): return 90;
    //     case \constructorCall(bool isSuper, list[Expression] arguments): return 91;

    //     // Types
    //     case arrayType(Type \type): return 92;
    //     case parameterizedType(Type \type): return 93;
    //     case qualifiedType(Type qualifier, Expression simpleName): return 94;
    //     case simpleType(Expression typeName): return 95;
    //     case unionType(list[Type] types): return 96;
    //     case wildcard(): return 97;
    //     case upperbound(Type \type): return 98;
    //     case lowerbound(Type \type): return 99;
    //     case \int(): return 100;
    //     case short(): return 101;
    //     case long(): return 102;
    //     case float(): return 103;
    //     case double(): return 104;
    //     case char(): return 105;
    //     case string(): return 106;
    //     case byte(): return 107;
    //     case \void(): return 108;
    //     case \boolean(): return 109;

    //     // Modifiers
    //     case \private(): return 110;
    //     case \public(): return 111;
    //     case \protected(): return 112;
    //     case \friendly(): return 113;
    //     case \static(): return 114;
    //     case \final(): return 115;
    //     case \synchronized(): return 116;
    //     case \transient(): return 117;
    //     case \abstract(): return 118;
    //     case \native(): return 119;
    //     case \volatile(): return 120;
    //     case \strictfp(): return 121;
    //     case \annotation(Expression \anno): return 122;
    //     case \onDemand(): return 123;
    //     case \default(): return 124;
    // }
    // return "";
// }

map[list[str]subtree, int weight] getSubtrees(str parentHash, node n) {
    map[list[str], int] subtrees = ();
    list[value] children = getChildren(n);
    println("Children:");
    iprintln(children);
    
    for(node child <- children) {
        println("Child:");
        iprintln(child);

        println("Params:");
        iprintln(getKeywordParameters(child));
        map[list[str] k, int v] childTrees = getKeywordParameters(child)["subtrees"];
        for (tree <- childTrees) {
            subtrees = subtrees + (parentHash + tree.k: tree.v+1);
        }
        // println("Showning type = <typeOf(child)>");
        // iprintln(child);
        // println("params = <getKeywordParameters(child)>");
    }

    return subtrees;
}


// tuple[str hash, map[list[str] subtree, int weight] subtrees]

node calcNode(node n, int cloneType) {
    println("Node:");
    iprintln(n);
    str hashInput = "";
    str hash = "";
    map[list[str], int] subtrees = ();
    // For children that are not in list form, need to find a way to always include those in subtree.
    switch (n) {
        // Declarations
        case \compilationUnit(list[Declaration] imports, list[Declaration] types): {
            hash = md5Hash("compilationUnit1imports<size(imports)>types<size(types)>");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \compilationUnit(Declaration package, list[Declaration] imports, list[Declaration] types): {
            hash = md5Hash("compilationUnit2imports<size(imports)>types<size(types)>");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \enum(str name, list[Type] implements, list[Declaration] constants, list[Declaration] body): {
            hashInput = "enum1implements<size(implements)>constants<size(constants)>body<size(body)>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \enumConstant(str name, list[Expression] arguments, Declaration class): {
            hashInput = "enumConstant1arguments<size(arguments)>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \enumConstant(str name, list[Expression] arguments): {
            hashInput = "enumConstant2arguments<size(arguments)>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \class(str name, list[Type] extends, list[Type] implements, list[Declaration] body): {
            hashInput = "class1extends<size(extends)>implements<size(implements)>body<size(body)>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \class(list[Declaration] body): {
            hash = md5Hash("class2body<size(body)>");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \interface(str name, list[Type] extends, list[Type] implements, list[Declaration] body): {
            hashInput = "interface1extends<size(extends)>implements<size(implements)>body<size(body)>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \field(Type \type, list[Expression] fragments): {
            hash = md5Hash("field1fragments<size(fragments)>");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \initializer(Statement initializerBody): {
            hash = md5Hash("initializer1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl): {
            hashInput = "method1parameters<size(parameters)>exceptions<size(exceptions)>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions): {
            hashInput = "method2parameters<size(parameters)>exceptions<size(exceptions)>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \constructor(str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl): {
            hashInput = "constructor1parameters<size(parameters)>exceptions<size(exceptions)>impl<impl>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \import(str name): { // Not sure if imports and package names may differ in T2
            hashInput = "import1";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1);
        }
        case \package(str name): { // Not sure if imports and package names may differ in T2
            hashInput = "package1";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1);
        }
        case \package(Declaration parentPackage, str name): { // Not sure if imports and package names may differ in T2
            hashInput = "package1";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \variables(Type \type, list[Expression] \fragments): {
            hash = md5Hash("variables1fragments<size(fragments)>");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \typeParameter(str name, list[Type] extendsList): {
            hashInput = "typeParameter1extendsList<size(extendsList)>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \annotationType(str name, list[Declaration] body): {
            hashInput = "annotationType1body<size(body)>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \annotationTypeMember(Type \type, str name): {
            hashInput = "annotationTypeMember1";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \annotationTypeMember(Type \type, str name, Expression defaultBlock): {
            hashInput = "annotationTypeMember2";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \parameter(Type \type, str name, int extraDimensions): {
            hashInput = "parameter1";
            if (cloneType == 1) { hashInput = hashInput + name + "<extraDimensions>"; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \vararg(Type \type, str name): {
            hashInput = "vararg1";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }

        // Expressions
        case \arrayAccess(Expression array, Expression index): {
            hash = md5Hash("arrayAccess1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \newArray(Type \type, list[Expression] dimensions, Expression init): {
            hash = md5Hash("newArray1dimensions<size(dimensions)>");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \newArray(Type \type, list[Expression] dimensions): {
            hash = md5Hash("newArray1dimensions<size(dimensions)>");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \arrayInitializer(list[Expression] elements): {
            hash = md5Hash("arrayInitializer1elements<size(elements)>");
            subtrees = ([hash]: 1) + + getSubtrees(hash, n);
        }
        case \assignment(Expression lhs, str operator, Expression rhs): {
            hash = md5Hash("assignment1" + operator); // Operators cannot differ in T2, so are always included.
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \cast(Type \type, Expression expression): {
            hash = md5Hash("cast1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \characterLiteral(str charValue): {
            hashInput = "characterLiteral1";
            if (cloneType == 1) { hashInput = hashInput + charValue; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1);
        }
        case \newObject(Expression expr, Type \type, list[Expression] args, Declaration class): {
            hash = md5Hash("newObject1args<size(args)>");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \newObject(Expression expr, Type \type, list[Expression] args): {
            hash = md5Hash("newObject2args<size(args)>");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \newObject(Type \type, list[Expression] args, Declaration class): {
            hash = md5Hash("newObject3args<size(args)>");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \newObject(Type \type, list[Expression] args): {
            hash = md5Hash("newObject4args<size(args)>");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \qualifiedName(Expression qualifier, Expression expression): {
            hash = md5Hash("qualifiedName1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \conditional(Expression expression, Expression thenBranch, Expression elseBranch): {
            hash = md5Hash("conditional1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \fieldAccess(bool isSuper, Expression expression, str name): {
            hashInput = "fieldAccess1<isSuper>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \fieldAccess(bool isSuper, str name): {
            hashInput = "fieldAccess2<isSuper>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1);
        }
        case \instanceof(Expression leftSide, Type rightSide): {
            hash = md5Hash("instanceof1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \methodCall(bool isSuper, str name, list[Expression] arguments): {
            hashInput = "methodCall1arguments<size(arguments)><isSuper>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \methodCall(bool isSuper, Expression receiver, str name, list[Expression] arguments): {
            hashInput = "methodCall2arguments<size(arguments)><isSuper>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \null(): {
            hash = md5Hash("null1");
            subtrees = ([hash]: 1);
        }
        case \number(str numberValue): {
            hashInput = "number1";
            if (cloneType == 1) { hashInput = hashInput + numberValue; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1);
        }
        case \booleanLiteral(bool boolValue): {
            hash = md5Hash("booleanLiteral1");
            if (cloneType == 1) { hashInput = hashInput + "<boolValue>"; }
            subtrees = ([hash]: 1);
        }
        case \stringLiteral(str stringValue): {
            hashInput = "stringLiteral1";
            if (cloneType == 1) { hashInput = hashInput + stringValue; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1);
        }
        case \type(Type \type): {
            hash = md5Hash("type1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \variable(str name, int extraDimensions): {
            hashInput = "variable1";
            if (cloneType == 1) { hashInput = hashInput + name + "<extraDimensions>"; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1);
        }
        case \variable(str name, int extraDimensions, Expression \initializer): {
            hashInput = "variable2";
            if (cloneType == 1) { hashInput = hashInput + name + "<extraDimensions>"; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \bracket(Expression expression): {
            hash = md5Hash("bracket1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \this(): {
            hash = md5Hash("this1");
            subtrees = ([hash]: 1);
        }
        case \this(Expression thisExpression): {
            hash = md5Hash("this2");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \super(): {
            hash = md5Hash("super1");
            subtrees = ([hash]: 1);
        }
        case \declarationExpression(Declaration declaration): {
            hash = md5Hash("declarationExpression1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \infix(Expression lhs, str operator, Expression rhs): {
            hash = md5Hash("infix1" + operator);
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \postfix(Expression operand, str operator): {
            hash = md5Hash("postfix1" + operator);
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \prefix(str operator, Expression operand): {
            hash = md5Hash("prefix1" + operator);
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \simpleName(str name): {
            hashInput = "simpleName1";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1);
        }
        case \markerAnnotation(str typeName): {
            hashInput = "markerAnnotation1";
            if (cloneType == 1) { hashInput = hashInput + typeName; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1);
        }
        case \normalAnnotation(str typeName, list[Expression] memberValuePairs): {
            hashInput = "normalAnnotation1memberValuePairs<size(memberValuePairs)>";
            if (cloneType == 1) { hashInput = hashInput + typeName; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \memberValuePair(str name, Expression \value): {
            hashInput = "memberValuePair1";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \singleMemberAnnotation(str typeName, Expression \value): {
            hashInput = "singleMemberAnnotation1";
            if (cloneType == 1) { hashInput = hashInput + typeName; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }

        // Statements
        case \assert(Expression expression): {
            hash = md5Hash("assert1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \assert(Expression expression, Expression message): {
            hash = md5Hash("assert2");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \block(list[Statement] statements): {
            hash = md5Hash("block1statements<size(statements)>");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \break(): {
            hash = md5Hash("break1");
            subtrees = ([hash]: 1);
        }
        case \break(str label): { // Not sure if label should also be included in t2
            hashInput = "break2";
            if (cloneType == 1) { hashInput = hashInput + label; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1);
        }
        case \continue(): {
            hash = md5Hash("continue1");
            subtrees = ([hash]: 1);
        }
        case \continue(str label): { // Not sure if label should also be included in t2
            hashInput = "continue2";
            if (cloneType == 1) { hashInput = hashInput + label; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1);
        }
        case \do(Statement body, Expression condition): {
            hash = md5Hash("do1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \empty(): {
            hash = md5Hash("empty1");
            subtrees = ([hash]: 1);
        }
        case \foreach(Declaration parameter, Expression collection, Statement body): {
            hash = md5Hash("foreach1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \for(list[Expression] initializers, Expression condition, list[Expression] updaters, Statement body): {
            hash = md5Hash("for1initializers<size(initializers)>updaters<size(updaters)>");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \for(list[Expression] initializers, list[Expression] updaters, Statement body): {
            hash = md5Hash("for2initializers<size(initializers)>updaters<size(updaters)>");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \if(Expression condition, Statement thenBranch): {
            hash = md5Hash("if1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \if(Expression condition, Statement thenBranch, Statement elseBranch): {
            hash = md5Hash("if2");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \label(str name, Statement body): {
            hashInput = "label1";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \return(Expression expression): {
            hash = md5Hash("return1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \return(): {
            hash = md5Hash("return2");
            subtrees = ([hash]: 1);
        }
        case \switch(Expression expression, list[Statement] statements): {
            hash = md5Hash("switch1statements<size(statements)>");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \case(Expression expression): {
            hash = md5Hash("case1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \defaultCase(): {
            hash = md5Hash("defaultCase1");
            subtrees = ([hash]: 1);
        }
        case \synchronizedStatement(Expression lock, Statement body): {
            hash = md5Hash("synchronizedStatement1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \throw(Expression expression): {
            hash = md5Hash("throw1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \try(Statement body, list[Statement] catchClauses): {
            hash = md5Hash("try1catchClauses<size(catchClauses)>");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \try(Statement body, list[Statement] catchClauses, Statement \finally): {
            hash = md5Hash("try2catchClauses<size(catchClauses)>");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \catch(Declaration exception, Statement body): {
            hash = md5Hash("catch1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \declarationStatement(Declaration declaration): {
            hash = md5Hash("declarationStatement1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \while(Expression condition, Statement body): {
            hash = md5Hash("while1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \expressionStatement(Expression stmt): {
            hash = md5Hash("expressionStatement1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \constructorCall(bool isSuper, Expression expr, list[Expression] arguments): {
            hash = md5Hash("constructorCall1arguments<size(arguments)><isSuper>");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \constructorCall(bool isSuper, list[Expression] arguments): {
            hash = md5Hash("constructorCall2arguments<size(arguments)><isSuper>");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }

        // Types
        case arrayType(Type \type): {
            hash = md5Hash("arrayType1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case parameterizedType(Type \type): {
            hash = md5Hash("parameterizedType1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case qualifiedType(Type qualifier, Expression simpleName): {
            hash = md5Hash("qualifiedType1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case simpleType(Expression typeName): {
            hash = md5Hash("simpleType1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case unionType(list[Type] types): {
            hash = md5Hash("unionType1types<size(types)>");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case wildcard(): {
            hash = md5Hash("wildcard1");
            subtrees = ([hash]: 1);
        }
        case upperbound(Type \type): {
            hash = md5Hash("upperbound1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case lowerbound(Type \type): {
            hash = md5Hash("lowerbound1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \int(): {
            hash = md5Hash("int1");
            subtrees = ([hash]: 1);
        }
        case short(): {
            hash = md5Hash("short1");
            subtrees = ([hash]: 1);
        }
        case long(): {
            hash = md5Hash("long1");
            subtrees = ([hash]: 1);
        }
        case float(): {
            hash = md5Hash("float1");
            subtrees = ([hash]: 1);
        }
        case double(): {
            hash = md5Hash("double1");
            subtrees = ([hash]: 1);
        }
        case char(): {
            hash = md5Hash("char1");
            subtrees = ([hash]: 1);
        }
        case string(): {
            hash = md5Hash("string1");
            subtrees = ([hash]: 1);
        }
        case byte(): {
            hash = md5Hash("byte1");
            subtrees = ([hash]: 1);
        }
        case \void(): {
            hash = md5Hash("void1");
            subtrees = ([hash]: 1);
        }
        case \boolean(): {
            hash = md5Hash("boolean1");
            subtrees = ([hash]: 1);
        }

        // Modifiers
        case \private(): {
            hash = md5Hash("private1");
            subtrees = ([hash]: 1);
        }
        case \public(): {
            hash = md5Hash("public1");
            subtrees = ([hash]: 1);
        }
        case \protected(): {
            hash = md5Hash("protected1");
            subtrees = ([hash]: 1);
        }
        case \friendly(): {
            hash = md5Hash("friendly1");
            subtrees = ([hash]: 1);
        }
        case \static(): {
            hash = md5Hash("static1");
            subtrees = ([hash]: 1);
        }
        case \final(): {
            hash = md5Hash("final1");
            subtrees = ([hash]: 1);
        }
        case \synchronized(): {
            hash = md5Hash("synchronized1");
            subtrees = ([hash]: 1);
        }
        case \transient(): {
            hash = md5Hash("transient1");
            subtrees = ([hash]: 1);
        }
        case \abstract(): {
            hash = md5Hash("abstract1");
            subtrees = ([hash]: 1);
        }
        case \native(): {
            hash = md5Hash("native1");
            subtrees = ([hash]: 1);
        }
        case \volatile(): {
            hash = md5Hash("volatile1");
            subtrees = ([hash]: 1);
        }
        case \strictfp(): {
            hash = md5Hash("strictfp1");
            subtrees = ([hash]: 1);
        }
        case \annotation(Expression \anno): {
            hash = md5Hash("annotation1");
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
        }
        case \onDemand(): {
            hash = md5Hash("onDemand1");
            subtrees = ([hash]: 1);
        }
        case \default(): {
            hash = md5Hash("default1");
            subtrees = ([hash]: 1);
        }
    }

    println("Hash:");
    iprintln(hash);
    println("Subtrees:");
    iprintln(subtrees);
    println("\n");

    node m = setKeywordParameters(n, getKeywordParameters(n) + ("hash": hash) + ("subtrees": subtrees));
    // list[value] children = getChildren(n);
    // subtrees = ([hash]:1) + getSubtrees(hash, children);
    return m;
}
