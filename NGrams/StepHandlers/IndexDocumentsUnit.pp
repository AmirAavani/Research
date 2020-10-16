unit IndexDocumentsUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, PipelineUnit;

function IndexDocuments(Task: TTask): Boolean;

implementation
uses
  StreamUnit, ParameterManagerUnit, QueueUnit, FileHelperUnit, ALoggerUnit,
  Pipeline.Utils;

function IndexDocuments(Task: TTask): Boolean;
var
  Data: AnsiString;

  function GetDocumentStartingPositions: TInt64List;
  var
    CPtr: PChar;
    i: Integer;

  begin
    Result := TInt64List.Create;
    CPtr := PChar(Data);

    for i := 1 to Length(Data) - 2 do
    begin
      if (CPtr^ = #10) and ((CPtr+1)^ = #$20) and ((CPtr+2)^ = #$3d)
        and ((CPtr+3)^ = #$20) and ((CPtr+4)^ <> #$3d) then
      begin
        Result.Add(i);
        DebugLnEveryN(100, Format('Index[%d]: %d', [Result.Count - 1, i]), 2);
      end;

      Inc(CPtr);

    end;

    DebugLn(Format('Count: %d', [Result.Count]));
  end;

var
  Stream: TMyTextStream;
  Filename, InputDir, OutputDir: AnsiString;
  DocumentStartingPositions: TInt64List;

begin
  InputDir:= GetRunTimeParameterManager.ValueByName['--InputDir'].AsAnsiString;
  OutputDir:= GetRunTimeParameterManager.ValueByName['--OutputDir'].AsAnsiString;
  DebugLn(Format('%d Task.ID: %d InputDir = %s OutputDir = %s',
    [ThreadID, Task.ID, InputDir, OutputDir]));

  Filename := ConcatPaths([InputDir, 'wiki.train.tokens']);
  begin
    DebugLn(Format('%d Filename: %s', [ThreadID, Filename]));
    Stream := TMyTextStream.Create(TFileStream.Create(
      Filename, fmOpenRead),
      True
    );
    DebugLn(Format('+Filename: %s', [Filename]));
    Data := Stream.ReadAll;
    Stream.Free;
    DebugLn(Format('Len(Data): %d', [Length(Data)]));

    DocumentStartingPositions := GetDocumentStartingPositions;

    Filename := ConcatPaths([OutputDir, 'wiki.train.tokens.sentence.index']);
    DocumentStartingPositions.SaveToFile(Filename);

    DocumentStartingPositions.Free;
  end;

  DebugLn(Format('%d Task.ID: %d is Done', [ThreadID, Task.ID]));
  Result := True;
end;

end.

