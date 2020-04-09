#include<cstdio>
#include<map>
#include<algorithm>
#include<cstring>
#include<iostream>

using namespace std;
map<long long, long long> m;

void add(long long x, long long y){
    if (m.find(x) == m.end()) m[x] = 0;
    m[x] += y;
}

long long value(long long x){
    if(m.find(x) == m.end()) return 0;
    return m[x];
}

int main(){
    int n;
    cin>>n;
    while (n--){
        int current;
        cin>>current;
        if(current == 1){
            long long u, v, w;
            cin>>u>>v>>w;
            while (u != v){
                if(u>v){
                    add(u,w);
                    u>>=1;
                }
                else{
                    add(v,w);
                    v>>=1;
                }   
            }  
        }
        else{
            long long u, v, result = 0;
            cin>>u>>v;
            while (v!=u){
                if(u>v){
                    result += value(u);
                    u>>=1;
                }
                else{
                    result += value(v);
                    v>>=1;
                }
            }
            cout<<result<<endl;   
        }
    }
    return 0;
}