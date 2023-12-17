module Main

import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;
import Read;
import Tree;


int main(int massThreshold, real simThreshold=0.0) {
    loc projectLocation = |project://smallsql0.21_src|;
    // loc projectLocation = |project://hsqldb-2.3.1|;
    return getASTduplication(getASTs(projectLocation), 
                                                1, 
                                                massThreshold, 
                                                simThreshold, 
                                                projectLocation);
}

int benchmark(int massThreshold, int cloneType) {
    loc projectLocation = |project://softevo_s2/benchmark/javaproject|;
    return getASTduplication(getASTs(projectLocation), 
                                                cloneType, 
                                                massThreshold, 
                                                simThreshold, 
                                                projectLocation);
}