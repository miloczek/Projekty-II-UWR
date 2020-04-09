#include<map>
#include<iostream>
#include<vector>
using namespace std;
int n, m, helper, a, b;
vector<int> cats;
vector<vector<int>> paths;

int step(int curr, int history, int prev) {
    int counter, result;
    counter = result = 0;
    bool leaf = true;
    if(cats[curr] == 0) {
        counter = 0;
    } else {
        counter = history + cats[curr];
    }
    if(counter > m) {
        return 0;
    }
    for(int i = 0; i < paths[curr].size(); i++) {
        int to = paths[curr][i];
        if(to == prev) {
            continue;
        }
        leaf = false;
        result += step(to, counter, curr);
    }
    if(leaf) {
        return 1;
    }
    return result;
}

int main() {
    cin >> n >> m;
    for(int i = 0; i < n; i++) {
        cin >> helper;
        cats.push_back(helper);
        paths.push_back(vector<int>());
    }
    for(int i = 0; i < n - 1; i++) {
        cin >> a >> b;
        paths[a - 1].push_back(b - 1);
        paths[b - 1].push_back(a - 1);
    }
    cout << step(0, 0, -1) << endl;
    return 0;
}