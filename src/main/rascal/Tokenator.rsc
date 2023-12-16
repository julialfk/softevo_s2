module Lexer

import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;
import String;
import Node;
import List;


list[tuple[str, list[loc]]] visitNode(node n, list[tuple[str, list[loc]]] file, int cloneType) {
    // iprintln(n);
    list[loc] nodeSrc = [];
    switch (n) {
        // Declarations
        case \compilationUnit(list[Declaration] imports, list[Declaration] types): {
            for (imp <- imports) {
                file = visitNode(imp, file, cloneType);
            }
            for (typ <- types) {
                file = visitNode(typ, file, cloneType);
            }
        }
        case \compilationUnit(Declaration package, list[Declaration] imports, list[Declaration] types): {
            file = visitNode(package, file, cloneType);
            for (imp <- imports) {
                file = visitNode(imp, file, cloneType);
            }
            for (typ <- types) {
                file = visitNode(typ, file, cloneType);
            }
        }
        case \enum(str name, list[Type] implements, list[Declaration] constants, list[Declaration] body): {
            if (cloneType == 1) { file += <"__ENUM_<name> {", [getKeywordParameters(n)["src"]]>; }
            else { file += <"__ENUM__ {", [getKeywordParameters(n)["src"]]>; }
            for (implement <- implements) {
                file = visitNode(implement, file, cloneType);
            }
            for (constant <- constants) {
                file = visitNode(constant, file, cloneType);
            }
            for (line <- body) {
                file = visitNode(line, file, cloneType);
            }
            lastLine = size(file) - 1;
            file[lastLine][0] += "}";
        }
        case \enumConstant(str name, list[Expression] arguments, Declaration class): {
            if (cloneType == 1) { file += <"__ENUMCONSTANT_<name> {", [getKeywordParameters(n)["src"]]>; }
            else { file += <"__ENUMCONSTANT__ {", [getKeywordParameters(n)["src"]]>; }
            for (argument <- arguments) {
                file = visitNode(argument, file, cloneType);
            }
            file = visitNode(class, file, cloneType);
            lastLine = size(file) - 1;
            file[lastLine][0] += "}";
        }
        case \enumConstant(str name, list[Expression] arguments): {
            if (cloneType == 1) { file += <"__ENUMCONSTANT_<name> {", [getKeywordParameters(n)["src"]]>; }
            else { file += <"__ENUMCONSTANT__ {", [getKeywordParameters(n)["src"]]>; }
            for (argument <- arguments) {
                file = visitNode(argument, file, cloneType);
            }
            lastLine = size(file) - 1;
            file[lastLine][0] += "}";
        }
        case \class(str name, list[Type] extends, list[Type] implements, list[Declaration] body): {
            if (cloneType == 1) { file += <"__CLASS_<name> ", [getKeywordParameters(n)["src"]]>; }
            else { file += <"__CLASS__ ", [getKeywordParameters(n)["src"]]>; }
            int lastLine = size(file) - 1;
            for (ext <- extends) {
                file[lastLine][0] += "__EXTENDS_";
                file = visitNode(ext, file, cloneType);
            }
            for (implement <- implements) {
                file[lastLine][0] += "__IMPLEMENTS_";
                file = visitNode(implement, file, cloneType);
            }
            file[lastLine][0] += "{";
            for (line <- body) {
                file = visitNode(line, file, cloneType);
            }
            lastLine = size(file) - 1;
            file[lastLine][0] += "}";
        }
        case \class(list[Declaration] body): {
            file += <"__CLASS {", [getKeywordParameters(n)["src"]]>;
            for (line <- body) {
                file = visitNode(line, file, cloneType);
            }
            lastLine = size(file) - 1;
            file[lastLine][0] += "}";
        }
        case \interface(str name, list[Type] extends, list[Type] implements, list[Declaration] body): {
            if (cloneType == 1) { file += <"__INTERFACE_<name> ", [getKeywordParameters(n)["src"]]>; }
            else { file += <"__INTERFACE__ ", [getKeywordParameters(n)["src"]]>; }
            int lastLine = size(file) - 1;
            for (ext <- extends) {
                file[lastLine][0] += "__EXTENDS_";
                file = visitNode(ext, file, cloneType);
            }
            for (implement <- implements) {
                file[lastLine][0] += "__IMPLEMENTS_";
                file = visitNode(implement, file, cloneType);
            }
            file[lastLine][0] += "{";
            for (line <- body) {
                file = visitNode(line, file, cloneType);
            }
            lastLine = size(file) - 1;
            file[lastLine][0] += "}";
        }
        case \field(Type \type, list[Expression] fragments): {
            file += <"", [getKeywordParameters(n)["src"]]>;
            file = visitNode(\type, file, cloneType);
            for (fragment <- fragments) {
                file = visitNode(fragment, file, cloneType);
            }
        }
        case \initializer(Statement initializerBody): {
            file += <"__INIT_", [getKeywordParameters(n)["src"]]>;
            file = visitNode(initializerBody, file, cloneType);
        }
        case \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl): {
            file += <"__METHOD_", [getKeywordParameters(n)["src"]]>;
            file = visitNode(\return, file, cloneType);
            int lastLine = size(file) - 1;
            if (cloneType == 1) { file[lastLine][0] += "<name> ("; }
            else { file[lastLine][0] += "__METHODNAME__ ("; }
            for (parameter <- parameters) {
                file[lastLine][0] += "__PARAM_";
                file = visitNode(parameter, file, cloneType);
            }
            file[lastLine][0] += ") ";
            for (exception <- exceptions) { // Check how this works.
                file[lastLine][0] += "__EXCEPT_";
                file = visitNode(exception, file, cloneType);
            }
            file[lastLine][0] += "{";
            file = visitNode(impl, file, cloneType);
            lastLine = size(file) - 1;
            file[lastLine][0] += "}";
        }
        case \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions): {
            file += <"__METHOD_", [getKeywordParameters(n)["src"]]>;
            file = visitNode(\return, file, cloneType);
            int lastLine = size(file) - 1;
            if (cloneType == 1) { file[lastLine][0] += "<name> ("; }
            else { file[lastLine][0] += "__METHODNAME__ ("; }
            for (parameter <- parameters) {
                file[lastLine][0] += "__PARAM_";
                file = visitNode(parameter, file, cloneType);
            }
            file[lastLine][0] += ") ";
            for (exception <- exceptions) { // Check how this works.
                file[lastLine][0] += "__EXCEPT_";
                file = visitNode(exception, file, cloneType);
            }
        }
        case \constructor(str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl): {
            if (cloneType == 1) { file += <"__CONSTRUCTOR_<name>(", [getKeywordParameters(n)["src"]]>; }
            else { file += <"__CONSTRUCTOR_(", [getKeywordParameters(n)["src"]]>; }
            int lastLine = size(file) - 1;
            for (parameter <- parameters) {
                file[lastLine][0] += "__PARAM_";
                file = visitNode(parameter, file, cloneType);
            }
            file[lastLine][0] += ") ";
            for (exception <- exceptions) { // Check how this works.
                file[lastLine][0] += "__EXCEPT_";
                file = visitNode(exception, file, cloneType);
            }
            file = visitNode(impl, file, cloneType);
        }
        case \import(str name): {
            file += <"__IMPORT_<name>", [getKeywordParameters(n)["src"]]>;
        }
        case \package(str name): {
            map[str, value] nodeParams = getKeywordParameters(n);
            if ("src" in nodeParams) {nodeSrc += [nodeParams["src"]];} // Dit gaat niet goed
            file += <"__PACKAGE_<name>", nodeSrc>;
        }
        case \package(Declaration parentPackage, str name): {
            file = visitNode(parentPackage, file, cloneType);
            int lastLine = size(file) - 1;
            if (isEmpty(file[lastLine][1])) {
                map[str, value] nodeParams = getKeywordParameters(n);
                if ("src" in nodeParams) {nodeSrc += [nodeParams["src"]];} // Dit gaat niet goed
            }
            file[lastLine][0] += ".<name>";
        }
        case \variables(Type \type, list[Expression] \fragments): {
            file = visitNode(\type, file, cloneType);
            for (fragment <- \fragments) {
                file = visitNode(fragment, file, cloneType);
            }
        }
        case \typeParameter(str name, list[Type] extendsList): {
            int lastLine = size(file) - 1;
            if (cloneType == 1) { file[lastLine][0] += "\<<name>"; }
            else { file[lastLine][0] += "\<__TYPEPARAM__"; }
            for (ext <- extendsList) {
                file[lastLine][0] += "EXTENDS ";
                file = visitNode(ext, file, cloneType);
            }
            file[lastLine][0] += "\>";
        }
        case \annotationType(str name, list[Declaration] body): {
            if (cloneType == 1) { file += <"__ANNOTATIONTYPE@<name> {", [getKeywordParameters(n)["src"]]>; }
            else { file += <"__ANNOTATIONTYPE@ {", [getKeywordParameters(n)["src"]]>; }
            for (line <- body) {
                file = visitNode(line, file, cloneType);
            }
            lastLine = size(file) - 1;
            file[lastLine][0] += "}";
        }
        case \annotationTypeMember(Type \type, str name): {
            file += <"__ANNOTATIONTYPEMEMBER@", [getKeywordParameters(n)["src"]]>;
            file = visitNode(\type, file, cloneType);
            int lastLine = size(file) - 1;
            if (cloneType == 1) { file[lastLine][0] += "<name>"; }
            else { file[lastLine][0] += "__ANNOTYPENAME__"; }
        }
        case \annotationTypeMember(Type \type, str name, Expression defaultBlock): {
            file += <"__ANNOTATIONTYPEMEMBER@", [getKeywordParameters(n)["src"]]>;
            file = visitNode(\type, file, cloneType);
            int lastLine = size(file) - 1;
            if (cloneType == 1) { file[lastLine][0] += "<name> DEFAULT"; }
            else { file[lastLine][0] += "__ANNOTYPENAME__ DEFAULT"; }
            file = visitNode(defaultBlock, file, cloneType);
        }
        case \parameter(Type \type, str name, int extraDimensions): {
            file = visitNode(\type, file, cloneType);
            int lastLine = size(file) - 1;
            if (cloneType == 1) { file[lastLine][0] += "<name> "; }
            else { file[lastLine][0] += "__PARAM__"; }
            int i = 0;
            while (i < extraDimensions) {
                file[lastLine][0] += "[]";
                i += 1;
            }
        }
        case \vararg(Type \type, str name): {
            file = visitNode(\type, file, cloneType);
            int lastLine = size(file) - 1;
            if (cloneType == 1) { file[lastLine][0] += "... <name> "; }
            else { file[lastLine][0] += "... __VARARG__ "; }
        }

        // Expressions
        case \arrayAccess(Expression array, Expression index): {
            file = visitNode(array, file, cloneType);
            int lastLine = size(file) - 1;
            file[lastLine][0] += "[";
            file = visitNode(index, file, cloneType);
            file[lastLine][0] += "] ";
        }
        case \newArray(Type \type, list[Expression] dimensions, Expression init): {
            file = visitNode(\type, file, cloneType);
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__NEW_";
            if (cloneType == 1) {
                for (dimension <- dimensions) {
                    file[lastLine][0] += "[";
                    file = visitNode(dimension, file, cloneType);
                    file[lastLine][0] += "]";
                }
            }
            file = visitNode(init, file, cloneType);
        }
        case \newArray(Type \type, list[Expression] dimensions): {
            file = visitNode(\type, file, cloneType);
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__NEW_";
            if (cloneType == 1) {
                for (dimension <- dimensions) {
                    file[lastLine][0] += "[";
                    file = visitNode(dimension, file, cloneType);
                    file[lastLine][0] += "]";
                }
            }
        }
        case \arrayInitializer(list[Expression] elements): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "{";
            for (element <- elements) {
                file[lastLine][0] += "__ELEM_";
                file = visitNode(element, file, cloneType);
            }
            file[lastLine][0] += "}";
        }
        case \assignment(Expression lhs, str operator, Expression rhs): {
            int lastLine = size(file) - 1;
            file = visitNode(lhs, file, cloneType);
            file[lastLine][0] += "<operator> ";
            file = visitNode(rhs, file, cloneType);
        }
        case \cast(Type \type, Expression expression): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__CAST(";
            file = visitNode(\type, file, cloneType);
            file[lastLine][0] += ")";
            file = visitNode(expression, file, cloneType);
        }
        case \characterLiteral(str charValue): {
            int lastLine = size(file) - 1;
            if (cloneType == 1) { file[lastLine][0] += "\'<charValue>\'"; }
            else { file[lastLine][0] += "\'__CHARLIT__\'"; }
        }
        case \newObject(Expression expr, Type \type, list[Expression] args, Declaration class): { // expr: arrays, class: templates
            int lastLine = size(file) - 1;
            file = visitNode(expr, file, cloneType);
            file[lastLine][0] += ".__NEW_";
            file = visitNode(\type, file, cloneType);
            file[lastLine][0] += "(";
            for (arg <- args) {
                file[lastLine][0] += "__ARG_";
                file = visitNode(arg, file, cloneType);
            }
            file[lastLine][0] += ")";
            file = visitNode(class, file, cloneType);
        }
        case \newObject(Expression expr, Type \type, list[Expression] args): {
            int lastLine = size(file) - 1;
            file = visitNode(expr, file, cloneType);
            file[lastLine][0] += ".__NEW_";
            file = visitNode(\type, file, cloneType);
            file[lastLine][0] += "(";
            for (arg <- args) {
                file[lastLine][0] += "__ARG_";
                file = visitNode(arg, file, cloneType);
            }
            file[lastLine][0] += ")";
        }
        case \newObject(Type \type, list[Expression] args, Declaration class): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__NEW_";
            file = visitNode(\type, file, cloneType);
            file[lastLine][0] += "(";
            for (arg <- args) {
                file[lastLine][0] += "__ARG_";
                file = visitNode(arg, file, cloneType);
            }
            file[lastLine][0] += ") {";
            file = visitNode(class, file, cloneType);
            lastLine = size(file) - 1;
            file[lastLine][0] += "}";
        }
        case \newObject(Type \type, list[Expression] args): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__NEW_";
            file = visitNode(\type, file, cloneType);
            file[lastLine][0] += "(";
            for (arg <- args) {
                file[lastLine][0] += "__ARG_";
                file = visitNode(arg, file, cloneType);
            }
            file[lastLine][0] += ")";
        }
        case \qualifiedName(Expression qualifier, Expression expression): {
            int lastLine = size(file) - 1;
            file = visitNode(qualifier, file, cloneType);
            file[lastLine][0] += ".";
            file = visitNode(expression, file, cloneType);
        }
        case \conditional(Expression expression, Expression thenBranch, Expression elseBranch): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "(";
            file = visitNode(expression, file, cloneType);
            file[lastLine][0] += ") ? ";
            file = visitNode(thenBranch, file, cloneType);
            file[lastLine][0] += ": ";
            file = visitNode(elseBranch, file, cloneType);
        }
        case \fieldAccess(bool isSuper, Expression expression, str name): {
            int lastLine = size(file) - 1;
            if (isSuper) { file[lastLine][0] += "__SUPER."; }
            file = visitNode(expression, file, cloneType);
            if (cloneType == 1) { file[lastLine][0] += "<name> "; }
            else { file[lastLine][0] += "__FIELDACCESS__ "; }
        }
        case \fieldAccess(bool isSuper, str name): {
            int lastLine = size(file) - 1;
            if (isSuper) { file[lastLine][0] += "__SUPER."; }
            if (cloneType == 1) { file[lastLine][0] += "<name> "; }
            else { file[lastLine][0] += "__FIELDACCESS__ "; }
        }
        case \instanceof(Expression leftSide, Type rightSide): {
            file = visitNode(leftSide, file, cloneType);
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__INSTANCEOF_";
            file = visitNode(rightSide, file, cloneType);
        }
        case \methodCall(bool isSuper, str name, list[Expression] arguments): {
            int lastLine = size(file) - 1;
            if (isSuper) { file[lastLine][0] += "__SUPER."; }
            if (cloneType == 1) { file[lastLine][0] += "<name>("; }
            else { file[lastLine][0] += "__METHODCALL__("; }
            for (argument <- arguments) {
                file[lastLine][0] += "__ARG_";
                file = visitNode(argument, file, cloneType);
            }
            file[lastLine][0] += ") ";
        }
        case \methodCall(bool isSuper, Expression receiver, str name, list[Expression] arguments): {
            int lastLine = size(file) - 1;
            if (isSuper) { file[lastLine][0] += "__SUPER."; }
            file = visitNode(receiver, file, cloneType);
            if (cloneType == 1) { file[lastLine][0] += ".<name>("; }
            else { file[lastLine][0] += ".__METHODCALL__("; }
            for (argument <- arguments) {
                file[lastLine][0] += "__ARG_";
                file = visitNode(argument, file, cloneType);
            }
            file[lastLine][0] += ") ";
        }
        case \null(): {
            int lastLine = size(file) - 1;
            if (cloneType == 1) { file[lastLine][0] += "__NULL__ "; }
            else { file[lastLine][0] += "__VALUE__ "; }
        }
        case \number(str numberValue): {
            int lastLine = size(file) - 1;
            if (cloneType == 1) { file[lastLine][0] += "<numberValue> "; }
            else { file[lastLine][0] += "__VALUE__ "; }
        }
        case \booleanLiteral(bool boolValue): {
            int lastLine = size(file) - 1;
            if (cloneType == 1) { file[lastLine][0] += "<boolValue> "; }
            else { file[lastLine][0] += "__VALUE__ "; }
        }
        case \stringLiteral(str stringValue): {
            int lastLine = size(file) - 1;
            if (cloneType == 1) { file[lastLine][0] += "<stringValue> "; }
            else { file[lastLine][0] += "__VALUE__ "; }
        }
        case \type(Type \type): {
            file = visitNode(\type, file, cloneType);
        }
        case \variable(str name, int extraDimensions): {
            int lastLine = size(file) - 1;
            if (cloneType == 1) { file[lastLine][0] += "<name>"; }
            else { file[lastLine][0] += "__VARIABLE__ "; }
            int i = 0;
            while (i < extraDimensions) {
                file[lastLine][0] += "[]";
                i += 1;
            }
            file[lastLine][0] += " ";
        }
        case \variable(str name, int extraDimensions, Expression \initializer): {
            int lastLine = size(file) - 1;
            if (cloneType == 1) { file[lastLine][0] += "<name>"; }
            else { file[lastLine][0] += "__VARIABLE__ "; }
            int i = 0;
            while (i < extraDimensions) {
                file[lastLine][0] += "[]";
                i += 1;
            }
            file[lastLine][0] += " = ";
            file = visitNode(\initializer, file, cloneType);
        }
        case \bracket(Expression expression): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "( ";
            file = visitNode(expression, file, cloneType);
            file[lastLine][0] += ")";
        }
        case \this(): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__THIS_";
        }
        case \this(Expression thisExpression): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__THIS.";
            file = visitNode(thisExpression, file, cloneType);
        }
        case \super(): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__SUPER_";
        }
        case \declarationExpression(Declaration declaration): {
            file = visitNode(declaration, file, cloneType);
        }
        case \infix(Expression lhs, str operator, Expression rhs): {
            int lastLine = size(file) - 1;
            file = visitNode(lhs, file, cloneType);
            file[lastLine][0] += "<operator> ";
            file = visitNode(rhs, file, cloneType);
        }
        case \postfix(Expression operand, str operator): {
            int lastLine = size(file) - 1;
            file = visitNode(operand, file, cloneType);
            file[lastLine][0] += "<operator> ";
        }
        case \prefix(str operator, Expression operand): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "<operator> ";
            file = visitNode(operand, file, cloneType);
        }
        case \simpleName(str name): {
            int lastLine = size(file) - 1;
            if (cloneType == 1) { file[lastLine][0] += "<name> "; }
            else { file[lastLine][0] += "__SIMPLENAME__ "; }
        }
        case \markerAnnotation(str typeName): {
            file += <"__MARKER@<typeName>() ", [getKeywordParameters(n)["src"]]>;
        }
        case \normalAnnotation(str typeName, list[Expression] memberValuePairs): {
            file += <"__NORMAL@<typeName>(", [getKeywordParameters(n)["src"]]>;
            for (pair <- memberValuePairs) { file = visitNode(pair, file, cloneType); }
            int lastLine = size(file) - 1;
            file[lastLine][0] += ") ";
        }
        case \memberValuePair(str name, Expression \value): {
            int lastLine = size(file) - 1;
            if (cloneType == 1) { file[lastLine][0] += "__PAIR_<name> = "; }
            else { file[lastLine][0] += "__PAIR__ = "; }
            file = visitNode(\value, file, cloneType);
        }
        case \singleMemberAnnotation(str typeName, Expression \value): {
            file += <"__SINGLEMEM@<typeName>(", [getKeywordParameters(n)["src"]]>;
            file = visitNode(\value, file, cloneType);
            int lastLine = size(file) - 1;
            file[lastLine][0] += ") ";
        }

        // Statements
        case \assert(Expression expression): {
            file += <"__ASSERT_", [getKeywordParameters(n)["src"]]>;
            file = visitNode(expression, file, cloneType);
        }
        case \assert(Expression expression, Expression message): {
            int lastLine = size(file) - 1;
            file += <"__ASSERT_", [getKeywordParameters(n)["src"]]>;
            file = visitNode(expression, file, cloneType);
            file[lastLine][0] += ": ";
            file = visitNode(message, file, cloneType);
        }
        case \block(list[Statement] statements): {
            for (statement <- statements) {
                file = visitNode(statement, file, cloneType);
            }
        }
        case \break(): {
            file += <"__BREAK__", [getKeywordParameters(n)["src"]]>;
        }
        case \break(str label): { // Not sure if label should also be included in t2
            file += <"__BREAK_<label>", [getKeywordParameters(n)["src"]]>;
        }
        case \continue(): {
            file += <"__CONTINUE__", [getKeywordParameters(n)["src"]]>;
        }
        case \continue(str label): { // Not sure if label should also be included in t2
            file += <"__CONTINUE_<label>", [getKeywordParameters(n)["src"]]>;
        }
        case \do(Statement body, Expression condition): {
            file += <"__DO_{", [getKeywordParameters(n)["src"]]>;
            file = visitNode(body, file, cloneType);
            file += <"}_WHILE_(", [getKeywordParameters(n)["src"]]>;
            file = visitNode(condition, file, cloneType);
            int lastLine = size(file) - 1;
            file[lastLine][0] += ")";
        }
        case \empty(): {
            file += <"", [getKeywordParameters(n)["src"]]>;
        }
        case \foreach(Declaration parameter, Expression collection, Statement body): {
            file += <"__FOR_(", [getKeywordParameters(n)["src"]]>;
            file = visitNode(parameter, file, cloneType);
            int lastLine = size(file) - 1;
            file[lastLine][0] += ": ";
            file = visitNode(collection, file, cloneType);
            file[lastLine][0] += "{";
            file = visitNode(body, file, cloneType);
            lastLine = size(file) - 1;
            file[lastLine][0] += "}";
        }
        case \for(list[Expression] initializers, Expression condition, list[Expression] updaters, Statement body): {
            file += <"__FOR_(", [getKeywordParameters(n)["src"]]>;
            int lastLine = size(file) - 1;

            int nInit = size(initializers);
            for (int i <- [0..nInit]) {
                file = visitNode(initializers[i], file, cloneType);
                if (i+1 < nInit) { file[lastLine][0] += ", "; }
            }
            file[lastLine][0] += "; ";

            file = visitNode(condition, file, cloneType);
            file[lastLine][0] += "; ";

            int nUpdate = size(updaters);
            for (int i <- [0..nUpdate]) {
                file = visitNode(updaters[i], file, cloneType);
                if (i+1 < nUpdate) { file[lastLine][0] += ", "; }
            }
            file[lastLine][0] += ") {";
            
            file = visitNode(body, file, cloneType);
            file[lastLine][0] += "; ";
        }
        case \for(list[Expression] initializers, list[Expression] updaters, Statement body): {
            file += <"__FOR_(", [getKeywordParameters(n)["src"]]>;
            int lastLine = size(file) - 1;

            int nInit = size(initializers);
            for (int i <- [0..nInit]) {
                file = visitNode(initializers[i], file, cloneType);
                if (i+1 < nInit) { file[lastLine][0] += ", "; }
            }
            file[lastLine][0] += "; ; ";

            int nUpdate = size(updaters);
            for (int i <- [0..nUpdate]) {
                file = visitNode(updaters[i], file, cloneType);
                if (i+1 < nUpdate) { file[lastLine][0] += ", "; }
            }
            file[lastLine][0] += ") {";
            
            file = visitNode(body, file, cloneType);
            file[lastLine][0] += "; ";
        }
        case \if(Expression condition, Statement thenBranch): {
            file += <"__IF_(", [getKeywordParameters(n)["src"]]>;
            file = visitNode(condition, file, cloneType);
            int lastLine = size(file) - 1;
            file[lastLine][0] += ") {";
            file = visitNode(thenBranch, file, cloneType);
            lastLine = size(file) - 1;
            file[lastLine][0] += "}";
        }
        case \if(Expression condition, Statement thenBranch, Statement elseBranch): {
            file += <"__IF_(", [getKeywordParameters(n)["src"]]>;
            file = visitNode(condition, file, cloneType);
            int lastLine = size(file) - 1;
            file[lastLine][0] += ") {";
            file = visitNode(thenBranch, file, cloneType);
            file += <"}_ELSE_{", [getKeywordParameters(n)["src"]]>;
            file = visitNode(elseBranch, file, cloneType);
            lastLine = size(file) - 1;
            file[lastLine][0] += "}";
        }
        case \label(str name, Statement body): {
            if (cloneType == 1) { file += <"<name>: {", [getKeywordParameters(n)["src"]]>; }
            else { file += <"__LABEL__: {", [getKeywordParameters(n)["src"]]>; }
            file = visitNode(body, file, cloneType);
        }
        case \return(Expression expression): {
            file += <"__RETURN_(", [getKeywordParameters(n)["src"]]>;
            file = visitNode(expression, file, cloneType);
            int lastLine = size(file) - 1;
            file[lastLine][0] += ")";
        }
        case \return(): {
            file += <"__RETURN__", [getKeywordParameters(n)["src"]]>;
        }
        case \switch(Expression expression, list[Statement] statements): {
            file += <"__SWITCH_(", [getKeywordParameters(n)["src"]]>;
            file = visitNode(expression, file, cloneType);
            int lastLine = size(file) - 1;
            file[lastLine][0] += ") {";
            for (statement <- statements) {
                file = visitNode(statement, file, cloneType);
            }
            lastLine = size(file) - 1;
            file[lastLine][0] += "}";
        }
        case \case(Expression expression): {
            file += <"__CASE_", [getKeywordParameters(n)["src"]]>;
            file = visitNode(expression, file, cloneType);
            int lastLine = size(file) - 1;
            file[lastLine][0] += ":";
        }
        case \defaultCase(): {
            file += <"__DEFAULT:", [getKeywordParameters(n)["src"]]>;
        }
        case \synchronizedStatement(Expression lock, Statement body): {
            file += <"__SYNCHRONIZED(", [getKeywordParameters(n)["src"]]>;
            file = visitNode(lock, file, cloneType);
            int lastLine = size(file) - 1;
            file[lastLine][0] += ") {";
            file = visitNode(body, file, cloneType);
            lastLine = size(file) - 1;
            file[lastLine][0] += "}";
        }
        case \throw(Expression expression): {
            file += <"__THROW_", [getKeywordParameters(n)["src"]]>;
            file = visitNode(expression, file, cloneType);
        }
        case \try(Statement body, list[Statement] catchClauses): {
            file += <"__TRY_{", [getKeywordParameters(n)["src"]]>;
            file = visitNode(body, file, cloneType);
            lastLine = size(file) - 1;
            file[lastLine][0] += "}";
            for (clause <- catchClauses) {
                file = visitNode(clause, file, cloneType);
            }
        }
        case \try(Statement body, list[Statement] catchClauses, Statement \finally): {
            file += <"__TRY_{", [getKeywordParameters(n)["src"]]>;
            file = visitNode(body, file, cloneType);
            lastLine = size(file) - 1;
            file[lastLine][0] += "}";
            for (clause <- catchClauses) {
                file = visitNode(clause, file, cloneType);
            }
            file += <"__FINALLY_{", [getKeywordParameters(n)["src"]]>;
            file = visitNode(\finally, file, cloneType);
            lastLine = size(file) - 1;
            file[lastLine][0] += "}";
        }
        case \catch(Declaration exception, Statement body): {
            file += <"__CATCH_(", [getKeywordParameters(n)["src"]]>;
            file = visitNode(exception, file, cloneType);
            int lastLine = size(file) - 1;
            file[lastLine][0] += ") {";
            file = visitNode(body, file, cloneType);
            lastLine = size(file) - 1;
            file[lastLine][0] += "}";
        }
        case \declarationStatement(Declaration declaration): {
            file += <"", [getKeywordParameters(n)["src"]]>;
            file = visitNode(declaration, file, cloneType);
        }
        case \while(Expression condition, Statement body): {
            file += <"__WHILE_(", [getKeywordParameters(n)["src"]]>;
            file = visitNode(condition, file, cloneType);
            int lastLine = size(file) - 1;
            file[lastLine][0] += ") {";
            file = visitNode(body, file, cloneType);
            lastLine = size(file) - 1;
            file[lastLine][0] += "}";
        }
        case \expressionStatement(Expression stmt): {
            file += <"", [getKeywordParameters(n)["src"]]>;
            file = visitNode(stmt, file, cloneType);
        }
        case \constructorCall(bool isSuper, Expression expr, list[Expression] arguments): {
            int lastLine = size(file) - 1;
            if (isSuper) { file[lastLine][0] += "SUPER("; }
            else { file[lastLine][0] += "THIS.("; }
            file += visitNode(expr, file, cloneType);
            for (argument <- arguments) { file = visitNode(argument, file, cloneType); }
            file[lastLine][0] += ") ";
        }
        case \constructorCall(bool isSuper, list[Expression] arguments): {
            int lastLine = size(file) - 1;
            if (isSuper) {file[lastLine][0] += "SUPER("; }
            else { file[lastLine][0] += "THIS("; }
            for (argument <- arguments) { file = visitNode(argument, file, cloneType); }
            file[lastLine][0] += ") ";
        }

        // Types
        case arrayType(Type \type): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__ARRAYTYPE_";
            file = visitNode(\type, file, cloneType);
        }
        case parameterizedType(Type \type): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__PARAMTYPE_";
            file = visitNode(\type, file, cloneType);
        }
        case qualifiedType(Type qualifier, Expression simpleName): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__QUALTYPE_";
            file = visitNode(qualifier, file, cloneType);
            file[lastLine][0] += ".";
            file = visitNode(simpleName, file, cloneType);
        }
        case simpleType(Expression typeName): {
            file = visitNode(typeName, file, cloneType);
        }
        case unionType(list[Type] types): {
            file += <"__UNIONTYPE(", [getKeywordParameters(n)["src"]]>;
            int lastLine = size(file) - 1;
            for (utype <- types) {
                file[lastLine][0] += "__UNIONTYPE_";
                file = visitNode(utype, file, cloneType);
            }
            file[lastLine][0] += ") ";
        }
        case wildcard(): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "? ";
        }
        case upperbound(Type \type): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__EXTENDS_";
            file = visitNode(\type, file, cloneType);
        }
        case lowerbound(Type \type): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__SUPER_";
            file = visitNode(\type, file, cloneType);
        }
        case \int(): {
            int lastLine = size(file) - 1;
            if (cloneType == 1) { file[lastLine][0] += "__INT_"; }
            else { file[lastLine][0] += "__TYPE_"; }
        }
        case short(): {
            int lastLine = size(file) - 1;
            if (cloneType == 1) { file[lastLine][0] += "__SHORT_"; }
            else { file[lastLine][0] += "__TYPE_"; }
        }
        case long(): {
            int lastLine = size(file) - 1;
            if (cloneType == 1) { file[lastLine][0] += "__LONG_"; }
            else { file[lastLine][0] += "__TYPE_"; }
        }
        case float(): {
            int lastLine = size(file) - 1;
            if (cloneType == 1) { file[lastLine][0] += "__FLOAT_"; }
            else { file[lastLine][0] += "__TYPE_"; }
        }
        case double(): {
            int lastLine = size(file) - 1;
            if (cloneType == 1) { file[lastLine][0] += "__DOUBLE_"; }
            else { file[lastLine][0] += "__TYPE_"; }
        }
        case char(): {
            int lastLine = size(file) - 1;
            if (cloneType == 1) { file[lastLine][0] += "__CHAR_"; }
            else { file[lastLine][0] += "__TYPE_"; }
        }
        case string(): {
            int lastLine = size(file) - 1;
            if (cloneType == 1) { file[lastLine][0] += "__STRING_"; }
            else { file[lastLine][0] += "__TYPE_"; }
        }
        case byte(): {
            int lastLine = size(file) - 1;
            if (cloneType == 1) { file[lastLine][0] += "__BYTE_"; }
            else { file[lastLine][0] += "__TYPE_"; }
        }
        case \void(): {
            int lastLine = size(file) - 1;
            if (cloneType == 1) { file[lastLine][0] += "__VOID_"; }
            else { file[lastLine][0] += "__TYPE_"; }
        }
        case \boolean(): {
            int lastLine = size(file) - 1;
            if (cloneType == 1) { file[lastLine][0] += "__BOOLEAN_"; }
            else { file[lastLine][0] += "__TYPE_"; }
        }

        // Modifiers
        case \private(): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__PRIVATE_";
        }
        case \public(): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__PUBLIC_";
        }
        case \protected(): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__PROTECTED_";
        }
        case \friendly(): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__FRIENDLY_";
        }
        case \static(): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__STATIC_";
        }
        case \final(): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__FINAL_";
        }
        case \synchronized(): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__SYNCHRONIZED_";
        }
        case \transient(): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__TRANSIENT_";
        }
        case \abstract(): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__ABSTRACT_";
        }
        case \native(): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__NATIVE_";
        }
        case \volatile(): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__VOLATILE_";
        }
        case \strictfp(): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__STRICTFP_";
        }
        case \annotation(Expression \anno): {
            file = visitNode(\anno, file, cloneType);
        }
        case \onDemand(): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__ONDEMAND_";
        }
        case \default(): {
            int lastLine = size(file) - 1;
            file[lastLine][0] += "__DEFAULT_";
        }
    }
    return file;
}