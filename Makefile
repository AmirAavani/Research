Debug?=0
strmat:

Release:
	fpc -Sd -O3 NGrams/NGrams.lpr -FU/tmp/lib/  -Fu my-units/ -Fumy-utils/General-Purpose-Units -Fu../../../Unicode-Functions -Fu../../../ALogger -Fu../../../Threading -Fu../../../PB2PAS -Fu../../../Algortihmic-Unit

Step0:
	./NGrams/NGrams --InputDir /home/khabardar/Projects/NGrams/NGrams/Data/WikiText-103 --TmpDir /tmp/ngrams --Debug $(Debug)   --OutputDir /tmp/ngrams/output --Pipeline.StepID 0

Step1:
	./NGrams/NGrams --InputDir /home/khabardar/Projects/NGrams/NGrams/Data/WikiText-103 --TmpDir /tmp/ngrams --Debug $(Debug)   --OutputDir /tmp/ngrams/output --Pipeline.StepID 1

Step2:
	./NGrams/NGrams --InputDir /home/khabardar/Projects/NGrams/NGrams/Data/WikiText-103 --TmpDir /tmp/ngrams --Debug $(Debug)   --OutputDir /tmp/ngrams/output --Pipeline.StepID 2
