#ifndef ZSTD_DECODESEQUENCE_H
#define ZSTD_DECODESEQUENCE_H

#include <string.h>      /* memcpy, memmove, memset */
#include "mem.h"         /* low level memory routines */
#define FSE_STATIC_LINKING_ONLY
#include "fse.h"
#define HUF_STATIC_LINKING_ONLY
#include "huf.h"
#include "zstd_internal.h"

#if defined(ZSTD_LEGACY_SUPPORT) && (ZSTD_LEGACY_SUPPORT>=1)
#  include "zstd_legacy.h"
#endif

typedef struct {
    size_t litLength;
    size_t matchLength;
    size_t offset;
    const BYTE* match;
} seq_t;

typedef struct {
    BIT_DStream_t DStream;
    FSE_DState_t stateLL;
    FSE_DState_t stateOffb;
    FSE_DState_t stateML;
    size_t prevOffset[ZSTD_REP_NUM];
    const BYTE* base;
    size_t pos;
    uPtrDiff gotoDict;
} seqState_t;

typedef enum { ZSTD_lo_isRegularOffset, ZSTD_lo_isLongOffset=1 } ZSTD_longOffset_e;

#define LONG_OFFSETS_MAX_EXTRA_BITS_32                                         \
    (ZSTD_WINDOWLOG_MAX_32 > STREAM_ACCUMULATOR_MIN_32                         \
        ? ZSTD_WINDOWLOG_MAX_32 - STREAM_ACCUMULATOR_MIN_32                    \
        : 0)

seq_t ZSTD_decodeSequence(seqState_t* seqState, const ZSTD_longOffset_e longOffsets);

#endif

