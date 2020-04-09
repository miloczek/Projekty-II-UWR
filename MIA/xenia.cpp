#include <iostream>
#include <cstring>
using namespace std;

const int N = 1 << 19;
struct Tree{
    int left, right;
    int val;
};
Tree tree[N];

void build(int l ,int r, int i){
    tree[i].left = l;
    tree[i].right = r;
    tree[i].val = 0;
    if(l == r){
        return;
    }
    int middle = (l + r) >> 1;
    build(l, middle, 2 * i);
    build(middle + 1, r, (2 * i) + 1);
}

void insert(int l, int r, int i, int x, int current){
    if(l == tree[i].left && r == tree[i].right){
        tree[i].val = x;
        return;
    }
    int middle = (tree[i].left + tree[i].right) >> 1;
    if(r <= middle){
        insert(l, r, 2 * i, x, current - 1);
    }
    else{
        insert(l, r, (2 * i) + 1, x, current - 1);
    }
    if (current % 2 == 0){
        tree[i].val = tree[2 * i].val | tree[(2 * i) + 1].val;
    }
    else{
        tree[i].val = tree[2 * i].val ^ tree[(2 * i) + 1].val;
    }
}

int main(){
    ios::sync_with_stdio(false);
    int n, m;
    cin>>n>>m;
    int number = 1 << n;
    build(1, number, 1);
    for(int i = 1; i <= number; i++){
        int x;
        cin>>x;
        insert(i, i, 1, x, n + 1);
    }
    while (m--){
        int a, b;
        cin>>a>>b;
        insert(a, a, 1, b, n + 1);
        cout << tree[1].val << endl;
    }
    return 0;
}