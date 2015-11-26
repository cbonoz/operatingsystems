# ### symlink test

# echo Ltest-2Sames
# ln -s hello.txt thelink
# diff hello.txt thelink && echo Same
# #Same 
# echo "World" >> hello.txt
# diff hello.txt thelink && echo Same
# #Same 

# rm thelink
# cat hello.txt



### hardlink test

echo HLtest-4Foos2Blurbs
echo foo >> foo
ln foo gah
ln foo gah2
cat gah

#foo
cat gah2
#foo
echo blurb >> gah
cat foo
#foo blurb
cat gah
#foo blurb


### hardlink deletion


echo DELtest-1Foo1Blurb1Error

rm gah
cat foo
rm foo
cat foo