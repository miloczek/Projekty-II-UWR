#include<iostream>
using namespace std;
int main(){
    char result[5];
    int primes[19] = {2,3,4,5,7,9,11,13,17,19,23,25,29,31,37,41,43,47,49};
    int counter=0;
    for(int i = 0; i<19; i++){
        cout<< primes[i]<< endl;
        fflush(stdout);
        cin>>result;
        if(result[1] == 'e'){
            counter++;
        }
    }
    if(counter>1){
        cout<<"composite";
		fflush(stdout);
    }
    else
    {
        cout<<"prime";
		fflush(stdout);
    }
    
}