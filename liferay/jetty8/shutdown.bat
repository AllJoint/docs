@echo off
chcp 1251
set JAVA_HOME=C:\Java\jdk1.8.0_40
set PATH=%JAVA_HOME%\bin;%PATH%
java -DSTOP.PORT=7171 -DSTOP.KEY=923hgkjdhf7833 -Xmx32m -jar start.jar --stop
