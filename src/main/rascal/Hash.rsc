module Hash

import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;
import List;
import Set;
import String;
import Node;
import Map;
import Type;
import HashMapp;

// Form a subtree from the parent node and all children subtrees and
// update the hashmap with the new subtree.
// TODO: limit subtree search by only allowing the exclusion of children from
// the parent node. All children of children should be included,
// since we do not want variable nodes missing from a statement,
// or a missing statement from a block, for example.
tuple[tuple[tuple[list[str] tree, int weight] subtree, list[str] childHash] subtreeInfo, map[str hash, tuple[int weight, list[loc] locations] values] hm]
    getSubtree(str parentHash, node n, map[str, tuple[int, list[loc]]] hm, int massThreshold) {
    tuple[tuple[list[str] tree, int weight] subtree, list[str] childHash] subtreeInfo= <<[parentHash], 1>, []>;
    list[value] children = getChildren(n);

    list[loc] location = [];
    map[str, value] nodeKeywordParameters = getKeywordParameters(n);
    if(size(nodeKeywordParameters) > 0 && "src" in nodeKeywordParameters) {
        location = [nodeKeywordParameters["src"]];
    }

    // Keeps track of children that are nested in list parameters of a node.
    list[node] nestedChildren = [];

    for(child <- children) {
        switch (child) {
            // case list
            case list[value] c: nestedChildren += c;
            case node c: subtree = getSubtreeChild(c, subtreeInfo, massThreshold);
        }
    }
    for (node child <- nestedChildren) { subtreeInfo = getSubtreeChild(child, subtreeInfo, massThreshold);}

    return <subtreeInfo, updateHashMap(hm, subtreeInfo, massThreshold, location)>;
}


// Extract the subtree from the child and update the subtree of the parent with the child subtree.
tuple[tuple[list[str] subtree, int weight] subtree, list[str] childHashes] getSubtreeChild(node child, tuple[tuple[list[str] tree, int weight] subtree, list[str] childHashes] parentTree, int massThreshold) {
    childKeywords = getKeywordParameters(child);
    if (childKeywords["hash"] == "") { return parentTree; }
    tuple[list[str] subtree, int weight] subtreeChild = typeCast(#tuple[list[str], int], getKeywordParameters(child)["subtree"]);
    // create list of hashed children to pass to updateHashmap for possible deletion
    list[str] childHash = [];
    if(subtreeChild.weight > massThreshold) {
        childHash + md5Hash(subtreeChild.subtree);
    }

    return <<parentTree.subtree.tree + subtreeChild.subtree, parentTree.subtree.weight + subtreeChild.weight>, parentTree.childHashes + childHash>;
}


// Extract the subtree from a child node's keyword paramaters.
tuple[list[str] subtree, int weight] getChildTree(node child) {
    return(typeCast(#tuple[list[str], int], getKeywordParameters(child)["subtree"]));
}


// Extract the subtrees from a block of code.
list[tuple[list[str] tree, int weight]] getLines(list[value] lines) {
    list[tuple[list[str], int]] subtrees = [];
    for (node line <- lines) { subtrees += [getChildTree(line)]; }
    return subtrees;
}


// Creates a subtree representation of partial code blocks with subsequent lines.
// E.g. a block of 3 lines will be transformed into a list of blocks:
// [[0],[0,1],[0,1,2],[1],[1,2],[2]]
// The first nChildren can be combined with the first lines/children of the parent.
map[str hash, tuple[int weight,list[loc] locations] values] lineSubsequences(list[value] lines,
                        int cloneType,
                        map[str hash, tuple[int weight,list[loc] locations] values] hm,
                        int massThreshold,
                        list[loc] location) {
    list[tuple[list[str], int]] subtrees = [];
    for (node line <- lines) { subtrees += [getChildTree(line)]; }

    list[tuple[tuple[list[str], int], list[str]]] result = [];
    int len = size(subtrees);

    for (int i <- [0..len]) {
        for (int j <- [i..len]) {
            tuple[tuple[list[str] tree, int weight] subtree, list[str] childHashes] nextSubtree = <<[],0>, []>;
            for (tuple[list[str] tree, int weight] subtree <- subtrees[i..j+1]) {
                nextSubtree = <<nextSubtree.subtree.tree + subtree.tree, nextSubtree.subtree.weight + subtree.weight>, nextSubtree.childHashes>;
            }
            result += [nextSubtree];
            hm = updateHashMap(hm, nextSubtree, massThreshold, location);
        }
    }

    return hm;
}


// Return the updated version of the node (with subtrees) and hashmap.
tuple[node, map[str, tuple[int, list[loc]]]] calcNode(node n, int cloneType, map[str, tuple[int, list[loc]]] hm, int massThreshold) {
    // println("Node:");
    // iprintln(n);
    str hashInput = "";
    // str hash = "";
    // map[list[str], int] subtrees = ();
    list[value] lines = [];
    // For children that are not in list form, need to find a way to always include those in subtree.
    switch (n) {
        // Declarations
        case \compilationUnit(list[Declaration] imports, list[Declaration] types): {
            hashInput = "compilationUnit1";
            if (cloneType == 1 || cloneType == 2) { hashInput += "imports<size(imports)>types<size(types)>"; }
        }
        case \compilationUnit(Declaration package, list[Declaration] imports, list[Declaration] types): {
            hashInput = "compilationUnit2";
            if (cloneType == 1 || cloneType == 2) { hashInput += "imports<size(imports)>types<size(types)>"; }
        }
        case \enum(str name, list[Type] implements, list[Declaration] constants, list[Declaration] body): {
            hashInput = "enum1";
            if (cloneType == 1) { hashInput = hashInput + name; }
            if (cloneType == 1 || cloneType == 2) { hashInput += "constants<size(constants)>body<size(body)>"; }
           lines = body;
        }
        case \enumConstant(str name, list[Expression] arguments, Declaration class): {
            hashInput = "enumConstant1";
            if (cloneType == 1) { hashInput = hashInput + name; }
            if (cloneType == 1 || cloneType == 2) { hashInput += "arguments<size(arguments)>"; }
        }
        case \enumConstant(str name, list[Expression] arguments): {
            hashInput = "enumConstant2";
            if (cloneType == 1) { hashInput = hashInput + name; }
            if (cloneType == 1 || cloneType == 2) { hashInput += "arguments<size(arguments)>"; }
        }
        case \class(str name, list[Type] extends, list[Type] implements, list[Declaration] body): {
            hashInput = "class1";
            if (cloneType == 1) { hashInput = hashInput + name; }
            if (cloneType == 1 || cloneType == 2) { hashInput += "implements<size(implements)>body<size(body)>"; }
            lines = body;
        }
        case \class(list[Declaration] body): {
            hashInput ="class2";
            if (cloneType == 1 || cloneType == 2) { hashInput += "body<size(body)>"; }
            lines = body;
        }
        case \interface(str name, list[Type] extends, list[Type] implements, list[Declaration] body): {
            hashInput = "interface1";
            if (cloneType == 1) { hashInput = hashInput + name; }
            if (cloneType == 1 || cloneType == 2) { hashInput += "extends<size(extends)>implements<size(implements)>body<size(body)>"; }
            lines = body;
        }
        case \field(Type \type, list[Expression] fragments): {
            hashInput = "field1";
            if (cloneType == 1 || cloneType == 2) { hashInput += "fragments<size(fragments)>"; }
        }
        case \initializer(Statement initializerBody): {
            hashInput = "initializer1";
        }
        case \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl): {
            hashInput = "method1";
            if (cloneType == 1) { hashInput = hashInput + name; }
            if (cloneType == 1 || cloneType == 2) { hashInput += "parameters<size(parameters)>exceptions<size(exceptions)>"; }
        }
        case \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions): {
            hashInput = "method2";
            if (cloneType == 1) { hashInput = hashInput + name; }
            if (cloneType == 1 || cloneType == 2) { hashInput += "parameters<size(parameters)>exceptions<size(exceptions)>"; }
        }
        case \constructor(str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl): {
            hashInput = "constructor1";
            if (cloneType == 1) { hashInput = hashInput + name; }
            if (cloneType == 1 || cloneType == 2) { hashInput += "parameters<size(parameters)>exceptions<size(exceptions)>"; }
        }
        case \import(str name): {
            hashInput = "import1<name>";
        }
        case \package(str name): {
            hashInput = "package1<name>";
        }
        case \package(Declaration parentPackage, str name): {
            hashInput = "package2<name>";
        }
        case \variables(Type \type, list[Expression] \fragments): {
            hashInput = "variables1";
            if (cloneType == 1 || cloneType == 2) { hashInput += "fragments<size(\fragments)>"; }
        }
        case \typeParameter(str name, list[Type] extendsList): {
            hashInput = "typeParameter1";
            if (cloneType == 1) { hashInput = hashInput + name; }
            if (cloneType == 1 || cloneType == 2) { hashInput += "extendsList<size(extendsList)>"; }
        }
        case \annotationType(str name, list[Declaration] body): {
            hashInput = "annotationType1";
            if (cloneType == 1) { hashInput = hashInput + name; }
            if (cloneType == 1 || cloneType == 2) { hashInput += "body<size(body)>"; }
            lines = body;
        }
        case \annotationTypeMember(Type \type, str name): {
            hashInput = "annotationTypeMember1";
            if (cloneType == 1) { hashInput = hashInput + name; }
        }
        case \annotationTypeMember(Type \type, str name, Expression defaultBlock): {
            hashInput = "annotationTypeMember2";
            if (cloneType == 1) { hashInput = hashInput + name; }
        }
        case \parameter(Type \type, str name, int extraDimensions): {
            hashInput = "parameter1";
            if (cloneType == 1) { hashInput = hashInput + name + "<extraDimensions>"; }
        }
        case \vararg(Type \type, str name): {
            hashInput = "vararg1";
            if (cloneType == 1) { hashInput = hashInput + name; }
        }

        // Expressions
        case \arrayAccess(Expression array, Expression index): {
            hashInput = "arrayAccess1";
        }
        case \newArray(Type \type, list[Expression] dimensions, Expression init): {
            hashInput = "newArray1";
            if (cloneType == 1 || cloneType == 2) { hashInput += "dimensions<size(dimensions)>"; }
        }
        case \newArray(Type \type, list[Expression] dimensions): {
            hashInput = "newArray1";
            if (cloneType == 1 || cloneType == 2) { hashInput += "dimensions<size(dimensions)>"; }
        }
        case \arrayInitializer(list[Expression] elements): {
            hashInput = "arrayInitializer1";
            if (cloneType == 1 || cloneType == 2) { hashInput += "elements<size(elements)>"; }
        }
        case \assignment(Expression lhs, str operator, Expression rhs): {
            hashInput = "assignment1" + operator; // Operators cannot differ in T2, so are always included.
        }
        case \cast(Type \type, Expression expression): {
            hashInput = "cast1";
        }
        case \characterLiteral(str charValue): {
            hashInput = "characterLiteral1";
            if (cloneType == 1) { hashInput = hashInput + charValue; }
        }
        case \newObject(Expression expr, Type \type, list[Expression] args, Declaration class): {
            hashInput = "newObject1";
            if (cloneType == 1 || cloneType == 2) { hashInput += "args<size(args)>"; }
        }
        case \newObject(Expression expr, Type \type, list[Expression] args): {
            hashInput = "newObject2";
            if (cloneType == 1 || cloneType == 2) { hashInput += "args<size(args)>"; }
        }
        case \newObject(Type \type, list[Expression] args, Declaration class): {
            hashInput = "newObject3";
            if (cloneType == 1 || cloneType == 2) { hashInput += "args<size(args)>"; }
        }
        case \newObject(Type \type, list[Expression] args): {
            hashInput = "newObject4";
            if (cloneType == 1 || cloneType == 2) { hashInput += "args<size(args)>"; }
        }
        case \qualifiedName(Expression qualifier, Expression expression): {
            hashInput = "qualifiedName1";
        }
        case \conditional(Expression expression, Expression thenBranch, Expression elseBranch): {
            hashInput = "conditional1";
        }
        case \fieldAccess(bool isSuper, Expression expression, str name): {
            hashInput = "fieldAccess1<isSuper>";
            if (cloneType == 1) { hashInput = hashInput + name; }
        }
        case \fieldAccess(bool isSuper, str name): {
            hashInput = "fieldAccess2<isSuper>";
            if (cloneType == 1) { hashInput = hashInput + name; }
        }
        case \instanceof(Expression leftSide, Type rightSide): {
            hashInput = "instanceof1";
        }
        case \methodCall(bool isSuper, str name, list[Expression] arguments): {
            hashInput = "methodCall1<isSuper>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            if (cloneType == 1 || cloneType == 2) { hashInput += "arguments<size(arguments)>"; }
        }
        case \methodCall(bool isSuper, Expression receiver, str name, list[Expression] arguments): {
            hashInput = "methodCall2<isSuper>";
            if (cloneType == 1) { hashInput = hashInput + name; }
            if (cloneType == 1 || cloneType == 2) { hashInput += "arguments<size(arguments)>"; }
        }
        case \null(): {
            hashInput = "null1";
        }
        case \number(str numberValue): {
            hashInput = "number1";
            if (cloneType == 1) { hashInput = hashInput + numberValue; }
        }
        case \booleanLiteral(bool boolValue): {
            hashInput = "booleanLiteral1";
            if (cloneType == 1) { hashInput = hashInput + "<boolValue>"; }
        }
        case \stringLiteral(str stringValue): {
            hashInput = "stringLiteral1";
            if (cloneType == 1) { hashInput = hashInput + stringValue; }
        }
        case \type(Type \type): {
            hashInput = "type1";
        }
        case \variable(str name, int extraDimensions): {
            hashInput = "variable1";
            if (cloneType == 1) { hashInput = hashInput + name + "<extraDimensions>"; }
        }
        case \variable(str name, int extraDimensions, Expression \initializer): {
            hashInput = "variable2";
            if (cloneType == 1) { hashInput = hashInput + name + "<extraDimensions>"; }
        }
        case \bracket(Expression expression): {
            hashInput = "bracket1";
        }
        case \this(): {
            hashInput = "this1";
        }
        case \this(Expression thisExpression): {
            hashInput = "this2";
        }
        case \super(): {
            hashInput = "super1";
        }
        case \declarationExpression(Declaration declaration): {
            hashInput = "declarationExpression1";
        }
        case \infix(Expression lhs, str operator, Expression rhs): {
            hashInput = "infix1" + operator;
        }
        case \postfix(Expression operand, str operator): {
            hashInput = "postfix1" + operator;
        }
        case \prefix(str operator, Expression operand): {
            hashInput = "prefix1" + operator;
        }
        case \simpleName(str name): {
            hashInput = "simpleName1";
            if (cloneType == 1) { hashInput = hashInput + name; }
        }
        case \markerAnnotation(str typeName): {
            hashInput = "markerAnnotation1";
            if (cloneType == 1) { hashInput = hashInput + typeName; }
        }
        case \normalAnnotation(str typeName, list[Expression] memberValuePairs): {
            hashInput = "normalAnnotation1";
            if (cloneType == 1) { hashInput = hashInput + typeName; }
            if (cloneType == 1 || cloneType == 2) { hashInput += "memberValuePairs<size(memberValuePairs)>"; }
        }
        case \memberValuePair(str name, Expression \value): {
            hashInput = "memberValuePair1";
            if (cloneType == 1) { hashInput = hashInput + name; }
        }
        case \singleMemberAnnotation(str typeName, Expression \value): {
            hashInput = "singleMemberAnnotation1";
            if (cloneType == 1) { hashInput = hashInput + typeName; }
        }

        // Statements
        case \assert(Expression expression): {
            hashInput = "assert1";
        }
        case \assert(Expression expression, Expression message): {
            hashInput = "assert2";
        }
        case \block(list[Statement] statements): {
            hashInput = "block1";
            lines = statements;
            if (cloneType == 1 || cloneType == 2) { hashInput += "statements<size(statements)>"; }
        }
        case \break(): {
            hashInput = "break1";
        }
        case \break(str label): {
            hashInput = "break2";
            if (cloneType == 1) { hashInput = hashInput + label; }
        }
        case \continue(): {
            hashInput = "continue1";
        }
        case \continue(str label): {
            hashInput = "continue2";
            if (cloneType == 1) { hashInput = hashInput + label; }
        }
        case \do(Statement body, Expression condition): {
            hashInput = "do1";
        }
        case \empty(): {
            hashInput = "empty1";
        }
        case \foreach(Declaration parameter, Expression collection, Statement body): {
            hashInput = "foreach1";
        }
        case \for(list[Expression] initializers, Expression condition, list[Expression] updaters, Statement body): {
            hashInput = "for1";
            if (cloneType == 1 || cloneType == 2) { hashInput += "initializers<size(initializers)>updaters<size(updaters)>"; }
        }
        case \for(list[Expression] initializers, list[Expression] updaters, Statement body): {
            hashInput = "for2";
            if (cloneType == 1 || cloneType == 2) { hashInput += "initializers<size(initializers)>updaters<size(updaters)>"; }
        }
        case \if(Expression condition, Statement thenBranch): {
            hashInput = "if1";
        }
        case \if(Expression condition, Statement thenBranch, Statement elseBranch): {
            hashInput = "if2";
        }
        case \label(str name, Statement body): {
            hashInput = "label1";
            if (cloneType == 1) { hashInput = hashInput + name; }
        }
        case \return(Expression expression): {
            hashInput = "return1";
        }
        case \return(): {
            hashInput = "return2";
        }
        case \switch(Expression expression, list[Statement] statements): {
            hashInput = "switch1";
            if (cloneType == 1 || cloneType == 2) { hashInput += "statements<size(statements)>"; }
            lines = statements;
        }
        case \case(Expression expression): {
            hashInput = "case1";
        }
        case \defaultCase(): {
            hashInput = "defaultCase1";
        }
        case \synchronizedStatement(Expression lock, Statement body): {
            hashInput = "synchronizedStatement1";
        }
        case \throw(Expression expression): {
            hashInput = "throw1";
        }
        case \try(Statement body, list[Statement] catchClauses): {
            hashInput = "try1";
            if (cloneType == 1 || cloneType == 2) { hashInput += "catchClauses<size(catchClauses)>"; }
        }
        case \try(Statement body, list[Statement] catchClauses, Statement \finally): {
            hashInput = "try2";
            if (cloneType == 1 || cloneType == 2) { hashInput += "catchClauses<size(catchClauses)>"; }
        }
        case \catch(Declaration exception, Statement body): {
            hashInput = "catch1";
        }
        case \declarationStatement(Declaration declaration): {
            hashInput = "declarationStatement1";
        }
        case \while(Expression condition, Statement body): {
            hashInput = "while1";
        }
        case \expressionStatement(Expression stmt): {
            hashInput = "expressionStatement1";
        }
        case \constructorCall(bool isSuper, Expression expr, list[Expression] arguments): {
            hashInput = "constructorCall1<isSuper>";
            if (cloneType == 1 || cloneType == 2) { hashInput += "arguments<size(arguments)>"; }
        }
        case \constructorCall(bool isSuper, list[Expression] arguments): {
            hashInput = "constructorCall2<isSuper>";
            if (cloneType == 1 || cloneType == 2) { hashInput += "arguments<size(arguments)>"; }
        }

        // Types
        case arrayType(Type \type): {
            hashInput = "arrayType1";
        }
        case parameterizedType(Type \type): {
            hashInput = "parameterizedType1";
        }
        case qualifiedType(Type qualifier, Expression simpleName): {
            hashInput = "qualifiedType1";
        }
        case simpleType(Expression typeName): {
            hashInput = "simpleType1";
        }
        case unionType(list[Type] types): {
            hashInput = "unionType1";
            if (cloneType == 1 || cloneType == 2) { hashInput += "types<size(types)>"; }
        }
        case wildcard(): {
            hashInput = "wildcard1";
        }
        case upperbound(Type \type): {
            hashInput = "upperbound1";
        }
        case lowerbound(Type \type): {
            hashInput = "lowerbound1";
        }
        case \int(): {
            switch(cloneType) {
                case 1: hashInput = "int1";
                case 2: hashInput = "type";
            }
        }
        case short(): {
            switch(cloneType) {
                case 1: hashInput = "short1";
                case 2: hashInput = "type";
            }
        }
        case long(): {
            switch(cloneType) {
                case 1: hashInput = "long1";
                case 2: hashInput = "type";
            }
        }
        case float(): {
            switch(cloneType) {
                case 1: hashInput = "float1";
                case 2: hashInput = "type";
            }
        }
        case double(): {
            switch(cloneType) {
                case 1: hashInput = "double1";
                case 2: hashInput = "type";
            }
        }
        case char(): {
            switch(cloneType) {
                case 1: hashInput = "char1";
                case 2: hashInput = "type";
            }
        }
        case string(): {
            switch(cloneType) {
                case 1: hashInput = "string1";
                case 2: hashInput = "type";
            }
        }
        case byte(): {
            switch(cloneType) {
                case 1: hashInput = "byte1";
                case 2: hashInput = "type";
            }
        }
        case \void(): {
            switch(cloneType) {
                case 1: hashInput = "void1";
                case 2: hashInput = "type";
            }
        }
        case \boolean(): {
            switch(cloneType) {
                case 1: hashInput = "boolean1";
                case 2: hashInput = "type";
            }
        }

        // Modifiers
        case \private(): {
            hashInput = "private1";
        }
        case \public(): {
            hashInput = "public1";
        }
        case \protected(): {
            hashInput = "protected1";
        }
        case \friendly(): {
            hashInput = "friendly1";
        }
        case \static(): {
            hashInput = "static1";
        }
        case \final(): {
            hashInput = "final1";
        }
        case \synchronized(): {
            hashInput = "synchronized1";
        }
        case \transient(): {
            hashInput = "transient1";
        }
        case \abstract(): {
            hashInput = "abstract1";
        }
        case \native(): {
            hashInput = "native1";
        }
        case \volatile(): {
            hashInput = "volatile1";
        }
        case \strictfp(): {
            hashInput = "strictfp1";
        }
        case \annotation(Expression \anno): {
            hashInput = "annotation1";
        }
        case \onDemand(): {
            hashInput = "onDemand1";
        }
        case \default(): {
            hashInput = "default1";
        }
    }

    // Also add subsequences within code blocks to the hash map.
    if (!isEmpty(lines)) {
        hm = lineSubsequences(lines, cloneType, hm, massThreshold, location);
    }

    tuple[tuple[tuple[list[str] tree,int weight] subtree,list[str] childHash] subtreeInfo, map[str hash, tuple[int weight,list[loc] locations] values] hm] treeAndMap
        = getSubtree(hash, n, hm, massThreshold);
    // subtrees = ([hash]:1) + treesAndMap.subtrees;

    // println("Hash:");
    // iprintln(hash);
    // println("Subtrees:");
    // iprintln(subtrees);
    // println("\n");
    // iprintln(treesAndMap.hm);

    if (hash == "") {
        return(<setKeywordParameters(n, getKeywordParameters(n) + ("hash": hash) + ("subtree": <[],0>)), treeAndMap.hm>);
    }
    return(<setKeywordParameters(n, getKeywordParameters(n) + ("hash": hash) + ("subtree": treeAndMap.subtreeInfo.subtree)), treeAndMap.hm>);
}
