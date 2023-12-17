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
