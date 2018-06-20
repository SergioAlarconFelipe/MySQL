select 
	test_normal, 
	concat( 
		round( 
			length( test_compress ) * 100 / length( test_normal ),
		2 ),
	'%' )
from test

update test
set test_compress = compress( test_normal )
where id = 1
