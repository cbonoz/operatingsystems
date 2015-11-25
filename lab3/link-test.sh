echo Ltest-2Sames
ln -s hello.txt thelink
diff hello.txt thelink && echo Same
#Same Contents
echo "World" >> hello.txt
diff hello.txt thelink && echo Same
#Same Contents
ln -s hello.txt thelink2.txts
rm thelink

echo HLtest-4Foos2Blurbs
echo foo >> foo.txt
ln foo.txt gah.txt
ln gah.txt gah2.txt
cat gah.txt

#foo
cat gah2.txt
#foo
echo blurb >> gah.txt
cat foo.txt
#foo
cat gah2.txt
#foo

echo DELtest-2foos1err
rm gah.txt
cat gah2.txt
rm foo.txt
cat gah2.txt
rm gah2.txt
cat gah2.txt



