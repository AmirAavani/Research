unit IndexDocumentsUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GenericCollectionUnit, PipelineUnit, Pipeline.TypesUnit;

function IndexDocuments(Task: TTask): Boolean;

implementation
uses
  ParameterManagerUnit, ALoggerUnit, SharedDataUnit, GenericCollection.UtilsUnit,
  Pipeline.Utils;

type
  TInt64List = specialize TCollection<Int64>;

function IndexDocuments(Task: TTask): Boolean;

  function GetDocumentStartingPositions(constref Data: AnsiString): TInt64List;
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
        FMTDebugLnEveryN(100, 'Index[%d]: %d', [Result.Count - 1, i], 2);
      end;

      Inc(CPtr);


    end;

    FMTDebugLn('Count: %d', [Result.Count]);
  end;

var
  InputDir, OutputDir, TmpDir: AnsiString;
  DocumentStartingPositions: TInt64List;
  Filename: AnsiString;
  OutputStream: TFileStream;
  Data: AnsiString;

begin
  FMTDebugLn('%d Task.ID: %d is Running', [ThreadID, Task.ID]);

  InputDir:= GetRunTimeParameterManager.ValueByName['--InputDir'].AsAnsiString;
  TmpDir:= GetRunTimeParameterManager.ValueByName['--TmpDir'].AsAnsiString;
  OutputDir:= GetRunTimeParameterManager.ValueByName['--OutputDir'].AsAnsiString;
  DebugLn(Format('%d Task.ID: %d InputDir = %s OutputDir = %s TmpDir = %s',
    [ThreadID, Task.ID, InputDir, OutputDir, TmpDir]));

  Data := WholeContent;
  FMTDebugLn('Len(Data): %d', [Length(Data)]);

  DocumentStartingPositions := GetDocumentStartingPositions(Data);

  Filename := ConcatPaths([TmpDir, 'wiki.train.tokens.sentence.index']);
  OutputStream := TFileStream.Create(Filename, fmCreate);
  GetDocumentStartingPositions(Data);
  DocumentStartingPositions.SaveToStream(OutputStream, @Int64ToBytes);
  OutputStream.Free;

  DocumentStartingPositions.Free;

  WriteLn(Format('%d Task.ID: %d is Done', [ThreadID, Task.ID]));
  Result := True;
end;


end.

