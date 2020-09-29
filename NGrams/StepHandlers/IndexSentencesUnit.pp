unit IndexSentencesUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, PipelineUnit;

function IndexSentences(Task: TTask; Args: array of Pointer): Boolean;

implementation
uses
  StreamUnit, ParameterManagerUnit, QueueUnit, FileHelperUnit;

function IndexSentences(Task: TTask; Args: array of Pointer): Boolean;
var
  Stream: TMyTextStream;
  Filename, Dir: AnsiString;
  Data: AnsiString;
  p: Integer;
  DocumentStartingPositions: TIntList;

begin
  Dir:= PString(Args[2])^;

  Filename := ConcatPaths([Dir, 'wiki.train.tokens']);
  begin
    Stream := TMyTextStream.Create(TFileStream.Create(
      GetRunTimeParameterManager.ValueByName['--InputDir'].AsAnsiString + '/' + Filename, fmOpenRead),
      True
    );
    Data := Stream.ReadAll;
    p := Pos(sLineBreak +' =

    Stream.Free;
  end;
end;

end.

