module Main

import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;
import Read;
import Tree;


int main(int massThreshold, real simThreshold=0.0) {
    // loc projectLocation = |project://smallsql0.21_src|;
    loc projectLocation = |project://hsqldb-2.3.1|;
    real resultPercentage = getASTduplication(getASTs(projectLocation),
                                    1, massThreshold, simThreshold, projectLocation);
    println("Clone lines over total lines: <resultPercentage>%");
    return 0;
}

int benchmark(int massThreshold, int cloneType) {
    loc projectLocation = |project://softevo_s2/benchmark/javaproject|;
    real resultPercentage = getASTduplication(getASTs(projectLocation),
                                    cloneType, massThreshold, 0.0, projectLocation);
    println("Clone lines over total lines: <resultPercentage>%");
    return 0;
}