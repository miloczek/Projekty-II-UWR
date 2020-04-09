#include <stdio.h>
#include <string.h>
#include <iostream>
using namespace std;

int n, m, k;
unsigned long long arry[5001], dp[5001][5001];

unsigned long long take_max(unsigned long long x, unsigned long long y){
    if(x >= y){
        return x;
    }
    else{
        return y;
    }   
}
unsigned long long call(unsigned long long i, unsigned long long cnt){

    if(dp[i][cnt]!=-1)
        return dp[i][cnt];

    if(i>(n-m) || cnt>=k)
        return 0;

    unsigned long long opt1=0, opt2=0;

    for(unsigned long long v=i; v<i+m; v++){
        opt1+=arry[v];
    }

    opt1= opt1+call(i+m, cnt+1);
    opt2= call(i+1, cnt);
    return dp[i][cnt]= take_max(opt1,opt2);
}
int main(){
    cin>> n>> m>> k;
    memset(dp, -1, sizeof dp);
    for(unsigned long long i=0;i<n;i++)
        cin>>arry[i];

    cout<< call(0,0) <<endl;
}