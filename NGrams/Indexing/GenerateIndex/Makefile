MyUnitPath=../../../my-units

GenerateIndex-Release:
	mkdir -p /tmp/GenerateIndex-Release
	fpc -Sd GenerateIndex.lpr -O3 -g -Fu../../../my-units/Pipeline -Fu../../../my-units/General-Purpose-Units -Fu../../../my-units/Unicode-Functions -Fu../../../my-units/ALogger -Fu../../../my-units/Threading -Fu../../../my-units/PB2PAS -Fu../../../my-units/Algorithmic-Units -FuStepHandlers -FU/tmp/GenerateIndex-Release


GenerateIndex-MemLeak:
	mkdir -p /tmp/GenerateIndex-MemLeak
	fpc -Sd GenerateIndex.lpr -g -gh -gl -Fu../../../my-units/Pipeline -Fu../../../my-units/General-Purpose-Units -Fu../../../my-units/Unicode-Functions -Fu../../../my-units/ALogger -Fu../../../my-units/Threading -Fu../../../my-units/PB2PAS -Fu../../../my-units/Algorithmic-Units -FuStepHandlers -FU/tmp/GenerateIndex-MemLeak -oGenerateIndex-MemLeak

GenerateIndex-Profiling:
	mkdir -p /tmp/GenerateIndex-Profiling
	fpc -Sd GenerateIndex.lpr -O3 -gv -Fu../../../my-units/Pipeline -Fu../../../my-units/General-Purpose-Units -Fu../../../my-units/Unicode-Functions -Fu../../../my-units/ALogger -Fu../../../my-units/Threading -Fu../../../my-units/PB2PAS -Fu../../../my-units/Algorithmic-Units -FuStepHandlers -FU/tmp/GenerateIndex-Profiling
	 valgrind --tool=callgrind ./GenerateIndex-Profiling 



