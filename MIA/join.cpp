#include<cstdio>
#include<iostream>
#include<algorithm>
#include<cmath>
using namespace std;
typedef long long ll;
int m,n,tab1[111111],tab2[111111];
int main()
{
    while(~scanf("%d%d",&m,&n))
    {
        ll sum1=0,sum2=0;
        for(int i=0;i<m;i++){
            scanf("%d",&tab1[i]), sum1+=tab1[i];
        }
        for(int i=0;i<n;i++){
            scanf("%d",&tab2[i]), sum2+=tab2[i];
        }
        sort(tab1,tab1+m); 
        sort(tab2,tab2+n);
        ll ans1=sum2;
        ll ans2=sum1;
        for(int i=0;i<m-1;i++){
            ans1+=min(sum2,1ll*tab1[i]);
        }
        for(int i=0;i<n-1;i++){
            ans2+=min(sum1,1ll*tab2[i]);
        }
        printf("%I64d\n",min(ans1,ans2));
    }
    return 0;
}
