unit IndexSentencesUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, PipelineUnit;

function IndexSentences(Task: TTask): Boolean;

implementation
uses
  StreamUnit, ParameterManagerUnit, QueueUnit, FileHelperUnit, ALoggerUnit,
  Generics.Collections;

type
  TIntList = specialize TList<Int64>;

function IndexSentences(Task: TTask): Boolean;
var
  Stream: TMyTextStream;
  Filename, Dir: AnsiString;
  Data: AnsiString;
  p: Integer;
  Lines: TStringList;
  DocumentStartingPositions: TIntList;

begin
  Dir:= GetRunTimeParameterManager.ValueByName['--InputDir'].AsAnsiString;
  DebugLn(Format('%d Task.ID: %d Dir = %s', [ThreadID, Task.ID, Dir]));

  Filename := ConcatPaths([Dir, 'wiki.train.tokens']);
  begin
    DebugLn(Format('%d Filename: %s', [ThreadID, Filename]));
    Stream := TMyTextStream.Create(TFileStream.Create(
      Filename, fmOpenRead),
      True
    );
    DebugLn(Format('+Filename: %s', [Filename]));
    Data := Stream.ReadAll;

    Lines := TStringList.Create;
    Lines.Delimiter := sLineBreak;
    Lines.Text := Data;

    DebugLn(Format('Len(Data): %d Lines.Count: %d', [Length(Data), Lines.Count]));
    DebugLn(Lines[0]);
    DebugLn(Lines[1]);
    DebugLn(Lines[Lines.Count - 1]);

    Stream.Free;
  end;

  DebugLn(Format('%d Task.ID: %d is Done', [ThreadID, Task.ID, Dir]));
  Result := True;
end;

end.

