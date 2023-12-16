module Read

import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;
import List;
import String;


list[Declaration] getASTs(loc projectLocation) {
    M3 model = createM3FromMavenProject(projectLocation);
    list[Declaration] asts = [createAstFromFile(f, true)
    | f <- files(model.containment), isCompilationUnit(f)];

    return asts;
}

list[loc] getFiles(loc projectLocation) {
    M3 model = createM3FromMavenProject(projectLocation);
    list[loc] fileLocations = [f | f <- files(model.containment), isCompilationUnit(f)];
    return fileLocations;
}

// Count total number of lines in a file.
public int countLinesFile(loc projectLocation){
    list[loc] fileLocations = getFiles(projectLocation);
    int lines = 0;
    for(loc fileLocation <- fileLocations) {
        list[str] file = readFileLines(fileLocation);
        file = deleteComments(file);
        lines += size(file);
    }

    return lines;
}

// Delete the start and end of multiline comments from a line.
tuple[bool, str] deleteMultiComments(bool inComment, str s) {
    int endLine = size(s);
    str newString = s;
    int indexStartComment = findFirst(s, "/*");
    int indexEndComment = findFirst(s, "*/");

    // Catches lines like: "comment */", "comment */ code /* comment */"
    if ((indexEndComment < indexStartComment || indexStartComment == -1)
            && indexEndComment != -1) {
        inComment = false;
        newString = newString[indexEndComment + 2..endLine];
    }

    // Catches lines like: "/* comment", "/* comment */ code /* comment"
    while (indexStartComment != -1) {
        // Catches: "code /* comment"
        if (indexEndComment == -1) {
            inComment = true;
            newString = newString[0..indexStartComment];
        }
        // Catches: "code /* comment */ code"
        else {
            inComment = false;
            newString = newString[0..indexStartComment]
                        + newString[indexEndComment + 2..endLine];
        }
        indexStartComment = findFirst(newString, "/*");
    }

    return <inComment, newString>;
}

// Delete an inline comment from a line.
str deleteInlineComment(str s) {
    int indexStartComment = findFirst(s, "//");

    if (indexStartComment != -1) {
        return s[0..indexStartComment];
    }

    return s;
}

// Delete all comments from a file.
list[str] deleteComments(list[str] file) {
    // Filter all single line comments without code before the comment and empty lines.
    // i.e. "// comment" gets filtered out, but "code // comment" is kept.
    file = [s | str s <- file, /^\s*\/\/.*/ !:= s, /^\s*$/ !:= s];
    int lastArray = size(file) - 1;
    list[str] newFile = [];
    bool inComment = false;

    for (s <- file){
        s = deleteInlineComment(s);

        bool hasCommentStart = contains(s, "/*");
        bool hasCommentEnd = contains(s, "*/");
        // Do not include the line if it is in the middle of a multiline comment.
        if (inComment && !hasCommentEnd) { continue; }

        if (hasCommentEnd || hasCommentStart) {
            <inComment, s> = deleteMultiComments(inComment, s);
        }

        // Do not include line if it is empty.
        if (/^\s*$/ !:= s) { newFile += trim(s); }
    }
    return newFile;
}
