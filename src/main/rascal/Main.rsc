module Main

import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;
import Read;
import Tree;



int main(int cloneType, int massThreshold, bool secondAlg, real simThreshold=0.0) {
    // loc projectLocation = |project://smallsql0.21_src|;
    loc projectLocation = |project://hsqldb-2.3.1|;
    return getASTduplication(getASTs(projectLocation), cloneType,
                                    massThreshold, simThreshold, projectLocation,
                                    secondAlg);
}

int benchmark(int cloneType, int massThreshold, bool secondAlg) {
    loc projectLocation = |project://lab2/benchmark/javaproject|;
    return getASTduplication(getASTs(projectLocation), cloneType,
                                    massThreshold, 0.0, projectLocation,
                                    secondAlg);
}
