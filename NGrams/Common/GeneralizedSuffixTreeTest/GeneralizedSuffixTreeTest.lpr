program GeneralizedSuffixTreeTest;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, GeneralizedSuffixTreeUnit, CollectionUnit, DocUnit
  { you can add units after this };

var
  Tree: TGeneralizedSuffixTree;

begin

  Tree := TGeneralizedSuffixTree.Create;

  Tree.AddDoc(TStringDoc.Create('Mississipi'));
  Tree.AddDoc(TStringDoc.Create('AMiR'));
  Tree.AddDoc(TStringDoc.Create('R'));
  Tree.AddDoc(TStringDoc.Create('R'));

  Tree.PrintAllTransitions;
  Tree.PrintAll;
  Tree.Free;

end.

