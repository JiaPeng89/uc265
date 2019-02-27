arraySpeed=(placebo veryslow slower slow medium fast faster veryfast superfast ultrafast)

arrayInput=(ClassA/NebutaFestival_2560x1600_60_8bit_crop.yuv ClassA/PeopleOnStreet_2560x1600_30_crop.yuv ClassA/SteamLocomotiveTrain_2560x1600_60_8bit_crop.yuv ClassA/Traffic_2560x1600_30_crop.yuv
            classB/BasketballDrive_1920x1080_50.yuv          classB/BQTerrace_1920x1080_60.yuv           classB/Cactus_1920x1080_50.yuv                         classB/Kimono1_1920x1080_24.yuv     classB/ParkScene_1920x1080_24.yuv
            classC/BasketballDrill_832x480_50.yuv            classC/BQMall_832x480_60.yuv                classC/PartyScene_832x480_50.yuv                       classC/RaceHorses_832x480_30.yuv
            classD/BasketballPass_416x240_50.yuv             classD/BQSquare_416x240_60.yuv              classD/BlowingBubbles_416x240_50.yuv                   classD/RaceHorses_416x240_30.yuv
            classE/vidyo1_1280x720_60.yuv                    classE/vidyo3_1280x720_60.yuv               classE/vidyo4_1280x720_60.yuv)

arrayRes=(2560x1600 2560x1600 2560x1600 2560x1600
          1920x1080 1920x1080 1920x1080 1920x1080 1920x1080
           832x480   832x480   832x480   832x480
           416x240   416x240   416x240   416x240
          1280x720  1280x720  1280x720)

arrayFps=(60 30 60 30
          50 60 50 24 24
          50 60 50 30
          50 60 50 30
          60 60 60)

arrayNumFrame=(300 150 300 150
               500 600 500 240 240
               500 600 500 300
               500 600 500 300
               600 600 600)

arrayqp=(25 30 35 40)

arrayq=(25 30 35 40)

rcSet=CQP
vender=x265_linux
workDir=~/work
testDir=$workDir/testHEVC
inputDir=~/testseq/Downloads/
binDir=$testDir/bin/$rcSet/$vender
#EXE=$testDir/x265_v3.0
EXE=x265

#for ((iSpeed=0; iSpeed < ${#arraySpeed[*]}; iSpeed ++))
for ((iSpeed=7; iSpeed < 9; iSpeed ++))
do
  speed=${arraySpeed[$iSpeed]}
  speedDir=$binDir/speed_$speed
  mkdir -p $speedDir
  rm $speedDir/classB/*.bin
  rm $speedDir/classC/*.bin
  rm $speedDir/classD/*.bin
  rm $speedDir/classE/*.bin

  for ((jInput=0; jInput < ${#arrayInput[*]}; jInput ++))
  do
    for kQp in 0 1 2 3
    	do
	if [ $jInput -eq 10 -o $jInput -eq 14 -o $jInput -eq 17 ]
	then
      		$EXE --input $inputDir/${arrayInput[$jInput]} --input-res ${arrayRes[$jInput]} --fps ${arrayFps[$jInput]} -f ${arrayNumFrame[$jInput]} -p $speed --qp ${arrayqp[$kQp]} --psnr --ssim --tune=psnr --keyint=-1 -o $speedDir/${arrayInput[$jInput]}_set$kQp.bin
	fi
   	done
	
  done
done
