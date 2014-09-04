/*
*   eegread.c - reads a .eeg datafile and extracts the tstamps, nsamples, and the eegvalues.
*
*	to compile: mex eegread.c
*
*   Author: Murat Okatan
*   Copyright (c) 2002 Boston University
*   
*
*   MATLAB usage: [t, eegvalues]=eegread(fname, samplingrate)
	ex: [t d]=eegread("myfile.eeg", 1500); %1500 Hz
*
*/

/*
version 5. Added a function to make sure data are read as little-endian on all
    platforms.
version 4. The waitbar complains that the title has single backslashes, which it thinks 
    represent TeX symbol beginnings. I double the backslashes in the title to avoid it.
version 3. Changed the waitbar.
version 2. Interpolate the tstamp. Produce tstamp and eegdata only. Use fseek to skip nsamples, instead of
	reading each one of them. Add a new input: samlingrate. Returns tstamp in seconds.
version 1. simply read the data file and produce tstamp, nsamples, and eegdata --Murat
*/


#include "mex.h"
#include "matrix.h"
#include <stdio.h>
#include <stdlib.h>

#define FNAME   prhs[0]
#define SRATE   prhs[1]

#define T       plhs[0]
#define EEGV    plhs[1]

/*Function to read LittleEndian data*/
int freadLE(unsigned char *buffer, int nbytes_per_sample, int nsamples, FILE *infile)
{/*freadLE*/
    int i, count=0;
    register unsigned long dummy_ulong; /*Also serves ints since they are 4 byte too.*/
    register short dummy_short;
    
    switch (nbytes_per_sample)
    {/*Switch*/
        case sizeof(unsigned long):
            for (i=0; i<nsamples; i++)
            {
                dummy_ulong = (unsigned long)(fgetc(infile) & 0xFF);
                dummy_ulong|=((unsigned long)(fgetc(infile) & 0xFF)<<0x08);
                dummy_ulong|=((unsigned long)(fgetc(infile) & 0xFF)<<0x10);
                dummy_ulong|=((unsigned long)(fgetc(infile) & 0xFF)<<0x18);

                if (feof(infile))
                    return count;
                *((unsigned long *)(buffer+i*nbytes_per_sample))=
                    dummy_ulong;
                ++count;
            }
            break;
        case sizeof(short):
            for (i=0; i<nsamples; i++)
            {
                dummy_short = (int)(fgetc(infile) & 0xFF);
                dummy_short|=((int)(fgetc(infile) & 0xFF)<<0x08);

                if (feof(infile))
                    return count;
                *((int *)(buffer+i*nbytes_per_sample))=
                    dummy_short;
                ++count;
            }
            break;
         default:
            printf("Unknown data size in extract_tables:freadLE\n");
            break;
    }/*Switch*/
    
    return count;
}/*freadLE*/


void mexFunction( int nlhs,         mxArray *plhs[],
                  int nrhs, const   mxArray *prhs[])
{/*mexFunction*/
    char *fname, dummyCharBuffer[1000], title[100], title_fname[100];
    double *t_index, *eegv_index;
    short *shortBuffer;
    double file_size, *double_pointer, Delta, samplingrate;
    unsigned long numOfRecords=0, tstamp, totalNumOfSamples=0;
    mxArray *wait_prhs[3], *wait_plhs[1];
    int r, c, i, numOfSamples, j;
    FILE *infile;

    /*get file name*/
        r=mxGetM(FNAME);
        c=mxGetN(FNAME);

        fname=mxCalloc(r*c, sizeof(char));
        fname=mxArrayToString(FNAME);

    /*get samplingrate*/
        samplingrate=mxGetScalar(SRATE);

	Delta=1e4/samplingrate;

    /*Open the input file read only*/
        if ((infile=fopen(fname, "rb"))==NULL)
	{
		printf("eegread: Could not open input file\n");
		return;
	}

	/*Determine the file size*/
	if (fseek(infile, 0, SEEK_END))
	{
	    printf("eegread: Could not determine file size\n");
	    return;
	}
	file_size=(double)ftell(infile);
	rewind(infile);

	/*Create the waitbar*/
	    /*Set bar length to 0*/
		wait_prhs[0]=mxCreateDoubleMatrix(1,1,mxREAL);
		double_pointer=mxGetPr(wait_prhs[0]);
		*double_pointer=0;

		/*Set title*/
		        j=0;
		        for(i=0; i<strlen(fname); i++)
		        {
		            title_fname[j++]=fname[i];
		            if (fname[i]=='\\')
		            {
		                title_fname[j++]='\\';
		            }
		        }
		        title_fname[j]='\0';
		        
                snprintf(title, 100, "Counting Data Records in %s: ", title_fname);
                wait_prhs[1]=mxCreateString(title);

		/*Launch waitbar*/
		if(mexCallMATLAB(1, wait_plhs, 2, wait_prhs, "waitbar"))
		{
		    printf("Could not create waitbar\n");
		    return;
		}

		/*Move the title array to third entry*/
		mxDestroyArray(wait_prhs[1]);
		wait_prhs[2]=mxCreateString(title);

		/*Use the second argument to hold the handle to waitbar figure*/
		wait_prhs[1]=wait_plhs[0];

	/*Scan the input file to determine the number of records*/
	    /*Skip the header (5 lines)*/
	    for (i=0; i<5; i++)
	    {
	        if (NULL==fgets(dummyCharBuffer, 1000, infile))
	        {
	            printf("eegread: Error skipping header\n");
	            return;
	        }
	    }

        /*Count the records*/
	    if(1!=freadLE((unsigned char *)&tstamp, sizeof(unsigned long), 1, infile) && !feof(infile))
	    {
	        printf("Failure to read tstamp\n");
	        return;
	    }
	    else if (feof(infile))
	    {
	        printf("No records found in this file\n");
	        return;
	    }
            if(1!=freadLE((unsigned char *)&numOfSamples, sizeof(int), 1, infile))
            {
                printf("Failure to read the number of samples\n");
                return;
            }
	    while(!feof(infile))
		{/*while(!feof(infile))*/

		    if (fseek(infile, (double) (numOfSamples*sizeof(short)), SEEK_CUR))
		    {
		        printf("Failure to skip data block\n");
		        return;
		    }

                    ++numOfRecords;

		    totalNumOfSamples+=(unsigned long)numOfSamples;

                    /*Update bar length*/
                    *double_pointer=(double)ftell(infile)/file_size/2;
		    if(mexCallMATLAB(0, NULL, 3, wait_prhs, "waitbar"))
		    {
			printf("Could not update waitbar\n");
			return;
		    }

 		    if(1!=freadLE((unsigned char *)&tstamp, sizeof(unsigned long), 1, infile) && !feof(infile))
		    {
		        printf("Failure to read tstamp\n");
		        return;
		    }
                    else if(!feof(infile))
                    {
                        if(fseek(infile, sizeof(int), SEEK_CUR))
                        {
                            printf("Failure to skip nsamples\n");
                            return;
                        }
                    }
		}/*while(!feof(infile))*/

	/*printf("There are %lu records and %lu sample points in file\n", numOfRecords, totalNumOfSamples);*/

	/*Create the output arrays*/
	T=mxCreateDoubleMatrix(totalNumOfSamples, 1, mxREAL);
        EEGV=mxCreateDoubleMatrix(totalNumOfSamples, 1, mxREAL);

        /*Create the array to hold short data for conversion to double*/
        shortBuffer=mxCalloc(numOfSamples, sizeof(short));

        /*get pointers to output data*/
        t_index=mxGetPr(T);
        eegv_index=mxGetPr(EEGV);

       /*Prepare the wait bar for new task*/
	*double_pointer=0; /*This still points to wait_prhs[0]*/
	/*Set new title to the third entry*/
        snprintf(title, 100, "Creating Output Vectors for %s", title_fname);
        mxDestroyArray(wait_prhs[2]);
	wait_prhs[2]=mxCreateString(title);

	/*Launch waitbar*/
	if(mexCallMATLAB(0, NULL, 3, wait_prhs, "waitbar"))
	{
	    printf("Could not create waitbar\n");
	    return;
	}

    /*Fill in the output vectors*/
    	rewind(infile);
        /*Skip the header (5 lines)*/
        for (i=0; i<5; i++)
        {
            if (NULL==fgets(dummyCharBuffer, 1000, infile))
            {
                printf("eegread: Error skipping header\n");
                return;
            }
        }

        /*Read and write data*/
        if(1!=freadLE((unsigned char *)&tstamp, sizeof(unsigned long), 1, infile) && !feof(infile))
        {
            printf("Failure to read tstamp\n");
            return;
        }
        else if (feof(infile))
        {
            printf("No records found in this file\n");
            return;
        }
        if(fseek(infile, sizeof(int), SEEK_CUR))
        {
                printf("Failure to skip nsamples\n");
                return;
        }
        numOfRecords=0;
        while(!feof(infile))
	{/*while(!feof(infile))*/

            if (numOfSamples!=freadLE((unsigned char *)shortBuffer, sizeof(short), numOfSamples, infile))
            {
		        printf("Failure to read eeg data\n");
		        return;
            }

            /*Store eeg data in the output matrix by converting into double*/
            for (i=0; i<numOfSamples; i++)
            {
            	*(eegv_index++)=(double)shortBuffer[i];
	        *(t_index++)=((double)tstamp+i*Delta)/1e4;
            }

           /*Update bar length*/
            *double_pointer=(double)ftell(infile)/file_size/2+0.5;
            if(mexCallMATLAB(0, NULL, 3, wait_prhs, "waitbar"))
	    {
	        printf("Could not update waitbar\n");
	        return;
	    }

            if(1!=freadLE((unsigned char *)&tstamp, sizeof(unsigned long), 1, infile) && !feof(infile))
            {
                printf("Failure to read tstamp\n");
                return;
            }
            else if(!feof(infile))
            {
                if(fseek(infile, sizeof(int), SEEK_CUR))
                {
                        printf("Failure to skip nsamples\n");
                        return;
                }
            }
	 }/*while(!feof(infile))*/


	/*Delete the waitbar value array*/
	mxDestroyArray(wait_prhs[0]);

	/*Delete the title array*/
	mxDestroyArray(wait_prhs[2]);

	/*We are done with the waitbar. Delete it*/
	if(mexCallMATLAB(0, NULL, 1, wait_plhs, "delete"))
	{
	    printf("Could not delete waitbar\n");
	    return;
	}

    mxFree(fname);
    return;

}/*mexFunction*/
