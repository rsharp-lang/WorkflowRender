@echo off

REM git remote add local http://git.biodeep.cn/xieguigang/WorkflowRender.git
REM git remote add gitlink https://gitlink.org.cn/xieguigang/WorkflowRender.git

git pull gitlink HEAD
git pull local HEAD

git push local HEAD
git push gitlink HEAD