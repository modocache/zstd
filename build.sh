set -e
set -x

make clean zstd CC=clang
make -C ../zstd-gcc clean zstd CC=gcc

# Compile zstd_decodeSequence.o using Clang
cd programs
clang \
  -I../lib -I../lib/common -I../lib/compress -I../lib/dictBuilder \
  -DZSTD_NEWAPI -DXXH_NAMESPACE=ZSTD_ \
  -I../lib/legacy -DZSTD_MULTITHREAD -DZSTD_GZCOMPRESS -DZSTD_GZDECOMPRESS -DZSTD_LZMACOMPRESS -DZSTD_LZMADECOMPRESS -DZSTD_LEGACY_SUPPORT=4 \
  -O3 -Wall -Wextra -Wcast-qual -Wcast-align -Wshadow -Wstrict-aliasing=1 -Wswitch-enum -Wdeclaration-after-statement -Wstrict-prototypes -Wundef -Wpointer-arith -Wformat-security -Wvla -Wformat=2 -Winit-self -Wfloat-equal -Wwrite-strings -Wredundant-decls \
  -c -o ../lib/decompress/zstd_decodeSequence.o ../lib/decompress/zstd_decodeSequence.c
cd -

# Compile zstd_decodeSequence.o at -O0 using Clang
cd programs
clang \
  -I../lib -I../lib/common -I../lib/compress -I../lib/dictBuilder \
  -DZSTD_NEWAPI -DXXH_NAMESPACE=ZSTD_ \
  -I../lib/legacy -DZSTD_MULTITHREAD -DZSTD_GZCOMPRESS -DZSTD_GZDECOMPRESS -DZSTD_LZMACOMPRESS -DZSTD_LZMADECOMPRESS -DZSTD_LEGACY_SUPPORT=4 \
  -O0 -Wall -Wextra -Wcast-qual -Wcast-align -Wshadow -Wstrict-aliasing=1 -Wswitch-enum -Wdeclaration-after-statement -Wstrict-prototypes -Wundef -Wpointer-arith -Wformat-security -Wvla -Wformat=2 -Winit-self -Wfloat-equal -Wwrite-strings -Wredundant-decls \
  -c -o ../lib/decompress/zstd_decodeSequence-O0.o ../lib/decompress/zstd_decodeSequence.c
cd -

# Compile zstd_decodeSequence.o with debug info using Clang
cd programs
clang \
  -g \
  -I../lib -I../lib/common -I../lib/compress -I../lib/dictBuilder \
  -DZSTD_NEWAPI -DXXH_NAMESPACE=ZSTD_ \
  -I../lib/legacy -DZSTD_MULTITHREAD -DZSTD_GZCOMPRESS -DZSTD_GZDECOMPRESS -DZSTD_LZMACOMPRESS -DZSTD_LZMADECOMPRESS -DZSTD_LEGACY_SUPPORT=4 \
  -O3 -Wall -Wextra -Wcast-qual -Wcast-align -Wshadow -Wstrict-aliasing=1 -Wswitch-enum -Wdeclaration-after-statement -Wstrict-prototypes -Wundef -Wpointer-arith -Wformat-security -Wvla -Wformat=2 -Winit-self -Wfloat-equal -Wwrite-strings -Wredundant-decls \
  -c -o ../lib/decompress/zstd_decodeSequence-debug.o ../lib/decompress/zstd_decodeSequence.c
cd -

# Produce LLVM IR (unoptimized) for zstd_decodeSequence using Clang
cd programs
clang \
  -S -emit-llvm \
  -I../lib -I../lib/common -I../lib/compress -I../lib/dictBuilder \
  -DZSTD_NEWAPI -DXXH_NAMESPACE=ZSTD_ \
  -I../lib/legacy -DZSTD_MULTITHREAD -DZSTD_GZCOMPRESS -DZSTD_GZDECOMPRESS -DZSTD_LZMACOMPRESS -DZSTD_LZMADECOMPRESS -DZSTD_LEGACY_SUPPORT=4 \
  -Wall -Wextra -Wcast-qual -Wcast-align -Wshadow -Wstrict-aliasing=1 -Wswitch-enum -Wdeclaration-after-statement -Wstrict-prototypes -Wundef -Wpointer-arith -Wformat-security -Wvla -Wformat=2 -Winit-self -Wfloat-equal -Wwrite-strings -Wredundant-decls \
  -c -o ../lib/decompress/zstd_decodeSequence.ll ../lib/decompress/zstd_decodeSequence.c
cd -

# Compile zstd_decodeSequence.o using GCC
cd ../zstd-gcc/programs
gcc \
  -I../lib -I../lib/common -I../lib/compress -I../lib/dictBuilder \
  -DZSTD_NEWAPI -DXXH_NAMESPACE=ZSTD_ \
  -I../lib/legacy -DZSTD_MULTITHREAD -DZSTD_GZCOMPRESS -DZSTD_GZDECOMPRESS -DZSTD_LZMACOMPRESS -DZSTD_LZMADECOMPRESS -DZSTD_LEGACY_SUPPORT=4 \
  -O3 -Wall -Wextra -Wcast-qual -Wcast-align -Wshadow -Wstrict-aliasing=1 -Wswitch-enum -Wdeclaration-after-statement -Wstrict-prototypes -Wundef -Wpointer-arith -Wformat-security -Wvla -Wformat=2 -Winit-self -Wfloat-equal -Wwrite-strings -Wredundant-decls \
  -c -o ../lib/decompress/zstd_decodeSequence.o ../lib/decompress/zstd_decodeSequence.c
cd -

# Emit disassembly for both Clang and GCC object files
llvm-objdump -d lib/decompress/zstd_decodeSequence.o > zstd_decodeSequence-clang.s
llvm-objdump -d lib/decompress/zstd_decodeSequence-O0.o > zstd_decodeSequence-clang-O0.s
llvm-objdump -d lib/decompress/zstd_decodeSequence-debug.o > zstd_decodeSequence-clang-debug.s
llvm-objdump -d ../zstd-gcc/lib/decompress/zstd_decodeSequence.o > zstd_decodeSequence-gcc.s

# Link zstd using all Clang, including zstd_decodeSequence.o from Clang
cd programs
clang \
  -I../lib -I../lib/common -I../lib/compress -I../lib/dictBuilder \
  -DZSTD_NEWAPI -DXXH_NAMESPACE=ZSTD_ \
  -I../lib/legacy -DZSTD_MULTITHREAD -DZSTD_GZCOMPRESS -DZSTD_GZDECOMPRESS -DZSTD_LZMACOMPRESS -DZSTD_LZMADECOMPRESS -DZSTD_LEGACY_SUPPORT=4 \
  -O3 -Wall -Wextra -Wcast-qual -Wcast-align -Wshadow -Wstrict-aliasing=1 -Wswitch-enum -Wdeclaration-after-statement -Wstrict-prototypes -Wundef -Wpointer-arith -Wformat-security -Wvla -Wformat=2 -Winit-self -Wfloat-equal -Wwrite-strings -Wredundant-decls  \
  -pthread -lz -llzma \
  ../lib/common/entropy_common.c ../lib/common/error_private.c ../lib/common/fse_decompress.c ../lib/common/pool.c ../lib/common/threading.c ../lib/common/xxhash.c ../lib/common/zstd_common.c ../lib/compress/fse_compress.c ../lib/compress/huf_compress.c ../lib/compress/zstd_compress.c ../lib/compress/zstd_double_fast.c ../lib/compress/zstd_fast.c ../lib/compress/zstd_lazy.c ../lib/compress/zstd_ldm.c ../lib/compress/zstd_opt.c ../lib/compress/zstdmt_compress.c ../lib/decompress/huf_decompress.c ../lib/decompress/zstd_decompress.c ../lib/dictBuilder/cover.c ../lib/dictBuilder/divsufsort.c ../lib/dictBuilder/zdict.c ../lib/legacy/zstd_v04.c ../lib/legacy/zstd_v05.c ../lib/legacy/zstd_v06.c ../lib/legacy/zstd_v07.c zstdcli.o fileio.o bench.o datagen.o dibio.o \
  ../../zstd/lib/decompress/zstd_decodeSequence.o -o zstd-clang -pthread -lz -llzma
cd -

# Link zstd using all Clang, except for zstd_decodeSequence.o from GCC
cd programs
clang \
  -I../lib -I../lib/common -I../lib/compress -I../lib/dictBuilder \
  -DZSTD_NEWAPI -DXXH_NAMESPACE=ZSTD_ \
  -I../lib/legacy -DZSTD_MULTITHREAD -DZSTD_GZCOMPRESS -DZSTD_GZDECOMPRESS -DZSTD_LZMACOMPRESS -DZSTD_LZMADECOMPRESS -DZSTD_LEGACY_SUPPORT=4 \
  -O3 -Wall -Wextra -Wcast-qual -Wcast-align -Wshadow -Wstrict-aliasing=1 -Wswitch-enum -Wdeclaration-after-statement -Wstrict-prototypes -Wundef -Wpointer-arith -Wformat-security -Wvla -Wformat=2 -Winit-self -Wfloat-equal -Wwrite-strings -Wredundant-decls  \
  -pthread -lz -llzma \
  ../lib/common/entropy_common.c ../lib/common/error_private.c ../lib/common/fse_decompress.c ../lib/common/pool.c ../lib/common/threading.c ../lib/common/xxhash.c ../lib/common/zstd_common.c ../lib/compress/fse_compress.c ../lib/compress/huf_compress.c ../lib/compress/zstd_compress.c ../lib/compress/zstd_double_fast.c ../lib/compress/zstd_fast.c ../lib/compress/zstd_lazy.c ../lib/compress/zstd_ldm.c ../lib/compress/zstd_opt.c ../lib/compress/zstdmt_compress.c ../lib/decompress/huf_decompress.c ../lib/decompress/zstd_decompress.c ../lib/dictBuilder/cover.c ../lib/dictBuilder/divsufsort.c ../lib/dictBuilder/zdict.c ../lib/legacy/zstd_v04.c ../lib/legacy/zstd_v05.c ../lib/legacy/zstd_v06.c ../lib/legacy/zstd_v07.c zstdcli.o fileio.o bench.o datagen.o dibio.o \
  ../../zstd-gcc/lib/decompress/zstd_decodeSequence.o -o zstd-gcc -pthread -lz -llzma
cd -

