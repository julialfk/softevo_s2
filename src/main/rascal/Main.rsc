module Main

import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;
import DateTime;
import Read;
import Tree;


int main(int cloneType, int massThreshold, bool secondAlg, real simThreshold=0.0) {
    loc projectLocation = |project://smallsql0.21_src|;
    // loc projectLocation = |project://hsqldb-2.3.1|;
    datetime startTime = now();
    real blob = getASTduplication(getASTs(projectLocation), countLinesFile(projectLocation),
                                    cloneType, massThreshold, simThreshold, projectLocation, secondAlg);
    datetime endTime = now();
    Duration i = endTime - startTime;
    println("Clone lines over total lines: <blob>%");
    println("Time spent: <i.minutes>:<i.seconds>.<i.milliseconds> (mm:ss.SSS)");
    return 0;
}
