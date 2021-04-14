program NGrams;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, sysutils, ParameterManagerUnit, StreamUnit, ALoggerUnit,
  ProtoHelperUnit, SharedDataUnit,  BaseMapperUnit,
  DataLineUnit, SourceUnit, MapperOptionUnit
  { you can add units after this };

var
  Filename, InputDir: AnsiString;
  dl: TDataLine;


begin
  InputDir:= GetRunTimeParameterManager.ValueByName['--InputDir'].AsAnsiString;
  Filename := ConcatPaths([InputDir, 'wiki.train.tokens']);
  FMTDebugLn('%d Filename: %s', [ThreadID, Filename]);

  dl := TDataLine.
    Create(TBaseSource.Create).
    Map('ReadDocs', TBaseMapper.Create, DefaultMappingOptions).
    Map('TokenizeDoc', TBaseMapper.Create, DefaultMappingOptions).
    Map('Count', TBaseMapper.Create, DefaultMappingOptions);
  dl.Report;

  DebugLn('Done');

end.

