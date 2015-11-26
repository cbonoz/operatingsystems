
# try to allocate a block when there are no free blocks
# free a block and check that that block can be reallocated
# try to allocate 3 blocks when only 2 are free
# truncate a file so that it no longer has any indirect data blocks and ensure that the indirect pointer block is freed


#block size = 1KB
#blocks 65802 -> 65.8MB
#checked 61452 blocks on / through df cmd

dd if=/dev/zero of=63M.txt bs=1024 count=61450
dd if=/dev/zero of=3K.txt bs=1024 count=3

echo 3K Allocated > 3K.txt
cat 3K.txt
#should not successfully print
rm 3K.txt
rm 63M.txt
dd if=/dev/zero of=3K.txt bs=1034 count=3
echo 3K Allocated > 3K.txt
cat 3K.txt
rm 3K.txt