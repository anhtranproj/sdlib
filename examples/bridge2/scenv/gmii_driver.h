#ifndef GMII_DRIVER_H_
#define GMII_DRIVER_H_
#include <stdint.h>
#include <unistd.h>
#include "systemc.h"

SC_MODULE(gmii_driver)
{
 private:
  int 	    startup_skew;
  
  uint8_t  	    txbuf [2048];
  int send_len, send_index;

  int sending;
  
 public:
  sc_in<bool>     clk;
  
  sc_out<bool>    rx_dv;
  sc_out<uint32_t> rxd;
  
  void event();
  uint32_t calc_crc (int data_sz);
  void send_packet (uint64_t da, uint64_t sa, int len);
  void print_packet(int len);
	
  SC_CTOR(gmii_driver) {
    SC_METHOD(event);
    sensitive << clk.pos();
    
    sending = 0;
  }
};

#endif /*GMII_DRIVER_H_*/
