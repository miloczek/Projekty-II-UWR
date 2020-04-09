#include<bits/stdc++.h>
using namespace std;
vector <int> edge[105][105];
bool conn[105];
int x, y, result;

bool BFS(int v){
    queue<int> q;
    q.push(x);
    int curr;
    memset(conn, 0, sizeof(conn));
    while (!q.empty())
    {
        curr = q.front();
        if(curr == y){
            return true;
        }
        q.pop();
        for(int i=0; i<edge[v][curr].size(); i++){
            int prev = edge[v][curr][i];
            if(conn[prev]){
                continue;
            }
            conn[prev] = 1;
            q.push(prev);
        }
    }
    return false;
}

int main(){
    int n, m;
    scanf("%d%d", &n, &m);
    int a, b , c;
    for(int i = 0; i<m; i++){
        scanf("%d%d%d",&a,&b,&c);
        edge[c][b].push_back(a);
        edge[c][a].push_back(b);
    }
    int q;
    scanf("%d", &q);
    for(int i=0; i<q; i++){
        result = 0;
        scanf("%d%d",&x,&y);
        for(int i = 0; i<m;i++){
            if(BFS(i+1)){
                result++;
            }
        }
        printf("%d\n", result);
    }
}