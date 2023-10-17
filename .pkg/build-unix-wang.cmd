@echo off

SET R_HOME=D:\Program Files\BioNovoGene\mzkit_win32\Rstudio\bin
SET Rscript="%R_HOME%/Rscript.exe"
SET REnv="%R_HOME%/R#.exe"

%Rscript% --build /src ../ /save ./workflow.zip --skip-src-build
%REnv% --install.packages ./workflow.zip

pause