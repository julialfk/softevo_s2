module Main

import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;
import DateTime;
import Tree;
import List;
import Set;
import String;

int main(int testArgument=0) {
    loc projectLocation = |project://smallsql0.21_src|;
    list[loc] fileLocations = getFiles(projectLocation);
    datetime startTime = now();
    real blob = getASTduplication(getASTs(projectLocation), 1);
    datetime endTime = now();
    Duration i = endTime - startTime;
    println("getASTduplication: <blob>%");
    println("Time spent: <i.minutes>:<i.seconds>.<i.milliseconds> (mm:ss.SSS)");
    return testArgument;
}

list[Declaration] getASTs(loc projectLocation) {
    M3 model = createM3FromMavenProject(projectLocation);
    list[Declaration] asts = [createAstFromFile(f, true)
    | f <- files(model.containment), isCompilationUnit(f)];

    return asts;
}

public list[loc] getFiles(loc projectLocation) {
    M3 model = createM3FromMavenProject(projectLocation);
    list[loc] fileLocations = [f | f <- files(model.containment), isCompilationUnit(f)];
    return fileLocations;
}