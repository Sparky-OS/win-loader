/* libgcrypt-hash.c
 * Copyright (C) 2016, Didier Raboud
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include <gcrypt.h>
#include <stdio.h>
#include <errno.h>

int print_hash_fp(int hash_algo, char *argv[]) {

    /* Length of resulting hash - gcry_md_get_algo_dlen
     * returns digest lenght for an algo */
    int hash_len = gcry_md_get_algo_dlen( hash_algo );

    /* output hash - this will be binary data */
    unsigned char hash[ hash_len ];

    /* output hash - converted to hex representation
     * 2 hex digits for every byte + 1 for trailing \0 */
    char *out = (char *) malloc( sizeof(char) * ((hash_len*2)+1) );
    char *p = out;

    /* File-reading */
    FILE *fp;
    char buffer[4096];
    size_t n;
    gcry_md_hd_t hd;
    unsigned char *hash_ptr;

    /* Initialize hash */
    gcry_md_open (&hd, hash_algo, 0);

    fp = fopen (*argv, "rb");
    if (!fp)
    {
	fprintf (stderr, "can't open `%s': %s\n", *argv, strerror (errno));
	exit (1);
    }
    while ( (n = fread (buffer, 1, sizeof buffer, fp)))
	gcry_md_write(hd, buffer, n);
    if (ferror (fp))
    {
	fprintf (stderr, "error reading `%s': %s\n", *argv,strerror (errno));
	exit (1);
    }
    gcry_md_final(hd);
    fclose (fp);
    hash_ptr = gcry_md_read (hd, hash_algo);
    if (hash_ptr == NULL)
    {
	fprintf (stderr, "gcry_md_read failed.");
	gcry_md_close (hd);
	return (-1);
    }
    memcpy (hash, hash_ptr, sizeof (hash));

    /* Convert each byte to its 2 digit ascii
     * hex representation and place in out */
    int i;
    for ( i = 0; i < hash_len; i++, p += 2 ) {
	snprintf ( p, 3, "%02x", hash[i] );
    }

    printf( "%s\n", out );
    free( out );

    return 0;
}

int main(int argc, char *argv[])
{
    /* Test for arg string */
    if ( argc < 2 ){
	fprintf( stderr, "Usage: %s filenames\n", argv[0] );
	exit( 1 );
    }
    for (argc--, argv++; argc; argv++, argc--)
    {
	print_hash_fp(GCRY_MD_MD5, argv);
	print_hash_fp(GCRY_MD_SHA1, argv);
	print_hash_fp(GCRY_MD_SHA256, argv);
	print_hash_fp(GCRY_MD_SHA512, argv);
    }

}
