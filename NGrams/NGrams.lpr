program NGrams;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, sysutils, ParameterManagerUnit, StreamUnit,
  ALoggerUnit, ProtoHelperUnit,
  SharedDataUnit, GenericCollection.UtilsUnit, DataLineUnit, SourceUnit,
MapperOptionUnit
  { you can add units after this };

var
  Filename, InputDir: AnsiString;

begin
  InputDir:= GetRunTimeParameterManager.ValueByName['--InputDir'].AsAnsiString;
  Filename := ConcatPaths([InputDir, 'wiki.train.tokens']);
  FMTDebugLn('%d Filename: %s', [ThreadID, Filename]);

  DebugLn('Done');

end.

