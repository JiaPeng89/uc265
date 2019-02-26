// Copyright (C) 2015-2019 Ucodec Inc. All rights reserved.

#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#if defined(_MSC_VER)
#define fseeko _fseeki64
#define ftello _ftelli64
#endif

typedef char UCchar;
typedef int8_t UCs8;
typedef uint8_t UCu8;
typedef int16_t UCs16;
typedef uint16_t UCu16;
typedef int32_t UCs32;
typedef uint32_t UCu32;
typedef int64_t UCs64;
typedef uint64_t UCu64;
typedef double UCdouble;
typedef float UCfloat;
typedef UCu8 UCpel;

static UCu64 getFileSize(FILE *const file) {
  UCu64 sizeFile;
  fseeko(file, 0, SEEK_END);
  sizeFile = ftello(file);
  fseeko(file, 0, SEEK_SET);
  return sizeFile;
}

static const UCdouble UC_MAX_DB = 99.99;

static UCu64 calcSsd(const UCu8 *const org, const UCu8 *const rec,
                     const UCu64 size) {
  UCu64 ssd = 0;
  for (UCu32 i = 0; i < size; i++) {
    const UCs16 diff = (UCs16)(org[i] - rec[i]);
    ssd += (UCu32)(diff * diff);
  }
  return ssd;
}

int main(int argc, char **argv) {
  UCu32 i;
  UCu32 widthY, widthC, heightY, heightC, numFrame, fps, idxFirstDiffFrame;
  FILE *fileOrg, *fileDec, *fileSum, *fileBin;
  UCu64 sizeFileOrg, sizeFileDec, sizeFileBin, sizeFile;
  size_t sizeFrameY, sizeFrameC, sizeFrameYUV;
  UCu8 *buffer, *yA, *uA, *vA, *yB, *uB, *vB, *ssimBuf;
  UCu64 refValueY, refValueC, ssdY, ssdU, ssdV;
  UCdouble psnrY, psnrU, psnrV, psnrYTotal, psnrUTotal, psnrVTotal, psnr;
  UCdouble rate;

  psnrYTotal = psnrUTotal = psnrVTotal = 0.0;

  if ((argc < 6) || (7 == argc)) {
    printf("\nUSAGE: UCYuvPsnrSsim original-yuv-file decoded-yuv-file "
           "summary-file width height [binary-file] [fps]\n");
    return -1;
  }

  if (!(fileOrg = fopen(argv[1], "rb"))) {
    printf("\nERROR: Cannot open input YUV file A \"%s\".\n", argv[1]);
    return -1;
  }
  if (!(fileDec = fopen(argv[2], "rb"))) {
    printf("\nERROR: Cannot open input YUV file B \"%s\".\n", argv[2]);
    return -1;
  }

  if (argc >= 8) {
    if (!(fileBin = fopen(argv[6], "rb"))) {
      printf("\nERROR: Cannot open input binary file \"%s\".\n", argv[6]);
      return -1;
    }
    sizeFileBin = getFileSize(fileBin);
    fps = atoi(argv[7]);
  } else {
    sizeFileBin = 0;
    fps = 1;
  }

  fileSum = fopen(argv[3], "a");
  widthY = atoi(argv[4]);
  heightY = atoi(argv[5]);
  widthC = widthY >> 1;
  heightC = heightY >> 1;

  sizeFrameY = widthY * heightY;
  sizeFrameC = sizeFrameY >> 2;
  sizeFrameYUV = sizeFrameY + 2 * sizeFrameC;
  refValueY = 255 * 255 * (UCu64)sizeFrameY;
  refValueC = refValueY / 4;

  buffer = (UCu8 *)malloc(5 * sizeFrameYUV);
  yA = buffer;
  uA = yA + sizeFrameY;
  vA = uA + sizeFrameC;
  yB = vA + sizeFrameC;
  uB = yB + sizeFrameY;
  vB = uB + sizeFrameC;
  ssimBuf = vB + sizeFrameC;

  sizeFileOrg = getFileSize(fileOrg);
  sizeFileDec = getFileSize(fileDec);

  if (sizeFileOrg != sizeFileDec) {
    printf("\nATTENTION: sizeFileOrg != sizeFileDec.\n");
  }
  sizeFile = (sizeFileOrg < sizeFileDec) ? sizeFileOrg : sizeFileDec;
  numFrame = (UCu32)(sizeFile / sizeFrameYUV);
  rate = (UCu64)8 * sizeFileBin * fps / (1000.0 * numFrame);

  idxFirstDiffFrame = numFrame;
  for (i = 0; i < numFrame; i++) {
    fread(yA, 1, sizeFrameYUV, fileOrg);
    fread(yB, 1, sizeFrameYUV, fileDec);

    // Calc PSNR
    ssdY = calcSsd(yA, yB, sizeFrameY);
    ssdU = calcSsd(uA, uB, sizeFrameC);
    ssdV = calcSsd(vA, vB, sizeFrameC);

    psnrY = ssdY ? (10.0 * log10((UCdouble)refValueY / ssdY)) : UC_MAX_DB;
    psnrU = ssdU ? (10.0 * log10((UCdouble)refValueC / ssdU)) : UC_MAX_DB;
    psnrV = ssdV ? (10.0 * log10((UCdouble)refValueC / ssdV)) : UC_MAX_DB;
    psnrY = (psnrY <= UC_MAX_DB) ? psnrY : UC_MAX_DB;
    psnrU = (psnrU <= UC_MAX_DB) ? psnrU : UC_MAX_DB;
    psnrV = (psnrV <= UC_MAX_DB) ? psnrV : UC_MAX_DB;
    psnrYTotal += psnrY;
    psnrUTotal += psnrU;
    psnrVTotal += psnrV;
  }

  psnrY = psnrYTotal / numFrame;
  psnrU = psnrUTotal / numFrame;
  psnrV = psnrVTotal / numFrame;
  psnr = (6 * psnrY + psnrU + psnrV) / 8;

  printf("%110s vs %40s %4d | %13f\t%9f\t%9f\t%9f\t%9f\n", argv[1], argv[2],
         numFrame, rate, psnr, psnrY, psnrU, psnrV);
  fprintf(fileSum, "%110s vs %40s %4d | %13f\t%9f\t%9f\t%9f\t%9f\n", argv[1],
          argv[2], numFrame, rate, psnr, psnrY, psnrU, psnrV);

  free(buffer);
  fclose(fileOrg);
  fclose(fileDec);
  fclose(fileSum);

  return 0;
}
