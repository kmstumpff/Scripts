@echo off

reg add "HKCU\Software\Seapine Software\Surround SCM\SCM Client" /v ContextMenuDefaultItems_File /d "3;5;4;26;6;12;0;10;25;11;22;28;29;31;0;13;14;15;16;24;21;0;17;0;18;19;0;7;9;8;" /f