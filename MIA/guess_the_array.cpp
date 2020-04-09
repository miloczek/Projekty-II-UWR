#include<stdio.h>
using namespace std;

int main(){
    int n;
    scanf("%d", &n);
    int arry[n+1];
    for (int i=1; i<n; i++){
        printf("? 1 %d\n", i+1);
        fflush(stdout);
        scanf("%d", &arry[i]);
    }
    printf("? 2 3\n");
    int helper, first;
    fflush(stdout);
    scanf("%d", &helper);
    first = (arry[1] + arry[2] - helper);
    first /= 2;
    printf("! %d", first);
    fflush(stdout);
    for(int i=1; i<n; i++){
        printf(" %d", arry[i]-first);
        fflush(stdout);
    }
    printf("\n");
    fflush(stdout);
}