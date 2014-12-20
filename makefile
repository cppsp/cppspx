CFGFLAGS := 
CPPSP_LD := -lcryptopp
OPTFLAGS := -Ofast -march=native -flto
CXXFLAGS := $(OPTFLAGS) -Wall --std=c++0x -Wno-pmf-conversions -I./include $(CFGFLAGS)
CXX := g++
all: cppsp_standalone libcpoll.so libcppsp.so socketd_bin socketd_cppsp socketd_proxy.so
cppsp_standalone: 
	$(CXX) cppsp_server/cppsp_standalone.C cpoll/all.C cppsp/all.C -o cppsp_standalone -lpthread -ldl -lrt $(CXXFLAGS) -Wl,--unresolved-symbols=ignore-all
socketd_bin: 
	$(CXX) socketd/all.C cpoll/all.C -o socketd_bin -lpthread -ldl -lrt $(CXXFLAGS)
socketd_cppsp: 
	$(CXX) cppsp_server/socketd_cppsp.C cpoll/all.C cppsp/all.C -o socketd_cppsp -lpthread -ldl -lrt $(CXXFLAGS) -Wl,--unresolved-symbols=ignore-all
cpoll.o:
	$(CXX) cpoll/all.C -c -o cpoll.o $(CXXFLAGS) -fPIC
cppsp.o:
	$(CXX) cppsp/all.C -c -o cppsp.o $(CXXFLAGS) -fPIC
libcpoll.so: cpoll.o
	$(CXX) cpoll.o -o libcpoll.so --shared $(CXXFLAGS) -ldl -lpthread
libcppsp.so: cppsp.o libcpoll.so
	$(CXX) cppsp.o -o libcppsp.so --shared $(CXXFLAGS) $(CPPSP_LD) -ldl -lpthread -L. -lcpoll
socketd_proxy.so: cpoll.o
	$(CXX) socketd_proxy.C cpoll.o -o socketd_proxy.so -ldl -lpthread --std=c++0x --shared -fPIC $(CXXFLAGS) 
clean:
	rm -f cpoll.o cppsp.o cppsp_standalone socketd_bin socketd_cppsp *.so
	rm -f www/*.cppsp.so www/*.cppsp.C www/*.cppsp.txt
	rm -f www/*.cppsm.so www/*.cppsm.C www/*.cppsm.txt
	rm -f www/*.html.so www/*.html.C www/*.html.txt
