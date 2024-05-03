#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void fill(double* x, int n) {

    int i;
    for (i=0, n=n*n; i<n; i++, x++)
        *x = ((double) (1 + rand() % 12345)) / ((double) (1 + rand() % 6789));
}

void matrix_mult_index (int n, double* a, double* b, double* c) {
  int i, j, k;
  for (i=0; i<n; i++)
    for (j=0; j<n; j++) {
      c[i*n+j] =0;
      for(k = 0; k < n; k++)
        c[i*n+j] += a[i*n+k] * b[k*n+j];
    }
}

void matrix_mult_ptr_reg (int n, double* a, double* b, double* c) {
    register double cij;
    register double *at, *bt;
    register int i, j, k;
    for (i=0; i<n; i++, a+=n)
        for (j = 0; j < n; j++, c++) {
            cij = 0;
            for(k = 0, at = a, bt = &b[j]; k < n; k++, at++, bt+=n)
                cij += *at * *bt;
            *c = cij;
        }
}

void matrix_mult_ptr_no_reg (int n, double* a, double* b, double* c) {
    double cij;
    double *at, *bt;
    int i, j, k;
    for (i=0; i<n; i++, a+=n)
        for (j = 0; j < n; j++, c++) {
            cij = 0;
            for(k = 0, at = a, bt = &b[j]; k < n; k++, at++, bt+=n)
                cij += *at * *bt;
            *c = cij;
        }
}
void transpose (int n,double* b, double* b_transpose) {
    register double  *bt;
    register int i, j;
    for (i=0; i<n; i++, b++)
        for (j = 0 , bt = b; j < n; j++, b_transpose++ , bt+=n) {
            *b_transpose = *bt;
        }

}
void matrix_mult_transpose (int n, double* a, double* b, double* c) {
    double cij;
    register double *at, *bt , *bt2;
    register int i, j, k;
    for (i=0; i<n; i++, a+=n)
        for (j = 0 , bt = b; j < n; j++, c++ , bt+=n) {
            cij = 0;
            for(k = 0, at = a, bt2 = bt; k < n; k++, at++, bt2++)
                cij += *at * *bt2;
            *c = cij;
        }
}
void matrix_mult_block (int n,int block_size, double* a, double* b, double* c) {
    double cij;
    register double *at , *at2 , *at3 , *bt , *bt2 , *bt3  , *ct , *ct2;
    register int i, j, k , x , y , z;
    int N = n/block_size;
    for(i=0;i<n*n;i++){
        c[i] = 0;
    }
    for (i=0; i<N; i++,a+=(block_size*n) ){
        for (j = 0 , bt = b ; j<N; j++ , bt+=block_size,c+=block_size ) {
            //cij = 0;

            //print("c[%d][%d] = ",i,j);
            ct = c;

            for(k = 0 , at = a,bt2 = bt; k<N; k++ , at+=block_size , bt2+=(block_size*n)){
                    //*******************************************************************
                    //source address at & bt2
        for (x=0 , at2 = at; x<block_size; x++, at2+=n , ct+=n ){
                ct2 = ct;
            for (y = 0 ; y < block_size; y++,ct2++) {
            cij = 0;
            for(z = 0, at3 = at2, bt3 = &bt2[y]; z < block_size; z++, at3++, bt3+=n){
                cij += *at3 * *bt3;
                //printf("at2 = %f , bt3 = %f\n",*at3 , *bt3);
            }
            //printf("cij = %f\n",cij);
            //*(c+((x*block_size)+y)) += cij;
            c[(x * n)+y] += cij;

            //*ct2 += cij;
            //printf("i = %d , j = %d\n",i,j);
            //printf("x = %d , y = %d\n",x,y);


            //printf("ct2 = %f\n",c[(x * n)+y]);
            //printf("****************\n");

        }
        }

                    //*******************************************************************


            }

        }
        c+=(n*(block_size - 1));
    }

}


int main()
{
    clock_t t0, t1;
    int n, ref;

    do{
        printf("Input size of matrix, n = ");
        scanf("%d", &n);

        ref = 0;

        double *A  = (double*)_aligned_malloc(n * n * sizeof(double), 64 /*sizeof(double)*/); //  64 is cache line size
        double *B  = (double*)_aligned_malloc(n * n * sizeof(double), 64 /*sizeof(double)*/);
        double *C1 = (double*)_aligned_malloc(n * n * sizeof(double), 64 /*sizeof(double)*/);
        double *C2 = (double*)_aligned_malloc(n * n * sizeof(double), 64 /*sizeof(double)*/);
        double *B_transpose = (double*)_aligned_malloc(n * n * sizeof(double), sizeof(double));

        if(A == NULL || B == NULL || C1 == NULL || C2 == NULL){
            printf("Memory Allocation Error\n\n");
            return(-1);
        }

        unsigned int seed = time(NULL);
        printf("\nseed = %u\n", seed);

        srand(seed);
        fill(A, n);
        fill(B, n);

        fflush(stdin);
        printf("\n\nDo you want to run matrix_mult_index (y/n)? ");
        if(getchar() == 'y'){
            ref = 1;
            t0 = clock();
            matrix_mult_index(n, A, B, C1);
            t1 = clock();
            printf("\n\t\t\tExecution time of matrix_mult_index = %0.2f s", (float)(t1-t0)/CLOCKS_PER_SEC);
        }

        fflush(stdin);
        printf("\n\nDo you want to run matrix_mult_ptr_reg (y/n)? ");
        if(getchar() == 'y'){
            ref++;
            t0 = clock();
            matrix_mult_ptr_reg(n, A, B, ref == 1 ? C1 : C2);
            t1 = clock();
            printf("\n\t\t\tExecution time of matrix_mult_ptr_reg = %0.2f s\n", (float)(t1-t0)/CLOCKS_PER_SEC);
        }

        fflush(stdin);
        printf("\n\nDo you want to run matrix_mult_ptr_no_reg (y/n)? ");
        if(getchar() == 'y'){
            if(++ref > 2) ref = 2;
            t0 = clock();
            matrix_mult_ptr_no_reg(n, A, B, ref == 1 ? C1 : C2);
            t1 = clock();
            printf("\n\t\t\tExecution time of matrix_mult_ptr_no_reg = %0.2f s", (float)(t1-t0)/CLOCKS_PER_SEC);
        }

        fflush(stdin);
        printf("\n\nDo you want to run matrix_mult_transpose (y/n)? ");
        if(getchar() == 'y'){
            if(++ref > 2) ref = 2;
            t0 = clock();
            transpose(n,B,B_transpose);
            matrix_mult_transpose(n, A, B_transpose, ref == 1 ? C1 : C2);
            t1 = clock();
            printf("\n\t\t\tExecution time of matrix_mult_transpose = %0.2f s", (float)(t1-t0)/CLOCKS_PER_SEC);
        }


        fflush(stdin);
        printf("\n\nDo you want to run matrix_mult_block (y/n)? ");
        if(getchar() == 'y'){
            if(++ref > 2) ref = 2;

            int block_size;
            printf("\n\tInput size of block = ");
            scanf("%d", &block_size);

            t0 = clock();
            matrix_mult_block(n, block_size, A, B, ref == 1 ? C1 : C2);
            t1 = clock();
            printf("\n\t\t\tExecution time of matrix_mult_block = %0.2f s", (float)(t1-t0)/CLOCKS_PER_SEC);
        }



        printf("\n\n\nEnd Of Execution\n\n");

        if(ref == 2){
            int i;
            double *c1, *c2;
            printf("\n\nStart of Compare: ");
            for(i=0, c1=C1, c2=C2, n=n*n; i<n; i++, c1++, c2++){
//              if(*c1 != *c2)
                if(abs((*c1 - *c2) / *c1) > 1E-10)
                    break;
                if(i % (n/20) == 0)
                    printf(".");
            }

            if(i != n)
                printf(" Ooops, Error Found @ %d: %0.3f vs %0.3f\n\n",i, *c1, *c2);
            else
                printf(" OK, OK, Matrixes are equivalent.\n\n");
        }
        else
            printf("\n\nNo Compare due to No Reference or No Data.\n\n");

        _aligned_free(A);
        _aligned_free(B);
        _aligned_free(C1);
        _aligned_free(C2);

        fflush(stdin);
        printf("\n\nDo you want to continue (y/n)? ");

    } while(getchar() == 'y');

    return 0;
}
