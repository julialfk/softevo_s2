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
import Map;

map[list[str]subtree, int weight] getSubtrees(str parentHash, node n) {
    map[list[str], int] subtrees = ();
    list[value] children = getChildren(n);
    // println("Children:");
    // iprintln(children);
    
    for(node child <- children) {
        // println("Child:");
        // iprintln(child);

        // println("Params:");
        // iprintln(typeOf(getKeywordParameters(child)["subtrees"]));
        map[list[str], int] childTrees = typeCast(#map[list[str], int], getKeywordParameters(child)["subtrees"]);
        for (treeKey <- domain(childTrees)) {
            subtrees = subtrees + (parentHash + treeKey: childTrees[treeKey] + 1);
        }
        // println("Showning type = <typeOf(child)>");
        // iprintln(child);
        // println("params = <getKeywordParameters(child)>");
    }

    return subtrees;
}


// tuple[str hash, map[list[str] subtree, int weight] subtrees]

node calcNode(node n, int cloneType) {
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
            subtrees = ([hash]: 1) + getSubtrees(hash, n);
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

    // println("Hash:");
    // iprintln(hash);
    // println("Subtrees:");
    // iprintln(subtrees);
    // println("\n");

    node m = setKeywordParameters(n, getKeywordParameters(n) + ("hash": hash) + ("subtrees": subtrees));
    iprintln(m);
    // list[value] children = getChildren(n);
    // subtrees = ([hash]:1) + getSubtrees(hash, children);
    return m;
}
