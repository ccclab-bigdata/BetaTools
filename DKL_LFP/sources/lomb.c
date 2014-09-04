/* file: lomb.c		G. Moody	12 February 1992
			Last revised:	  23 May 2000

-------------------------------------------------------------------------------
lomb: Lomb periodogram of real data
Copyright (C) 2000 George B. Moody

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program; if not, write to the Free Software Foundation, Inc., 59 Temple
Place - Suite 330, Boston, MA 02111-1307, USA.

You may contact the author by e-mail (george@mit.edu) or postal mail
(MIT Room E25-505A, Cambridge, MA 02139 USA).  For updates to this software,
please visit PhysioNet (http://www.physionet.org/).
_______________________________________________________________________________

The default input to this program is a text file containing a sampled time
series, presented as two columns of numbers (the sample times and the sample
values).  The intervals between consecutive samples need not be uniform (in
fact, this is the most significant advantage of the Lomb periodogram over other
methods of power spectral density estimation).  This program writes the Lomb
periodogram (the power spectral density estimate derived from the input time
series) on the standard output.

The original version of this program was based on the algorithm described in
Press, W.H, and Rybicki, G.B., Astrophysical J. 338:277-280 (1989).  It has
been rewritten using the versions of this algorithm presented in Numerical
Recipes in C (Press, Teukolsky, Vetterling, and Flannery;  Cambridge U. Press,
1992).

This version agrees with `fft' output (amplitude spectrum up to the Nyquist
frequency with total power equal to the variance);  thanks to Joe Mietus.
*/

//version 2. Obtains at least 0.1 Hz resolution. -Murat Okatan.
//version 1. Outputs M, prob, nout, pwr. -Murat Okatan.

#include <stdio.h>
#include <math.h>

#ifndef hpux
#define NMAX	65536	/* maximum number of inputs */
#else
#define NMAX	64000
#endif

static long lmaxarg1, lmaxarg2;
#define LMAX(a,b) (lmaxarg1 = (a),lmaxarg2 = (b), (lmaxarg1 > lmaxarg2 ? \
						   lmaxarg1 : lmaxarg2))
static long lminarg1, lminarg2;
#define LMIN(a,b) (lminarg1 = (a),lminarg2 = (b), (lminarg1 < lminarg2 ? \
						   lminarg1 : lminarg2))
#define MOD(a,b)	while (a >= b) a -= b
#define MACC 4
#define SIGN(a,b) ((b) > 0.0 ? fabs(a) : -fabs(a))
static float sqrarg;
#define SQR(a) ((sqrarg = (a)) == 0.0 ? 0.0 : sqrarg*sqrarg)
#define SWAP(a,b) tempr=(a);(a)=(b);(b)=tempr

char *pname;
float pwr;

void fasper(x, y, n, ofac, hifac, wk1, wk2, nwk, nout, jmax, prob)
float x[], y[];
unsigned long n;
float ofac, hifac, wk1[], wk2[];
unsigned long nwk, *nout, *jmax;
float *prob;
{
    void avevar(), realft(), spread();
    unsigned long j, k, ndim, nfreq, nfreqt;
    float ave, ck, ckk, cterm, cwt, den, df, effm, expy, fac, fndim, hc2wt,
          hs2wt, hypo, pmax, sterm, swt, var, xdif, xmax, xmin;

    *nout = 0.5*ofac*hifac*n;
    nfreqt = ofac*hifac*n*MACC;
    nfreq = 64;
    while (nfreq < nfreqt) nfreq <<= 1;
    ndim = nfreq << 1;
    if (ndim > nwk) {
	fprintf(stderr, "%s: workspaces too small\n", pname);
	exit(1);
    }
    avevar(y, n, &ave, &var);
    xmax = xmin = x[1];
    for (j = 2; j <= n; j++) {
	if (x[j] < xmin) xmin = x[j];
	if (x[j] > xmax) xmax = x[j];
    }
    xdif = xmax - xmin;
    for (j = 1; j <= ndim; j++) wk1[j] = wk2[j] = 0.0;
    fac = ndim/(xdif*ofac);
    fndim = ndim;
    for (j = 1; j <= n; j++) {
	ck = (x[j] - xmin)*fac;
	MOD(ck, fndim);
	ckk = 2.0*(ck++);
	MOD(ckk, fndim);
	++ckk;
	spread(y[j] - ave, wk1, ndim, ck, MACC);
	spread(1.0, wk2, ndim, ckk, MACC);
    }
    realft(wk1, ndim, 1);
    realft(wk2, ndim, 1);
    df = 1.0/(xdif*ofac);
    pmax = -1.0;
    for (k = 3, j = 1; j <= (*nout); j++, k += 2) {
	hypo = sqrt(wk2[k]*wk2[k] + wk2[k+1]*wk2[k+1]);
	hc2wt = 0.5*wk2[k]/hypo;
	hs2wt = 0.5*wk2[k+1]/hypo;
	cwt = sqrt(0.5+hc2wt);
	swt = SIGN(sqrt(0.5-hc2wt), hs2wt);
	den = 0.5*n + hc2wt*wk2[k] + hs2wt*wk2[k+1];
	cterm = SQR(cwt*wk1[k] + swt*wk1[k+1])/den;
	sterm = SQR(cwt*wk1[k+1] - swt*wk1[k])/(n - den);
	wk1[j] = j*df;
	wk2[j] = (cterm+sterm)/(2.0*var);
	if (wk2[j] > pmax) pmax = wk2[(*jmax = j)];
    }
    expy = exp(-pmax);
    effm = 2.0*(*nout)/ofac;
    *prob = effm*expy;
    if (*prob > 0.01) *prob = 1.0 - pow(1.0 - expy, effm);

    //m effm
    printf("%f\t%f\n", effm, *prob);
}

void spread(y, yy, n, x, m)
float y, yy[];
unsigned long n;
float x;
int m;
{
    int ihi, ilo, ix, j, nden;
    static int nfac[11] = { 0, 1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880 };
    float fac;

    if (m > 10) {
	fprintf(stderr, "%s: factorial table too small\n", pname);
	exit(1);
    }
    ix = (int)x;
    if (x == (float)ix) yy[ix] += y;
    else {
	ilo = LMIN(LMAX((long)(x - 0.5*m + 1.0), 1), n - m + 1);
	ihi = ilo + m - 1;
	nden = nfac[m];
	fac = x - ilo;
	for (j = ilo + 1; j <= ihi; j++) fac *= (x - j);
	yy[ihi] += y*fac/(nden*(x - ihi));
	for (j = ihi-1; j >= ilo; j--) {
	    nden = (nden/(j + 1 - ilo))*(j - ihi);
	    yy[j] += y*fac/(nden*(x - j));
	}
    }
}

void avevar(data, n, ave, var)
float data[];
unsigned long n;
float *ave, *var;
{
    unsigned long j;
    float s, ep;

    for (*ave = 0.0, j = 1; j <= n; j++) *ave += data[j];
    *ave /= n;
    *var = ep = 0.0;
    for (j = 1; j <= n; j++) {
	s = data[j] - (*ave);
	ep += s;
	*var += s*s;
    }
    *var = (*var - ep*ep/n)/(n-1);
    pwr = *var;
}

void realft(data, n, isign)
float data[];
unsigned long n;
int isign;
{
    void four1();
    unsigned long i, i1, i2, i3, i4, np3;
    float c1 = 0.5, c2, h1r, h1i, h2r, h2i;
    double wr, wi, wpr, wpi, wtemp, theta;

    theta = 3.141592653589793/(double)(n>>1);
    if (isign == 1) {
	c2 = -0.5;
	four1(data, n>>1, 1);
    } else {
	c2 = 0.5;
	theta = -theta;
    }
    wtemp = sin(0.5*theta);
    wpr = -2.0*wtemp*wtemp;
    wpi = sin(theta);
    wr = 1.0 + wpr;
    wi = wpi;
    np3 = n+3;
    for (i = 2; i <= (n>>2); i++) {
	i4 = 1 + (i3 = np3 - (i2 = 1 + (i1 = i + i - 1)));
	h1r =  c1*(data[i1] + data[i3]);
	h1i =  c1*(data[i2] - data[i4]);
	h2r = -c2*(data[i2] + data[i4]);
	h2i =  c2*(data[i1] - data[i3]);
	data[i1] =  h1r + wr*h2r - wi*h2i;
	data[i2] =  h1i + wr*h2i + wi*h2r;
	data[i3] =  h1r - wr*h2r + wi*h2i;
	data[i4] = -h1i +wr*h2i + wi*h2r;
	wr = (wtemp = wr)*wpr - wi*wpi + wr;
	wi = wi*wpr + wtemp*wpi + wi;
    }
    if (isign == 1) {
	data[1] = (h1r = data[1]) + data[2];
	data[2] = h1r - data[2];
    } else {
	data[1] = c1*((h1r = data[1]) + data[2]);
	data[2] = c1*(h1r - data[2]);
	four1(data, n>>1, -1);
    }
}

void four1(data,nn,isign)
float data[];
unsigned long nn;
int isign;
{
    unsigned long n, mmax, m, j, istep, i;
    double wtemp, wr, wpr, wpi, wi, theta;
    float tempr, tempi;

    n = nn << 1;
    j = 1;
    for (i = 1; i < n; i += 2) {
	if (j > i) {
	    SWAP(data[j], data[i]);
	    SWAP(data[j+1], data[i+1]);
	}
	m = n >> 1;
	while (m >= 2 && j > m) {
	    j -= m;
	    m >>= 1;
	}
	j += m;
    }
    mmax = 2;
    while (n > mmax) {
	istep = mmax << 1;
	theta = isign*(6.28318530717959/mmax);
	wtemp = sin(0.5*theta);
	wpr = -2.0*wtemp*wtemp;
	wpi = sin(theta);
	wr = 1.0;
	wi = 0.0;
	for (m = 1; m < mmax; m += 2) {
	    for (i = m;i <= n;i += istep) {
		j = i + mmax;
		tempr = wr*data[j] - wi*data[j+1];
		tempi = wr*data[j+1] + wi*data[j];
		data[j] = data[i] - tempr;
		data[j+1] = data[i+1] - tempi;
		data[i] += tempr;
		data[i+1] += tempi;
	    }
	    wr = (wtemp = wr)*wpr - wi*wpi + wr;
	    wi = wi*wpr + wtemp*wpi + wi;
	}
	mmax = istep;
    }
}

main(argc, argv)
int argc;
char *argv[];
{
    char *prog_name();
    FILE *ifile = NULL;
    int i, sflag=0, aflag=1;
    static float x[NMAX], y[NMAX], wk1[64*NMAX], wk2[64*NMAX], prob;
    unsigned long n, nout, jmax, maxout;
    void help();
    float xmin, xmax, xdif, ofac;

    pname = prog_name(argv[0]);
    for (i = 1; i < argc; i++) {
	if (*argv[i] == '-') switch (*(argv[i]+1)) {
	  case 'h':	    /* print help and exit */
	    help();
	    exit(0);
	    break;
	  case 's':	    /* smooth output */
	    sflag = 1;
	    break;
	  case 'P':	    /* output powers instead of amplitudes */
	    aflag = 0;
	    break;
	  case '\0':	    /* read data from standard input */
	    ifile = stdin;
	    break;
	  default:
	    fprintf(stderr, "%s: unrecognized option %s ignored\n",
		    pname, argv[i]);
	    break;
	}
	else if (i == argc-1) {	/* last argument: input file name */
	    if ((ifile = fopen(argv[i], "rt")) == NULL) {
		fprintf(stderr, "%s: can't open %s\n", pname, argv[i]);
		exit(2);
	    }
	}
    }
    if (ifile == NULL) {
	help();
	exit(1);
    }

    /* Read input. */
    for (n = 0; (n < NMAX) && (fscanf(ifile, "%f%f", &x[n], &y[n]) == 2); n++)
      {
	if (n==1)
	    xmax = xmin = x[1];	    
        else
	  if (n>0)
	    {
	      if (x[n] < xmin) xmin = x[n];
	      if (x[n] > xmax) xmax = x[n];
	    }
      }
    xdif = xmax - xmin;
    ofac=10.0/xdif;
    if (ofac<4) ofac=4.0;

    /* Compute the Lomb periodogram. */
    fasper(x-1, y-1, n, ofac, 2.0, wk1-1, wk2-1, 64*NMAX, &nout, &jmax, &prob);

    /* Write the results.  The normalization is by half the number of output
       samples;  the sum of the outputs is (approximately) the mean square of
       the inputs. */

    maxout = nout/2;    /* output only up to nyquist freq */

    //m nout and pwr
    printf("%lu\t%f\n", nout, pwr);

    if (sflag) {        /* smoothed */

        pwr /= 4;

        if (aflag)      /* smoothed amplitudes */
	    for (n = 0; n < maxout; n += 4)
	        printf("%g\t%g\n", wk1[n],
		      sqrt((wk2[n]+wk2[n+1]+wk2[n+2]+wk2[n+3])/(nout/(8.0*pwr))));

        else            /* smoothed powers */
	    for (n = 0; n < maxout; n += 4)
	        printf("%g\t%g\n", wk1[n],
		      (wk2[n]+wk2[n+1]+wk2[n+2]+wk2[n+3])/(nout/(8.0*pwr)));

    }
    else {    	        /* oversampled */

        if (aflag)      /* amplitudes */
	    for (n = 0; n < maxout; n++)
	        printf("%g\t%g\n", wk1[n], sqrt(wk2[n]/(nout/(2.0*pwr))));

        else            /* powers */
	    for (n = 0; n < maxout; n++)
	        printf("%g\t%g\n", wk1[n], wk2[n]/(nout/(2.0*pwr)));

    }

    exit(0);
}

char *prog_name(s)
char *s;
{
    char *p = s + strlen(s);

#ifdef MSDOS
    while (p >= s && *p != '\\' && *p != ':') {
	if (*p == '.')
	    *p = '\0';		/* strip off extension */
	if ('A' <= *p && *p <= 'Z')
	    *p += 'a' - 'A';	/* convert to lower case */
	p--;
    }
#else
    while (p >= s && *p != '/')
	p--;
#endif
    return (p+1);
}

static char *help_strings[] = {
"usage: %s [ OPTIONS ...] INPUT-FILE\n",
" outputs amplitude spectrum up to the nyquist frequency with total power",
" equal to the variance.",
" INPUT-FILE is the name of a text file containing a time series",
" (use `-' to read the standard input), and OPTIONS may be any of:",
" -h       Print on-line help.",
" -s       Produce smoothed output.",
" -P       Output powers instead of amplitudes.",
NULL
};

void help()
{
    int i;

    (void)fprintf(stderr, help_strings[0], pname);
    for (i = 1; help_strings[i] != NULL; i++)
	(void)fprintf(stderr, "%s\n", help_strings[i]);
}
