echo "============= Parsing + Selectors =================="
echo "Crystagiri(LibXML)"
./xtime.rb ./bin_test_libxml
echo "modest(myhtml)"
./xtime.rb ./bin_test_myhtml
echo "Gumbo"
./xtime.rb ./bin_test_gumbo
echo "Lexbor"
./xtime.rb ./bin_test_lexbor
echo "Html5"
./xtime.rb ./bin_test_html5
echo "Crystal (LibXML)"
./xtime.rb ./bin_test_crystal
echo "Nokolexbor(lexbor)"
./xtime.rb ruby test-nokolexbor.rb
echo "Nokogiri(LibXML)"
./xtime.rb ruby test-libxml.rb

