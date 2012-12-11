# Import the variables from the DVSDK so that you can find the DVSDK components
include ${DVSDK}/Rules.make

helloworld:
	$(CSTOOL_PREFIX)gcc -o helloworld helloworld.c

clean:
	rm -f helloworld *~ *.o
