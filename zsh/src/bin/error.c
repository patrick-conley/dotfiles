#include <stdio.h>
#include <sys/time.h>
#include <unistd.h>
#include <getopt.h>

/*
 * error.c
 *
 * Syntax
 *    error [ -w | --write ] 'error'
 *    error -r | --read
 *    error -h
 */

int main( int argc, char ** argv )
{

   // getopts
   static struct option long_opts[] = {
      { "write", 1, NULL, 'w' },
      { "read", 0, NULL, '' },
      { "help", 0, NULL, 'h' },
   };

   int c;
   int index;
   while ( ( c = getopt_long( argc, argv, ":rw:h", long_opts, NULL ) ) != -1 )
   {

      switch (c)
      {
         case 'w':
            printf( "%c %s\n", c, optarg );
            break;
         case 'r':
            printf( "%c\n", c );
            break;
         case 'h':
            printf( "Help\n" );
            break;
         default:
            printf( "Something happened\n" );
      }

   }

   return 0;

}
