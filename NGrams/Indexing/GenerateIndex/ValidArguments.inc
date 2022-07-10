ValidArgumentsInfo: array of AnsiString =
  ('--InputPattern:AnsiString',
   '--TmpDir:AnsiString',
   '--OutputDir:AnsiString',
	 '--RunHashTokenPipeline:Boolean',
  '--Debug:Integer', '--Pipeline.FromStepID:Integer', '--Pipeline.StepID:Integer');
ValidArgumentsValues: array of AnsiString =
  ('/home/khabardar/Projects/NLP-Dataset/1BWLM/scripts/training-monolingual.tokenized.shuffled/news.en@100',
   '/tmp/1BWLM',
   '/home/khabardar/Projects/NLP-Dataset/1BWLM/Output/',
	 'True',
   '-1', '1', '-1');
