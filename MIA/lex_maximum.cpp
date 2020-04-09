#include <cstdio>
#include <iostream>
#include<string>


int main(){
    std::string input;
    getline(std::cin, input);
    std::string result("");
    int n = input.size() - 1;

    char curr = 'a';
    for(int i = n; i >= 0; i--){
        if(input[i] >= curr){
            result += input[i];
            curr = input[i];
        }
    }
    reverse(result.begin(), result.end());
    std::cout<<result<<std::endl;
    return 0;
}