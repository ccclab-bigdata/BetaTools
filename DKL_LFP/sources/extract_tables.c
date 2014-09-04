/*
*
*writemat.c - Create a binary MAT file.
*Murat Okatan
* mex -f d:\matlab6p1\bin\win32\mexopts\lccengmatopts.bat filename
* mex -f /usr/local/matlab6p1/bin/matopts.sh    filename
*
*/

/* version 4. Added a function to make sure data are read as little-endian on all
    platforms.
   version 3. Add offsets to behavior flag table
   version 2. Add behavior flags */

#include "mat.h"
#include <stdio.h>
#include <assert.h>
#include <math.h>

#define BFLAG_INSTEAD_OF_PORT   100

int makemat(const char *filename,
            double *data, int m, int n,
            char *mmstr)
{/*makemat*/

    MATFile *mfile;
    mxArray *mdata;
    
    /*Open the MAT file for writing. */
    mfile=matOpen(filename, "u");
    if (mfile==NULL)
        mfile=matOpen(filename, "w");
    if (mfile==NULL)
    {
        printf("Cannot open %s for writing.\n", filename);
        return(EXIT_FAILURE);
    }
    
    /*Create the mxArray to hold the numeric data*/
    mdata=mxCreateDoubleMatrix(n,m,mxREAL);
    mxSetName(mdata, mmstr);
    
    /*Copy the data to mxArray*/
    memcpy((void *)(mxGetData(mdata)), (void *) data, m*n*sizeof(double));
    
    /*write the mxArrays to the MAT file*/
/*    matPutArray(mfile, mdata);*/
    matPutArrayAsGlobal(mfile, mdata);

    /*Free the mxAray memory*/
    mxDestroyArray(mdata);
    
    /*Close the MAT file*/
    if (matClose(mfile) != 0)
    {
        printf("Cannot close %s.\n", filename);
        return(EXIT_FAILURE);
    }
    
    return(EXIT_SUCCESS);

}/*makemat*/


/*Function to read LittleEndian data*/
int freadLE(unsigned char *buffer, int nbytes_per_sample, int nsamples, FILE *infile)
{/*freadLE*/
    int i, count=0;
    register unsigned long dummy_ulong;
    
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
         default:
            printf("Unknown data size in extract_tables:freadLE\n");
            break;
    }/*Switch*/
    
    return count;
}/*freadLE*/

int main(int argc, char* argv[])
{/*main*/
    int status, sizeof_ElectrodeData=324, sizeof_EventInfo=208, count;
    int imrow, imcol;
    FILE *infile;
    double buffersamp, frame_counter=0, fullImageCounter=0, bflag_counter=0;
    double px, py, radial_distance, tooManyBrightsCounter=0;
    long data_start_offset;
    unsigned char datatype, *dummyUCharPtr;
    unsigned long bufferinfo[5];
    int bright_num_thresh;
    double *posTooManyBritePixIndx;
    double *positionFullImageOffsets;
    double *positionNavigationTable;
    double *behaviorFlagTable;
    double *dummyPtr1, *dummyPtr2, *dummyPtr3, *dummyPtr4;
    double offset;
    
    if (argc>=6)
    {
        infile=fopen(argv[1], "rb");
        if (infile==NULL)
        {
            printf("Unable to open file %s\n", argv[1]);
            exit(EXIT_FAILURE);
        }
    }
    else
    {
        printf("writemat <file name> <buffersamp> <data start offset> <image_row> <image_col>\n");
        exit(EXIT_FAILURE);
    }

	buffersamp=atol(argv[2]);
	data_start_offset=atol(argv[3]);
	bright_num_thresh=atoi(argv[4]);
	imrow=atoi(argv[5]);
	imcol=atoi(argv[6]);
	fseek(infile, data_start_offset, SEEK_SET);

	/*Now the file pointer is at the beginning of the first data record*/
	
	/*find the number of elements in the tables we want to create*/

	count=fread(&datatype, sizeof(unsigned char), 1, infile);
	assert(count==1);
	while(!feof(infile))
	{
		switch (datatype)
		{/*switch*/
			case 's':
/*			    printf("s\n");*/
                count=freadLE((unsigned char *)bufferinfo, 4, 3, infile);
                assert(count==3);
                fseek(infile, bufferinfo[2]*sizeof_ElectrodeData, SEEK_CUR);
                break;
            case 'c':
/*			    printf("c\n");*/
                count=freadLE((unsigned char *)bufferinfo, 4, 3, infile);
                assert(count==3);
                fseek(infile, buffersamp*2, SEEK_CUR);
                break;
			case 'p':
/*			    printf("p\n");*/
                count=freadLE((unsigned char *)bufferinfo, 4, 5, infile);
                assert(count==5);

                if (bufferinfo[2]!=2*imcol*imrow)
                    fseek(infile, bufferinfo[2]*2, SEEK_CUR);
                else
                    ++fullImageCounter;
                    
                fseek(infile, bufferinfo[3], SEEK_CUR);
                
			    ++frame_counter;

                px=bufferinfo[4]%imcol+1;
    	        py=imrow-floor(bufferinfo[4]/(double)imcol);
                radial_distance=sqrt(pow(px-154, 2)+pow(py-116, 2));
                if(bufferinfo[1]>bright_num_thresh && radial_distance<=70)
                    ++tooManyBrightsCounter;
                break;
			case 'b':
/*			    printf("b\n");*/
                count=freadLE((unsigned char *)bufferinfo, 4, 3, infile);
                assert(count==3);

                if(*(bufferinfo+1)==(unsigned long)BFLAG_INSTEAD_OF_PORT)
                    ++bflag_counter;
                break;
			case 'e':
/*			    printf("e\n");*/
                fseek(infile, sizeof_EventInfo, SEEK_CUR);
                break;
            default:
                printf("Unknown datatype\n");
                break;
		}/*switch*/
		count=fread(&datatype, 1, 1, infile);
		assert(count==1);
	}/*while*/

    /*At this point we have the sizes of the arrays that we will be creating*/
    posTooManyBritePixIndx=(double *)calloc(tooManyBrightsCounter, sizeof(double));
    positionFullImageOffsets=(double *)calloc(fullImageCounter,sizeof(double));
    positionNavigationTable=(double *)calloc(frame_counter*4, sizeof(double));
	behaviorFlagTable=(double *)calloc(bflag_counter*3, sizeof(double));
    
    /*rewind to the data start    */
	fseek(infile, data_start_offset, SEEK_SET);
    
    frame_counter=0;
    dummyPtr1=positionNavigationTable;
    dummyPtr2=posTooManyBritePixIndx;
    dummyPtr3=positionFullImageOffsets;
    dummyPtr4=behaviorFlagTable;
	
    /*Fill the tables*/
	count=fread(&datatype, sizeof(unsigned char), 1, infile);
	assert(count==1);
	while(!feof(infile))
	{
		switch (datatype)
		{/*switch*/
			case 's':
/*			    printf("s\n");*/
                count=freadLE((unsigned char *)bufferinfo, 4, 3, infile);
                assert(count==3);
                fseek(infile, bufferinfo[2]*sizeof_ElectrodeData, SEEK_CUR);
                break;
            case 'c':
/*			    printf("c\n");*/
                count=freadLE((unsigned char *)bufferinfo, 4, 3, infile);
                assert(count==3);
                fseek(infile, buffersamp*2, SEEK_CUR);
                break;
			case 'p':
/*			    printf("p\n");*/
                offset=ftell(infile);
                count=freadLE((unsigned char *)bufferinfo, 4, 5, infile);
                assert(count==5);
            
                px=bufferinfo[4]%imcol+1;
    	        py=imrow-floor(bufferinfo[4]/(double)imcol);
                radial_distance=sqrt(pow(px-154, 2)+pow(py-116, 2));
                if(bufferinfo[1]>bright_num_thresh && radial_distance<=70)
                {
                    *(dummyPtr2++)=frame_counter+1;
                }

                *(dummyPtr1++)=(double)bufferinfo[0];
                *(dummyPtr1++)=offset;
                *(dummyPtr1++)=px;
                *(dummyPtr1++)=py;

                if (bufferinfo[2]!=2*imcol*imrow)
                    fseek(infile, bufferinfo[2]*2, SEEK_CUR);
                else
                {
                    *(dummyPtr3++)=offset;
                }
                    
                fseek(infile, bufferinfo[3], SEEK_CUR);
                
			    ++frame_counter;
                break;
			case 'b':
/*			    printf("b\n");*/
                offset=ftell(infile);
                count=freadLE((unsigned char *)bufferinfo, 4, 3, infile);
                assert(count==3);
                if(*(bufferinfo+1)!=(unsigned long)BFLAG_INSTEAD_OF_PORT)
                    break;
                
                *(dummyPtr4++)=(double)*bufferinfo; /*tstamp*/
                *(dummyPtr4++)=(double)(bufferinfo[2]); /*Behavior Flag Composite Index*/
                *(dummyPtr4++)=offset; /*Offset in file*/
                break;
			case 'e':
/*			    printf("e\n");*/
                fseek(infile, sizeof_EventInfo, SEEK_CUR);
                break;
            default:
                break;
		}/*switch*/
		count=fread(&datatype, 1, 1, infile);
		assert(count==1);
	}/*while*/
    
    fclose(infile);

    status=makemat("MegaEdit_Tables.mat", posTooManyBritePixIndx, tooManyBrightsCounter, 1, "posTooManyBritePixIndx");
    status=makemat("MegaEdit_Tables.mat", positionFullImageOffsets, fullImageCounter, 1, "positionFullImageOffsets");
    status=makemat("MegaEdit_Tables.mat", positionNavigationTable, frame_counter, 4, "positionNavigationTable");
    status=makemat("MegaEdit_Tables.mat", behaviorFlagTable, bflag_counter, 3, "behaviorFlagTable");
    
    free(posTooManyBritePixIndx);
    free(positionFullImageOffsets);
    free(positionNavigationTable);
    free(behaviorFlagTable);
    
    return(status);
}/*main*/
