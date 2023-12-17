module Main

import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;
import DateTime;
import Read;
import Tree;


int main(int massThreshold, real simThreshold=0.0) {
    loc projectLocation = |project://smallsql0.21_src|;
    // loc projectLocation = |project://hsqldb-2.3.1|;
    datetime startTime = now();
    real blob = getASTduplication(getASTs(projectLocation),
                                    1, massThreshold, simThreshold, projectLocation);
    datetime endTime = now();
    Duration i = endTime - startTime;
    println("Clone lines over total lines: <blob>%");
    println("Time spent: <i.minutes>:<i.seconds>.<i.milliseconds> (mm:ss.SSS)");
    return 0;
}

int benchmark(int massThreshold, int cloneType) {
    loc projectLocation = |project://softevo_s2/test/javaproject|;
    datetime startTime = now();
    real blob = getASTduplication(getASTs(projectLocation),
                                    cloneType, massThreshold, 0.0, projectLocation);
    datetime endTime = now();
    Duration i = endTime - startTime;
    println("Clone lines over total lines: <blob>%");
    println("Time spent: <i.minutes>:<i.seconds>.<i.milliseconds> (mm:ss.SSS)");
    return 0;
}