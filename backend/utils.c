// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <time.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <vpi_user.h>
#ifdef _WIN32
    #include <winsock2.h>
    #include <Ws2tcpip.h>

    
  //From https://stackoverflow.com/a/20816961/2737696
	int inet_pton(int af, const char *src, void *dst)
	{
	  struct sockaddr_storage ss;
	  int size = sizeof(ss);
	  char src_copy[INET6_ADDRSTRLEN+1];

	  ZeroMemory(&ss, sizeof(ss));
	  /* stupid non-const API */
	  strncpy (src_copy, src, INET6_ADDRSTRLEN);
	  src_copy[INET6_ADDRSTRLEN] = 0;

	  if (WSAStringToAddress(src_copy, af, NULL, (struct sockaddr *)&ss, &size) == 0) {
		switch(af) {
		  case AF_INET:
		*(struct in_addr *)dst = ((struct sockaddr_in *)&ss)->sin_addr;
		return 1;
		  case AF_INET6:
		*(struct in6_addr *)dst = ((struct sockaddr_in6 *)&ss)->sin6_addr;
		return 1;
		}
	  }
	  return 0;
	}
    
    
//  static char* sockstrerror(int x) {
//        static char line[80];
//
//        //From https://stackoverflow.com/a/16723307/2737696
//        char *s = NULL;
//        FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
//                       NULL, x,
//                       MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
//                       (LPSTR)&s, 0, NULL);
//        strcpy(line, s);
//        LocalFree(s);
//
//        //sprintf(line, "some inscrutable windows-related problem with code %d", x);
//        return line;
//  }
//
    
    //From https://stackoverflow.com/a/26085827/2737696

    #include <stdint.h> // portable: uint64_t   MSVC: __int64 

    struct timezone;

    int gettimeofday(struct timeval * tp, struct timezone * tzp)
    {
        // Note: some broken versions only have 8 trailing zero's, the correct epoch has 9 trailing zero's
        // This magic number is the number of 100 nanosecond intervals since January 1, 1601 (UTC)
        // until 00:00:00 January 1, 1970 
        static const uint64_t EPOCH = ((uint64_t) 116444736000000000ULL);

        SYSTEMTIME  system_time;
        FILETIME    file_time;
        uint64_t    time;
        
        GetSystemTime( &system_time );
        SystemTimeToFileTime( &system_time, &file_time );
        time =  ((uint64_t)file_time.dwLowDateTime )      ;
        time += ((uint64_t)file_time.dwHighDateTime) << 32;

        tp->tv_sec  = (long) ((time - EPOCH) / 10000000L);
        tp->tv_usec = (long) (system_time.wMilliseconds * 1000);
        
        return 0;
    }
#endif
