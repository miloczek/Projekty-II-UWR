#include <iostream>
using namespace std;
const long long MOD = 1000000007;

int main(){
    int n;
    cin>>n;
    int options[2],result;
    result = 0;
    options[0] = options[1] = 0;
    for(int i = 0,p = 0;i < n;++i,p ^= 1){
        int current = 1 + options[p ^ 1];
        result += current;
        if(result >= MOD){
            result -= MOD;
        }
        options[p] += current;
        if(options[p] >= MOD){
            options[p] -= MOD;
        }
    }
    cout<<result;
    return 0;
}