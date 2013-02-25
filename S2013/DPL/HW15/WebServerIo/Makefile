
all:
	@echo "Nothing to do."

test:
	perl test.t
	make clean

test00:
	ruby server0.rb &
	time -f'%e' io client0.io
	make clean

test01:
	ruby server0.rb &
	time -f'%e' io client1.io
	make clean

test10:
	io server1.io &
	time -f'%e' io client0.io
	make clean

test11:
	io server1.io &
	time -f'%e' io client1.io
	make clean

clean:
	rm -f *~ *-*.*-std*
