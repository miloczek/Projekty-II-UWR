#include <cstdio>
#include <vector>
#include <set>
using namespace std;
 
void dfs(long curr, long prev, const vector<vector<long>> &g, set<long> &s, const vector<int> &d, int depth, int odd, int even){
 
    int factor = ((depth % 2) & odd) || (((depth + 1) % 2) && even);
 
    if(d[curr] ^ factor){
 
        s.insert(curr); 
 
        if(depth & 1){
            odd = 1 - odd;
        } 
 
        else{
            even = 1 - even;
        }
    }
 
    for(long i = 0; i < g[curr].size(); i++){
 
        long u = g[curr][i];
 
        if(u == prev){
            continue;
        }
        dfs(u, curr, g, s, d, (depth + 1) % 2, odd, even);
    }
 
    return;
}
 
int main(){
    long n; 
    scanf("%ld", &n);
    vector<vector<long>> g(n);
    vector<int> t1(n); 
    vector<int> t2(n); 
    vector<int> w(n);
    set<long> result;
 
    for(long i = 1; i < n; i++){
        long a, b; scanf("%ld %ld", &a, &b);
        g[a-1].push_back(b-1); 
        g[b-1].push_back(a-1);
    }
 
    for(long i = 0; i < n; i++){
        scanf("%d", &t1[i]);
    }
   
    for(long i = 0; i < n; i++){
        scanf("%d", &t2[i]);
    }
 
    for(long i = 0; i < n; i++){
        w[i] = t1[i] ^ t2[i];
    }
 
    dfs(0, 0, g, result, w, 0, 0, 0);
 
    printf("%ld\n", result.size());
    for(set<long>::iterator it = result.begin(); it != result.end(); it++){
        printf("%ld\n", 1 + (*it));
    }
 
    return 0;
}