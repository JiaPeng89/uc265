----------------
| Release Note |
----------------

Ucodec Inc. HEVC/H.265 Evaluation Encoder.
For Evaluation version, which has quite limited functionalities.

--------------------------------------------
| To encode an YUV420 input file input.yuv |
--------------------------------------------

To encode 100 frames using Constant QP (such as 22)
$ ./UC265AppEncoderUbuntu -i input.yuv -w 1920 -h 1080 -fps 60 -f 100 -speed 1 -q 22 -b output.bin
Equivalent x265 commond:
$ ./x265 --input input.yuv --input-res 1920x1080 --fps 60 -f 100 -p placebo --crf 22 --psnr --ssim --tune=psnr --keyint=-1 -o output.bin
or
$ ./x265 --input input.yuv --input-res 1920x1080 --fps 60 -f 100 -p placebo -q 22 --psnr --ssim --tune=psnr --keyint=-1 -o output.bin

------------------------------
| Evaluation Encoder Options |
------------------------------

  -i                    Input YUV file name
  -b                    Output Bitstream file name
  -w                    Width of input picture
  -h                    Height of input picture
  -fps                  Frame rate
  -f                    Number of frames to encode
  -speed                Coding speed (0: slowest; 15: fastest)
  -q                    QP value (Constant QP, CQP)

-------------------------------------------
| Q: Will this Evaluation Encoder expire? |
-------------------------------------------

A: Yes. It will expire by the end of 2019. We'll have newer version to replace.

-----------------------------------------------------------
| Q: What's the Linux version of this Evaluation Encoder? |
-----------------------------------------------------------

A: It's built on Ubuntu 18.04.1 LTS.
   It could have compatibility issue to run on other Linux OSes.

---------------------------------------------------
| Q: How to encode video with other input format? |
---------------------------------------------------

A: You must first convert the other format to YUV420 before calling this HEVC
   Evaluation Encoder.

----------------------------------------------------------------
| Q: How many I frames are there in the output HEVC bitstream? |
----------------------------------------------------------------

A: Only the first frame is I frame, and all other frames are B or P frames.
   We have non-evaluation Encoder which inserts periodic I frames.

------------------
| File Structure |
------------------

cqp_UC265_vs_crf_x265.sh                -- Example UC265 shell scripts (vs x265 CRF)
cqp_UC265.sh                            -- Example UC265 shell scripts (CQP)
cqp_x265.sh                             -- Example x265 shell scripts (CQP)
crf_x265.sh                             -- Example x265 shell scripts (CRF)
UC265-Test-Report.pdf                   -- Brief test report
UC265-vs-x265.xls                       -- Brief test result
UC265AppEncoderUbuntu                   -- Ucodec HEVC Evaluation Encoder (Ubuntu)
UC265AppEncoder.exe                     -- Ucodec HEVC Evaluation Encoder (Windows)
UcodecEvaluationSoftwareLicense.txt     -- Evaluation Software License Agreement
UcodecUC265EvaluationSoftwareReadMe.txt -- This file
UCYuvPsnr.c                             -- Functions of calculating psnr
