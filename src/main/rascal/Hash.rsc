module Hash

import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;
import List;
import Set;
import String;
import Node;
import Type;
import Map;
import HashMapp;


// Form subtrees from the parent node and all children's subtrees and
// update the hashmap with every new subtree.
tuple[map[list[str] subtree, int weight] subtrees, map[str, map[str, int]] hm]
    getSubtrees(str parentHash, node n, int cloneType, map[str, map[str, int]] hm, int massThreshold) {
    map[list[str], int] subtrees = ();
    list[value] children = getChildren(n);
    list[node] nestedChildren = [];

    for(child <- children) {
        switch (child) {
            case list[value] c: { nestedChildren += c; }
            case node c: {
                tuple[map[list[str], int] subtrees, map[str, map[str, int]] hm] treesAndMap
                    = getSubtreesHelper(parentHash, c, cloneType, hm, massThreshold);
                subtrees += treesAndMap.subtrees;
                hm = treesAndMap.hm;
            }
        }
    }

    for (node child <- nestedChildren) { 
        tuple[map[list[str], int] subtrees, map[str, map[str, int]] hm] treesAndMap
            = getSubtreesHelper(parentHash, child, cloneType, hm, massThreshold);
        subtrees += treesAndMap.subtrees;
        hm = treesAndMap.hm;
    }

    return <subtrees, hm>;
}


// Form subtrees from the parent node and a child's subtrees and
// update the hashmap with every new subtree.
tuple[map[list[str] subtree, int weight] subtrees, map[str, map[str, int]] hm]
    getSubtreesHelper(str parentHash, node child, int cloneType, map[str, map[str, int]] hm, int massThreshold) {
    map[list[str], int] subtrees = ();
    map[list[str], int] childTrees = typeCast(#map[list[str], int], getKeywordParameters(child)["subtrees"]);
    for (treeKey <- domain(childTrees)) {
        list[str] subtree = parentHash + treeKey;
        int weight = childTrees[treeKey] + 1;
        map[list[str], int] newEntry = (subtree: weight);
        subtrees = subtrees + newEntry;
        hm = updateHashMap(hm, <subtree, weight>, cloneType, massThreshold);
    }

    return <subtrees, hm>;
}


// Return the updated version of the node (with subtrees) and hashmap.
tuple[node, map[str, map[str, int]]] calcNode(node n, int cloneType, map[str, map[str, int]] hm, int massThreshold) {
    // println("Node:");
    // iprintln(n);
    str hashInput = "";
    str hash = "";
    map[list[str], int] subtrees = ();
    // For children that are not in list form, need to find a way to always include those in subtree.
    switch (n) {
        // Declarations
        case \compilationUnit(list[Declaration] imports, list[Declaration] types): {
            hash = md5Hash("compilationUnit1imports<size(imports)>types<size(types)>");
        }
        case \compilationUnit(Declaration package, list[Declaration] imports, list[Declaration] types): {
            hash = md5Hash("compilationUnit2imports<size(imports)>types<size(types)>");
        }
        case \enum(str name, list[Type] implements, list[Declaration] constants, list[Declaration] body): {
            hashInput = "enum1implements<size(implements)>constants<size(constants)>body<size(body)>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
        }
        case \enumConstant(str name, list[Expression] arguments, Declaration class): {
            hashInput = "enumConstant1arguments<size(arguments)>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
        }
        case \enumConstant(str name, list[Expression] arguments): {
            hashInput = "enumConstant2arguments<size(arguments)>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
        }
        case \class(str name, list[Type] extends, list[Type] implements, list[Declaration] body): {
            hashInput = "class1extends<size(extends)>implements<size(implements)>body<size(body)>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
        }
        case \class(list[Declaration] body): {
            hash = md5Hash("class2body<size(body)>");
        }
        case \interface(str name, list[Type] extends, list[Type] implements, list[Declaration] body): {
            hashInput = "interface1extends<size(extends)>implements<size(implements)>body<size(body)>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
        }
        case \field(Type \type, list[Expression] fragments): {
            hash = md5Hash("field1fragments<size(fragments)>");
        }
        case \initializer(Statement initializerBody): {
            hash = md5Hash("initializer1");
        }
        case \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl): {
            hashInput = "method1parameters<size(parameters)>exceptions<size(exceptions)>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
        }
        case \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions): {
            hashInput = "method2parameters<size(parameters)>exceptions<size(exceptions)>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
        }
        case \constructor(str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl): {
            hashInput = "constructor1parameters<size(parameters)>exceptions<size(exceptions)>impl<impl>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
        }
        case \import(str name): { // Not sure if imports and package names may differ in T2
            hashInput = "import1";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
        }
        case \package(str name): { // Not sure if imports and package names may differ in T2
            hashInput = "package1";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
        }
        case \package(Declaration parentPackage, str name): { // Not sure if imports and package names may differ in T2
            hashInput = "package1";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
        }
        case \variables(Type \type, list[Expression] \fragments): {
            hash = md5Hash("variables1fragments<size(fragments)>");
        }
        case \typeParameter(str name, list[Type] extendsList): {
            hashInput = "typeParameter1extendsList<size(extendsList)>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
        }
        case \annotationType(str name, list[Declaration] body): {
            hashInput = "annotationType1body<size(body)>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
        }
        case \annotationTypeMember(Type \type, str name): {
            hashInput = "annotationTypeMember1";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
        }
        case \annotationTypeMember(Type \type, str name, Expression defaultBlock): {
            hashInput = "annotationTypeMember2";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
        }
        case \parameter(Type \type, str name, int extraDimensions): {
            hashInput = "parameter1";
            if (cloneType == 1) { hashInput = hashInput + name + "<extraDimensions>"; }
            hash = md5Hash(hashInput);
        }
        case \vararg(Type \type, str name): {
            hashInput = "vararg1";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
        }

        // Expressions
        case \arrayAccess(Expression array, Expression index): {
            hash = md5Hash("arrayAccess1");
        }
        case \newArray(Type \type, list[Expression] dimensions, Expression init): {
            hash = md5Hash("newArray1dimensions<size(dimensions)>");
        }
        case \newArray(Type \type, list[Expression] dimensions): {
            hash = md5Hash("newArray1dimensions<size(dimensions)>");
        }
        case \arrayInitializer(list[Expression] elements): {
            hash = md5Hash("arrayInitializer1elements<size(elements)>");
        }
        case \assignment(Expression lhs, str operator, Expression rhs): {
            hash = md5Hash("assignment1" + operator); // Operators cannot differ in T2, so are always included.
        }
        case \cast(Type \type, Expression expression): {
            hash = md5Hash("cast1");
        }
        case \characterLiteral(str charValue): {
            hashInput = "characterLiteral1";
            if (cloneType == 1) { hashInput = hashInput + charValue; }
            hash = md5Hash(hashInput);
        }
        case \newObject(Expression expr, Type \type, list[Expression] args, Declaration class): {
            hash = md5Hash("newObject1args<size(args)>");
        }
        case \newObject(Expression expr, Type \type, list[Expression] args): {
            hash = md5Hash("newObject2args<size(args)>");
        }
        case \newObject(Type \type, list[Expression] args, Declaration class): {
            hash = md5Hash("newObject3args<size(args)>");
        }
        case \newObject(Type \type, list[Expression] args): {
            hash = md5Hash("newObject4args<size(args)>");
        }
        case \qualifiedName(Expression qualifier, Expression expression): {
            hash = md5Hash("qualifiedName1");
        }
        case \conditional(Expression expression, Expression thenBranch, Expression elseBranch): {
            hash = md5Hash("conditional1");
        }
        case \fieldAccess(bool isSuper, Expression expression, str name): {
            hashInput = "fieldAccess1<isSuper>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
        }
        case \fieldAccess(bool isSuper, str name): {
            hashInput = "fieldAccess2<isSuper>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
        }
        case \instanceof(Expression leftSide, Type rightSide): {
            hash = md5Hash("instanceof1");
        }
        case \methodCall(bool isSuper, str name, list[Expression] arguments): {
            hashInput = "methodCall1arguments<size(arguments)><isSuper>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
        }
        case \methodCall(bool isSuper, Expression receiver, str name, list[Expression] arguments): {
            hashInput = "methodCall2arguments<size(arguments)><isSuper>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
        }
        case \null(): {
            hash = md5Hash("null1");
        }
        case \number(str numberValue): {
            hashInput = "number1";
            if (cloneType == 1) { hashInput = hashInput + numberValue; }
            hash = md5Hash(hashInput);
        }
        case \booleanLiteral(bool boolValue): {
            hash = md5Hash("booleanLiteral1");
            if (cloneType == 1) { hashInput = hashInput + "<boolValue>"; }
        }
        case \stringLiteral(str stringValue): {
            hashInput = "stringLiteral1";
            if (cloneType == 1) { hashInput = hashInput + stringValue; }
            hash = md5Hash(hashInput);
        }
        case \type(Type \type): {
            hash = md5Hash("type1");
        }
        case \variable(str name, int extraDimensions): {
            hashInput = "variable1";
            if (cloneType == 1) { hashInput = hashInput + name + "<extraDimensions>"; }
            hash = md5Hash(hashInput);
        }
        case \variable(str name, int extraDimensions, Expression \initializer): {
            hashInput = "variable2";
            if (cloneType == 1) { hashInput = hashInput + name + "<extraDimensions>"; }
            hash = md5Hash(hashInput);
        }
        case \bracket(Expression expression): {
            hash = md5Hash("bracket1");
        }
        case \this(): {
            hash = md5Hash("this1");
        }
        case \this(Expression thisExpression): {
            hash = md5Hash("this2");
        }
        case \super(): {
            hash = md5Hash("super1");
        }
        case \declarationExpression(Declaration declaration): {
            hash = md5Hash("declarationExpression1");
        }
        case \infix(Expression lhs, str operator, Expression rhs): {
            hash = md5Hash("infix1" + operator);
        }
        case \postfix(Expression operand, str operator): {
            hash = md5Hash("postfix1" + operator);
        }
        case \prefix(str operator, Expression operand): {
            hash = md5Hash("prefix1" + operator);
        }
        case \simpleName(str name): {
            hashInput = "simpleName1";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
        }
        case \markerAnnotation(str typeName): {
            hashInput = "markerAnnotation1";
            if (cloneType == 1) { hashInput = hashInput + typeName; }
            hash = md5Hash(hashInput);
        }
        case \normalAnnotation(str typeName, list[Expression] memberValuePairs): {
            hashInput = "normalAnnotation1memberValuePairs<size(memberValuePairs)>";
            if (cloneType == 1) { hashInput = hashInput + typeName; }
            hash = md5Hash(hashInput);
        }
        case \memberValuePair(str name, Expression \value): {
            hashInput = "memberValuePair1";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
        }
        case \singleMemberAnnotation(str typeName, Expression \value): {
            hashInput = "singleMemberAnnotation1";
            if (cloneType == 1) { hashInput = hashInput + typeName; }
            hash = md5Hash(hashInput);
        }

        // Statements
        case \assert(Expression expression): {
            hash = md5Hash("assert1");
        }
        case \assert(Expression expression, Expression message): {
            hash = md5Hash("assert2");
        }
        case \block(list[Statement] statements): {
            hash = md5Hash("block1statements<size(statements)>");
        }
        case \break(): {
            hash = md5Hash("break1");
        }
        case \break(str label): { // Not sure if label should also be included in t2
            hashInput = "break2";
            if (cloneType == 1) { hashInput = hashInput + label; }
            hash = md5Hash(hashInput);
        }
        case \continue(): {
            hash = md5Hash("continue1");
        }
        case \continue(str label): { // Not sure if label should also be included in t2
            hashInput = "continue2";
            if (cloneType == 1) { hashInput = hashInput + label; }
            hash = md5Hash(hashInput);
        }
        case \do(Statement body, Expression condition): {
            hash = md5Hash("do1");
        }
        case \empty(): {
            hash = md5Hash("empty1");
        }
        case \foreach(Declaration parameter, Expression collection, Statement body): {
            hash = md5Hash("foreach1");
        }
        case \for(list[Expression] initializers, Expression condition, list[Expression] updaters, Statement body): {
            hash = md5Hash("for1initializers<size(initializers)>updaters<size(updaters)>");
        }
        case \for(list[Expression] initializers, list[Expression] updaters, Statement body): {
            hash = md5Hash("for2initializers<size(initializers)>updaters<size(updaters)>");
        }
        case \if(Expression condition, Statement thenBranch): {
            hash = md5Hash("if1");
        }
        case \if(Expression condition, Statement thenBranch, Statement elseBranch): {
            hash = md5Hash("if2");
        }
        case \label(str name, Statement body): {
            hashInput = "label1";
            if (cloneType == 1) { hashInput = hashInput + name; }
            hash = md5Hash(hashInput);
        }
        case \return(Expression expression): {
            hash = md5Hash("return1");
        }
        case \return(): {
            hash = md5Hash("return2");
        }
        case \switch(Expression expression, list[Statement] statements): {
            hash = md5Hash("switch1statements<size(statements)>");
        }
        case \case(Expression expression): {
            hash = md5Hash("case1");
        }
        case \defaultCase(): {
            hash = md5Hash("defaultCase1");
        }
        case \synchronizedStatement(Expression lock, Statement body): {
            hash = md5Hash("synchronizedStatement1");
        }
        case \throw(Expression expression): {
            hash = md5Hash("throw1");
        }
        case \try(Statement body, list[Statement] catchClauses): {
            hash = md5Hash("try1catchClauses<size(catchClauses)>");
        }
        case \try(Statement body, list[Statement] catchClauses, Statement \finally): {
            hash = md5Hash("try2catchClauses<size(catchClauses)>");
        }
        case \catch(Declaration exception, Statement body): {
            hash = md5Hash("catch1");
        }
        case \declarationStatement(Declaration declaration): {
            hash = md5Hash("declarationStatement1");
        }
        case \while(Expression condition, Statement body): {
            hash = md5Hash("while1");
        }
        case \expressionStatement(Expression stmt): {
            hash = md5Hash("expressionStatement1");
        }
        case \constructorCall(bool isSuper, Expression expr, list[Expression] arguments): {
            hash = md5Hash("constructorCall1arguments<size(arguments)><isSuper>");
        }
        case \constructorCall(bool isSuper, list[Expression] arguments): {
            hash = md5Hash("constructorCall2arguments<size(arguments)><isSuper>");
        }

        // Types
        case arrayType(Type \type): {
            hash = md5Hash("arrayType1");
        }
        case parameterizedType(Type \type): {
            hash = md5Hash("parameterizedType1");
        }
        case qualifiedType(Type qualifier, Expression simpleName): {
            hash = md5Hash("qualifiedType1");
        }
        case simpleType(Expression typeName): {
            hash = md5Hash("simpleType1");
        }
        case unionType(list[Type] types): {
            hash = md5Hash("unionType1types<size(types)>");
        }
        case wildcard(): {
            hash = md5Hash("wildcard1");
        }
        case upperbound(Type \type): {
            hash = md5Hash("upperbound1");
        }
        case lowerbound(Type \type): {
            hash = md5Hash("lowerbound1");
        }
        case \int(): {
            hash = md5Hash("int1");
        }
        case short(): {
            hash = md5Hash("short1");
        }
        case long(): {
            hash = md5Hash("long1");
        }
        case float(): {
            hash = md5Hash("float1");
        }
        case double(): {
            hash = md5Hash("double1");
        }
        case char(): {
            hash = md5Hash("char1");
        }
        case string(): {
            hash = md5Hash("string1");
        }
        case byte(): {
            hash = md5Hash("byte1");
        }
        case \void(): {
            hash = md5Hash("void1");
        }
        case \boolean(): {
            hash = md5Hash("boolean1");
        }

        // Modifiers
        case \private(): {
            hash = md5Hash("private1");
        }
        case \public(): {
            hash = md5Hash("public1");
        }
        case \protected(): {
            hash = md5Hash("protected1");
        }
        case \friendly(): {
            hash = md5Hash("friendly1");
        }
        case \static(): {
            hash = md5Hash("static1");
        }
        case \final(): {
            hash = md5Hash("final1");
        }
        case \synchronized(): {
            hash = md5Hash("synchronized1");
        }
        case \transient(): {
            hash = md5Hash("transient1");
        }
        case \abstract(): {
            hash = md5Hash("abstract1");
        }
        case \native(): {
            hash = md5Hash("native1");
        }
        case \volatile(): {
            hash = md5Hash("volatile1");
        }
        case \strictfp(): {
            hash = md5Hash("strictfp1");
        }
        case \annotation(Expression \anno): {
            hash = md5Hash("annotation1");
        }
        case \onDemand(): {
            hash = md5Hash("onDemand1");
        }
        case \default(): {
            hash = md5Hash("default1");
        }
    }

    tuple[map[list[str] subtree, int weight] subtrees, map[str, map[str, int]] hm] treesAndMap
        = getSubtrees(hash, n, cloneType, hm, massThreshold);
    subtrees = ([hash]:1) + treesAndMap.subtrees;

    // println("Hash:");
    // iprintln(hash);
    // println("Subtrees:");
    // iprintln(subtrees);
    // println("\n");
    // iprintln(treesAndMap.hm);

    if (hash == "") {
        return(<setKeywordParameters(n, getKeywordParameters(n) + ("hash": hash) + ("subtrees": ())), treesAndMap.hm>);
    }
    return(<setKeywordParameters(n, getKeywordParameters(n) + ("hash": hash) + ("subtrees": subtrees)), treesAndMap.hm>);
}
