cat < /etc/passwd | tr a-z A-Z > out || echo sort failed!

cat < /etc/passwd | tr a-z A-Z | sort -u > out2 || echo sort failed!

diff out out2 > out3|| echo Test 1 PIPE succeeded

ls > out4 && echo Test 2 AND succeeded

diff out out2 > out3|| echo Test 3 OR succeeded

echo Test 4 ; echo SEQUENCE succeeded

(diff out out2 > out3|| echo Test 5 SUBSHELL succeeded)

(mkdir test2 ; rmdir test2) && echo Test 6 rm succeeded