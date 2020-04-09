#include<iostream>
#include<string>

using namespace std;

int n;
long long x, m;

long long Nim_game(long long t){
    if(t % 4 == 1){
        return 1;
    }
    else if(t % 4 == 2){
        return t + 1;
    }
    else if(t % 4 == 3){
        return 0;
    }
    else{
        return t;
    }
}

int main(){
    cin>> n;
    long long result = 0;
    for (int i = 1; i<=n; i++){
        scanf("%lld%lld",&x,&m);
        long long u = Nim_game(x + m - 1);
        long long v = Nim_game(x-1);
        result ^= u ^ v;
    }
    if (result == 0){
          printf("bolik\n");
    }
    else{
        printf("tolik\n");
    }
    return 0;
}
 
 

