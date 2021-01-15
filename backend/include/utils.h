// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

#ifndef UTILS_H_
#define UTILS_H_

#ifdef _WIN32
    #include <winsock2.h>
    #include <Ws2tcpip.h>
    
    //From https://stackoverflow.com/a/20816961/2737696
	int inet_pton(int af, const char *src, void *dst);
	
    typedef SOCKET sockfd;

    //https://virtuallyfun.com/wordpress/2017/02/11/wsapoll-mingw/
    #ifdef __MINGW32__
        typedef struct pollfd {
            SOCKET fd;
            SHORT events;
            SHORT revents;
        } WSAPOLLFD, *PWSAPOLLFD, FAR *LPWSAPOLLFD;
        WINSOCK_API_LINKAGE int WSAAPI WSAPoll(LPWSAPOLLFD fdArray, ULONG fds, INT timeout);
        
        /* Event flag definitions for WSAPoll(). */
        #define POLLRDNORM  0x0100
        #define POLLRDBAND  0x0200
        #define POLLIN      (POLLRDNORM | POLLRDBAND)
        #define POLLPRI     0x0400

        #define POLLWRNORM  0x0010
        #define POLLOUT     (POLLWRNORM)
        #define POLLWRBAND  0x0020

        #define POLLERR     0x0001
        #define POLLHUP     0x0002
        #define POLLNVAL    0x0004
    #endif
    
    #define poll(x,y,z) WSAPoll(x,y,z)

    #define fix_rc(x) (((x) == SOCKET_ERROR) ? WSAGetLastError() : 0)
    #define sockerrno WSAGetLastError()

    int gettimeofday(struct timeval * tp, struct timezone * tzp);
    
#endif
    

#endif
