arraySpeed=(placebo veryslow slower slow medium fast faster veryfast superfast ultrafast)

arrayInput=(NebutaFestival_2560x1600_60_8bit_crop.yuv PeopleOnStreet_2560x1600_30_crop.yuv SteamLocomotiveTrain_2560x1600_60_8bit_crop.yuv Traffic_2560x1600_30_crop.yuv
            BasketballDrive_1920x1080_50.yuv          BQTerrace_1920x1080_60.yuv           Cactus_1920x1080_50.yuv                         Kimono1_1920x1080_24.yuv      ParkScene_1920x1080_24.yuv
            BasketballDrill_832x480_50.yuv            BQMall_832x480_60.yuv                PartyScene_832x480_50.yuv                       RaceHorses_832x480_30.yuv
            BasketballPass_416x240_50.yuv             BQSquare_416x240_60.yuv              BlowingBubbles_416x240_50.yuv                   RaceHorses_416x240_30.yuv
            vidyo1_1280x720_60.yuv                    vidyo3_1280x720_60.yuv               vidyo4_1280x720_60.yuv)

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

arrayQP=(25 30 35 40)

rcSet=CQP
vender=x265_linux
workDir=~/work
testDir=$workDir/test/testHEVC
inputDir=$workDir/VideoSequence/HEVC
binDir=$testDir/JCTVC/bin/$rcSet/$vender
EXE=$testDir/x265_v3.0

#for ((iSpeed=0; iSpeed < ${#arraySpeed[*]}; iSpeed ++))
for ((iSpeed=0; iSpeed < 1; iSpeed ++))
do
  speed=${arraySpeed[$iSpeed]}
  speedDir=$binDir/speed_$speed
  mkdir -p $speedDir
  rm $speedDir/*.bin

  for ((jInput=0; jInput < ${#arrayInput[*]}; jInput ++))
  do
    for kQp in 0 1 2 3
    do
      $EXE --input $inputDir/${arrayInput[$jInput]} --input-res ${arrayRes[$jInput]} --fps ${arrayFps[$jInput]} -f ${arrayNumFrame[$jInput]} -p $speed -q ${arrayQP[kQp]} --psnr --ssim --tune=psnr --keyint=-1 -o $speedDir/${arrayInput[$jInput]}_set$kQp.bin
    done
  done
done
