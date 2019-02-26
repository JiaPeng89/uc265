arrayInput=(NebutaFestival_2560x1600_60_8bit_crop.yuv PeopleOnStreet_2560x1600_30_crop.yuv SteamLocomotiveTrain_2560x1600_60_8bit_crop.yuv Traffic_2560x1600_30_crop.yuv
            BasketballDrive_1920x1080_50.yuv          BQTerrace_1920x1080_60.yuv           Cactus_1920x1080_50.yuv                         Kimono1_1920x1080_24.yuv      ParkScene_1920x1080_24.yuv
            BasketballDrill_832x480_50.yuv            BQMall_832x480_60.yuv                PartyScene_832x480_50.yuv                       RaceHorses_832x480_30.yuv
            BasketballPass_416x240_50.yuv             BQSquare_416x240_60.yuv              BlowingBubbles_416x240_50.yuv                   RaceHorses_416x240_30.yuv
            vidyo1_1280x720_60.yuv                    vidyo3_1280x720_60.yuv               vidyo4_1280x720_60.yuv)

arrayWidth=(2560 2560 2560 2560
            1920 1920 1920 1920 1920
             832  832  832  832
             416  416  416  416
            1280 1280 1280)

arrayHeight=(1600 1600 1600 1600
             1080 1080 1080 1080 1080
              480  480  480  480
              240  240  240  240
              720  720  720)

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

arrayLevel=(5   5   5   5
            4.1 4.1 4.1 4 4
            3.1 3.1 3.1 3
            2.1 2.1 2.1 2
            4   4   4)

declare -A arrayQP

arrayQP[0,0]=21
arrayQP[0,1]=24
arrayQP[0,2]=29
arrayQP[0,3]=38
arrayQP[1,0]=21
arrayQP[1,1]=25
arrayQP[1,2]=30
arrayQP[1,3]=34
arrayQP[2,0]=21
arrayQP[2,1]=26
arrayQP[2,2]=31
arrayQP[2,3]=36
arrayQP[3,0]=21
arrayQP[3,1]=26
arrayQP[3,2]=31
arrayQP[3,3]=36
arrayQP[4,0]=21
arrayQP[4,1]=25
arrayQP[4,2]=30
arrayQP[4,3]=34
arrayQP[5,0]=21
arrayQP[5,1]=26
arrayQP[5,2]=31
arrayQP[5,3]=36
arrayQP[6,0]=22
arrayQP[6,1]=26
arrayQP[6,2]=30
arrayQP[6,3]=35
arrayQP[7,0]=21
arrayQP[7,1]=25
arrayQP[7,2]=30
arrayQP[7,3]=35
arrayQP[8,0]=21
arrayQP[8,1]=26
arrayQP[8,2]=31
arrayQP[8,3]=36
arrayQP[9,0]=20
arrayQP[9,1]=25
arrayQP[9,2]=29
arrayQP[9,3]=34
arrayQP[10,0]=21
arrayQP[10,1]=25
arrayQP[10,2]=30
arrayQP[10,3]=35
arrayQP[11,0]=21
arrayQP[11,1]=25
arrayQP[11,2]=30
arrayQP[11,3]=35
arrayQP[12,0]=20
arrayQP[12,1]=25
arrayQP[12,2]=30
arrayQP[12,3]=35
arrayQP[13,0]=20
arrayQP[13,1]=25
arrayQP[13,2]=29
arrayQP[13,3]=34
arrayQP[14,0]=20
arrayQP[14,1]=25
arrayQP[14,2]=30
arrayQP[14,3]=36
arrayQP[15,0]=21
arrayQP[15,1]=25
arrayQP[15,2]=30
arrayQP[15,3]=35
arrayQP[16,0]=21
arrayQP[16,1]=25
arrayQP[16,2]=30
arrayQP[16,3]=35
arrayQP[17,0]=21
arrayQP[17,1]=26
arrayQP[17,2]=30
arrayQP[17,3]=35
arrayQP[18,0]=21
arrayQP[18,1]=26
arrayQP[18,2]=30
arrayQP[18,3]=35
arrayQP[19,0]=21
arrayQP[19,1]=26
arrayQP[19,2]=30
arrayQP[19,3]=35

rcSet=CQP
vender=UC265_linux
workDir=~/work
testDir=$workDir/test/testHEVC
inputDir=$workDir/VideoSequence/HEVC
binDir=$testDir/JCTVC/bin/$rcSet/$vender
EXE=$workDir/UC265/bin/Linux/UC265AppEncoder

for ((iSpeed = 1; iSpeed <= 1; iSpeed ++))
do
  speed=$iSpeed
  speedDir=$binDir/speed_$speed
  mkdir -p $speedDir
  rm $speedDir/*.bin

  for ((jInput = 0; jInput < ${#arrayInput[*]}; jInput ++))
  do
    for kQp in 0 1 2 3
    do
      $EXE -i $inputDir/${arrayInput[$jInput]} -w ${arrayWidth[$jInput]} -h ${arrayHeight[$jInput]} -fps ${arrayFps[$jInput]} -f ${arrayNumFrame[$jInput]} --Level=${arrayLevel[$jInput]} -speed $speed -q ${arrayQP[$jInput,$kQp]} -b $speedDir/${arrayInput[$jInput]}_set$kQp.bin
    done
  done
done
