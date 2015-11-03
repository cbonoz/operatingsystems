echo test0 && find /usr -maxdepth 4  > file1.log

echo test1 && find /usr -maxdepth 4 > file2.log

echo test2 && find /usr -maxdepth 4 > file3.log

echo test3 && cat file1.log > file2.log

echo test4 && cat file2.log > file1.log

echo test5 && cat file3.log > file2.log

echo test6 && cat file3.log > file1.log

#echo test7 && cat file3.log > file2.log
