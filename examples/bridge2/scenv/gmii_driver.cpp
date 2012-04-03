#include "gmii_driver.h"

static unsigned int crc_table[] =
  {
    0x4DBDF21C, 0x500AE278, 0x76D3D2D4, 0x6B64C2B0,
    0x3B61B38C, 0x26D6A3E8, 0x000F9344, 0x1DB88320,
    0xA005713C, 0xBDB26158, 0x9B6B51F4, 0x86DC4190,
    0xD6D930AC, 0xCB6E20C8, 0xEDB71064, 0xF0000000
  };

uint32_t gmii_driver::calc_crc (int data_sz) {
  unsigned int n, crc=0;

  for (n=0; n<data_sz; n++)
  {
    crc = (crc >> 4) ^ crc_table[(crc ^ (txbuf[n] >> 0)) & 0x0F];  /* lower nibble */
    crc = (crc >> 4) ^ crc_table[(crc ^ (txbuf[n] >> 4)) & 0x0F];  /* upper nibble */
  }
  return crc;
}

void gmii_driver::print_packet(int len) {
  int i;

  for (i=0; i<len; i=i+1)
    {
      if (i % 16 == 0) printf ("%04x: ", i);
      printf ("%02x ", txbuf[i]);
      if (i % 16 == 7) printf ("| ");
      if (i % 16 == 15) printf ("\n");
    }
  if (i % 16 != 0) printf ("\n");
}

void gmii_driver::send_packet (uint64_t da, uint64_t sa, int len) 
{
  int i, crc;
  uint64_t shift;

  for (i=0; i<6; i++) {
    txbuf[i] = da >> (uint64_t) (40-i*8);
  }
  for (i=0; i<6; i++)
    txbuf[i+6] = sa >> (uint64_t) (40-i*8);

  for (i=12; i<(len-4); i++)
    txbuf[i] = random();

  crc = calc_crc (len-4);

  printf ("Sending packet DA=%12llx SA=%12llx of length %0d\n", da, sa, len);
  print_packet (len);

  sending = 1;
  send_len = len;
  send_index = 0;
}

void gmii_driver::event() {
  if (sending==1) {
    if (send_index == 7) {
      rxd = 0xD5;
      send_index = 0;
      sending = 2;
    } else {
      rxd = 0x55;
      send_index++;
    }
    rx_dv = 1;
  } else if (sending == 2) {
    rx_dv = 1;
    rxd = txbuf[send_index];
    send_index++;
    if (send_index >= send_len)
      sending = 0;
  } else {
    rx_dv = 0;
    rxd = 0;
  }
}

