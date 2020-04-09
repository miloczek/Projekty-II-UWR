
#include<stdio.h>
#include<string.h>

int main()
{
    char str[1001];
    int a[26];
    while(scanf("%s",str)!=EOF)
    {
        int result=0;
        memset(a,0,sizeof(a));
        for(int i=0;i < strlen(str);i++)
        {
            a[str[i]- 'a']++;
        }
        for(int i=0;i<26;i++)
        {
            if(a[i]%2!=0)
                result++;
        }
        if(result % 2!=0||result == 0)
            printf("First");
        else
            printf("Second");
    }

}