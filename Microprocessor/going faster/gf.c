#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

void fill(double* x, int n) {

    int i;
    for (i=0, n=n*n; i<n; i++, x++)
        *x = ((double) (1 + rand() % 12345)) / ((double) (1 + rand() % 6789));
}

void matrix_mult_0 (int n, double* a, double* b, double* c) {
  int i, j, k;
  for (i=0; i<n; i++)
    for (j=0; j<n; j++) {
      c[i*n+j] =0;
      for(k = 0; k < n; k++)
        c[i*n+j] += a[i*n+k] * b[k*n+j];
    }
}
void matrix_mult_1(int n, double* a,double* b,double* c){
    int i,j,k;
    double *at,*bt;
    for(i=0; i<n; i++, a+=n){
        for(j=0; j<n;j++,c++){
            *c = 0;
            for(k=0,at = a,bt = &b[j];k<n;k++, at++, bt+=n)
                *c += *at * *bt;
        }
    }


}

void matrix_mult_2 (int n, double* a, double* b, double* c) {
    double cij;
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
void transpose (int n,double* b, double* b_transpose) {
    register double  *bt;
    register int i, j;
    for (i=0; i<n; i++, b++)
        for (j = 0 , bt = b; j < n; j++, b_transpose++ , bt+=n) {
            *b_transpose = *bt;
        }

}
void matrix_mult_3 (int n, double* a, double* b, double* c) {
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
void matrix_mult_4 (int n,int block_size, double* a, double* b, double* c) {
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
    int n;

    printf("Input size of matrix, n = ");
    scanf("%d", &n);

   double *A  = (double*)_aligned_malloc(n * n * sizeof(double), sizeof(double));
   double *B  = (double*)_aligned_malloc(n * n * sizeof(double), sizeof(double));
   double *B_transpose = (double*)_aligned_malloc(n * n * sizeof(double), sizeof(double));
   double *C1 = (double*)_aligned_malloc(n * n * sizeof(double), sizeof(double));
   double *C2 = (double*)_aligned_malloc(n * n * sizeof(double), sizeof(double));

    if(A == NULL || B == NULL || C1 == NULL || C2 == NULL){
        printf("Memory Allocation Error\n\n");
        return(-1);
    }

    srand(time(NULL));
    fill(A, n);
    fill(B, n);

    clock_t t0 = clock();
    matrix_mult_0(n, A, B, C1);
    clock_t t1 = clock();
    printf("\nExecution time of matrix_mult_0 = %0.3f s \n", (float)(t1-t0)/CLOCKS_PER_SEC);


    //t0 = clock();
    //matrix_mult_1(n, A, B, C2);
    //t1 = clock();
    //printf("\nExecution time of matrix_mult_1 = %0.3f s \n\n", (float)(t1-t0)/CLOCKS_PER_SEC);

    //t0 = clock();
    //matrix_mult_2(n, A, B, C2);
    //t1 = clock();
    //printf("\nExecution time of matrix_mult_2 = %0.3f s \n\n", (float)(t1-t0)/CLOCKS_PER_SEC);
    t0 = clock();
    transpose(n,B,B_transpose);
    matrix_mult_3(n, A, B_transpose, C2);
    transpose(n,B_transpose,B);
    t1 = clock();
    printf("\nExecution time of matrix_mult_3 = %0.3f s \n\n", (float)(t1-t0)/CLOCKS_PER_SEC);
    t0 = clock();
    matrix_mult_4(n,128, A, B, C2);
    t1 = clock();
    printf("\nExecution time of matrix_mult_4 = %0.3f s \n\n", (float)(t1-t0)/CLOCKS_PER_SEC);


    printf("End Of Execution\n\n\n\nStart of Compare: ");

    int i;
    for(i = 0, n = n * n; i < n; i++){
        if(abs(C1[i] - C2[i] )> 0.001 )
            break;
        if(i % (n/20) == 0)
            printf(".");
    }

    if(i != n)
        printf(" Ooops, Error Found @ %d: %f vs %f\n\n",i, C1[i], C2[i]);
    else
        printf(" OK, OK, Matrixes are equivalent.\n\n");

        _aligned_free(A);
        _aligned_free(B);
        _aligned_free(C1);
        _aligned_free(C2);

    return 0;
}
