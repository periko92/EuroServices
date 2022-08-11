#include <stdio.h>
#include <string.h>
#include <netinet/in.h>

#define NUMNICKBASE     64
#define NUMNICKMAXCHAR 'z'

char convert2y[NUMNICKBASE] = {
  'A','B','C','D','E','F','G','H','I','J','K','L','M',
  'N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
  'a','b','c','d','e','f','g','h','i','j','k','l','m',
  'n','o','p','q','r','s','t','u','v','w','x','y','z',
  '0','1','2','3','4','5','6','7','8','9',
  '[',']'
};

unsigned char convert2n[NUMNICKMAXCHAR + 1] = {
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0,52,53,54,55,56,57,58,59,60,61, 0, 0,
  0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,
 15,16,17,18,19,20,21,22,23,24,25,62, 0,63, 0, 0, 0,26,27,28,
 29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,
 49,50,51
};



/*
 * TEA (cifrado)
 *
 * Cifra 64 bits de datos, usando clave de 64 bits (los 64 bits superiores son cero)
 * Se cifra v[0]^x[0], v[1]^x[1], para poder hacer CBC facilmente.
 *
 */
void tea(unsigned long v[],unsigned long k[],unsigned long x[])
{
    unsigned long y=v[0]^x[0],z=v[1]^x[1],sum=0,delta=0x9E3779B9;
    unsigned long a=k[0],b=k[1],n=32;
    unsigned long c=0,d=0;

    while(n-->0)
    {
        sum += delta;
        y += (z << 4)+a ^ z+sum ^ (z >> 5)+b;
        z += (y << 4)+c ^ y+sum ^ (y >> 5)+d;
    }

    x[0]=y; x[1]=z;
}

unsigned int base64toint(const char *str)
{
  register unsigned int i;
  i = convert2n[(unsigned char)str[5]];
  i += convert2n[(unsigned char)str[4]] << 6;
  i += convert2n[(unsigned char)str[3]] << 12;
  i += convert2n[(unsigned char)str[2]] << 18;
  i += convert2n[(unsigned char)str[1]] << 24;
  i += convert2n[(unsigned char)str[0]] << 30;
  return i;
}

const char *inttobase64(unsigned int i)
{
  static char base64buf[7];
  base64buf[0] = convert2y[(i >> 30) & 0x3f];
  base64buf[1] = convert2y[(i >> 24) & 0x3f];
  base64buf[2] = convert2y[(i >> 18) & 0x3f];
  base64buf[3] = convert2y[(i >> 12) & 0x3f];
  base64buf[4] = convert2y[(i >> 6) & 0x3f];
  base64buf[5] = convert2y[i & 0x3f];
  /* base64buf[6] = 0; (static is initialized 0) */
  return base64buf;
}



int main(int argc, char *argv[])
{
#define NICKLEN 9
    unsigned long v[2],k[2],x[2];
    int cont=(NICKLEN+8)/8;
    char tmpnick[8*((NICKLEN+8)/8)];
    char tmppass[12+1];
    unsigned long *p=(unsigned long *)tmpnick;

    if(argc!=3) {
        printf("Sintaxis: <nick> <clave>\n");
        return 1;
    }

    memset(tmpnick,0,sizeof(tmpnick));
    strncpy(tmpnick,argv[1],sizeof(tmpnick));

    memset(tmppass,0,sizeof(tmppass));
    strncpy(tmppass,argv[2],sizeof(tmppass));

    x[0]=x[1]=0;
    k[0]=base64toint(tmppass);
    k[1]=base64toint(tmppass+6);

    while(cont--) {
        v[0]=ntohl(*p++);
        v[1]=ntohl(*p++);
        tea(v,k,x);
    }

    printf("%s :%s", argv[1], inttobase64(x[0]));
    printf("%s\n", inttobase64(x[1]));

    return 0;
}

