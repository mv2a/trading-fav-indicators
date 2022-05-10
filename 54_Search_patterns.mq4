//+------------------------------------------------------------------+
//|                                              Search_patterns.mq4 |
//|                                                            Talex |
//|                                                 tan@gazinter.net |
//+------------------------------------------------------------------+
#property copyright "Talex"
#property link      "tan@gazinter.net"
#property stacksize 16384
//----
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 CLR_NONE
#import "user32.dll"
int GetClientRect(int hWnd,int &lpRect[]);
#import
extern bool FuturePattern=false; /* true - ���� ������������� ��������, �.�. ����� ���������� ������� �� �������� �� ���������� ��������, ��� "�����������" ������������� ��������� ;) */
extern bool ExtSave=false; /* ���� true, �� ���������� ����� ��������� �� ������� */
extern int ExtDepth=0; /* �������� ��� ZZ,���� 0, �� ����� ���� ����� ���������, ����� ��������� �������(���� �� ����) � ��������� ���������� Depth */
extern int ExtPoint=5; /* ���������� ����� �������, ���� ������ ������ 5, �� ����� ������������ �������� �� ������� (���� ��� ����) */
extern int minDepth=3; /* �������� ��� ������ ��������� */
extern int maxDepth=50;/* �������� ��� ������ ��������� */
/*extern*/ int ExtIndicator=0; /* ���������� ��������, ������� ����� ������ ����� ��� ���������� �������� */
extern double ExtDopusk=0.05; /* ��������� �������� ����� ���������� �� ����� ��� �������� ExtDopusk */
extern double TimeDopusk=0.2; /*��������� �������� �� ������� ����� ���������� �� ����� ��� �������� TimeDopusk */
extern bool Gartley=true; /* true - ���� �������� ������, false - ��� */
extern bool Pattern_50=true; /* true - ���� ������� 5-0, false - ��� */
extern bool ABCD=true; /* true - ���� ������� AB=CD, false - ��� */
extern bool WolfWaves=false; /* true - ���� ������� WW, false - ��� */
extern bool SweetZoneStart=true; /* true - ���������� �������� ������ ��������� WW � ������� ������ ������� �.5, false - ��� */
extern bool SweetZoneEnd=true; /* true - ���������� �������� ��������� WW � ������� ������ ������� �.6, false - ��� */
extern color SZScolor=Blue; /* ���� ��� SweetZoneStart */
extern color SZEcolor=DarkGreen; /* ���� ��� SweetZoneEnd */
extern color ExtColorGartley=MidnightBlue; /* ���� ��� ��������� ������ */
extern color ExtColorRet=Lime; /* ���� ����� ������������� */
//extern bool AlertPattern=false; /* ��� ��������� �������� ����������� �����, ���� �� �������� */
static int endbar=0;
static double endpr=0;
static bool fl;
string com1="",com2="",com3="",com4="",com5="",com6="",com7="",com8="",com9="";
string save="";
static int GPixels,VPixels;
int rect[4],hwnd;
//---- indicator buffers
double zz[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(1);
   SetIndexBuffer(0,zz);
   SetIndexStyle(0,DRAW_SECTION);
   SetIndexEmptyValue(0,0.0);
//
   hwnd=WindowHandle(Symbol(),Period());
   if(hwnd>0) GetClientRect(hwnd,rect);
   GPixels=rect[2]; // ����� ������� ���������� ���-�� �������� �� �����������
   VPixels=rect[3]; // ����� ������� ���������� ���-�� �������� �� ���������
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   string NamePattern[7]={"Gartley","Butterfly","Crab","Bat","Pattern_5-0","AB=CD","WolfeWaves"};
//GetClientRect(hwnd,rect);
   Comment("");
   for(int b=0;b<7;b++)
     {
      for(int k=0;k<=maxDepth;k++)
        {
         ObjectDelete("RealTargetD_"+NamePattern[b]+(string)k);
         ObjectDelete("RealTextTargetD_"+NamePattern[b]+(string)k);
         ObjectDelete("RealFiboTarget_"+NamePattern[b]+(string)k);
         ObjectDelete("Real1_"+NamePattern[b]+(string)k);
         ObjectDelete("Real2_"+NamePattern[b]+(string)k);
         ObjectDelete("Real3_"+NamePattern[b]+(string)k);
         ObjectDelete("RealRetXB_"+NamePattern[b]+(string)k);
         ObjectDelete("RealRetAC_"+NamePattern[b]+(string)k);
         ObjectDelete("RealRetBD_"+NamePattern[b]+(string)k);
         ObjectDelete("RealRetXD_"+NamePattern[b]+(string)k);
         ObjectDelete("RealTextRetXB_"+NamePattern[b]+(string)k);
         ObjectDelete("RealTextRetAC_"+NamePattern[b]+(string)k);
         ObjectDelete("RealTextRetBD_"+NamePattern[b]+(string)k);
         ObjectDelete("RealTextRetXD_"+NamePattern[b]+(string)k);
         ObjectDelete("RealLineXA_"+NamePattern[b]+(string)k);
         ObjectDelete("RealLineAB_"+NamePattern[b]+(string)k);
         ObjectDelete("RealLineBC_"+NamePattern[b]+(string)k);
         ObjectDelete("RealLineCD_"+NamePattern[b]+(string)k);
         ObjectDelete("Future1_"+NamePattern[b]+(string)k);
         ObjectDelete("Future2_"+NamePattern[b]+(string)k);
         ObjectDelete("Future3_"+NamePattern[b]+(string)k);
         ObjectDelete("FutureTargetC_"+NamePattern[b]+(string)k);
         ObjectDelete("FutureTextTargetC_"+NamePattern[b]+(string)k);
         ObjectDelete("FutureMinTargetD_"+NamePattern[b]+(string)k);
         ObjectDelete("FutureTextMinTargetD_"+NamePattern[b]+(string)k);
         ObjectDelete("FutureMaxTargetD_"+NamePattern[b]+(string)k);
         ObjectDelete("FutureTextMaxTargetD_"+NamePattern[b]+(string)k);
         ObjectDelete("FutureRetXB_"+NamePattern[b]+(string)k);
         ObjectDelete("FutureTextRetXB_"+NamePattern[b]+(string)k);
         ObjectDelete("FutureRetAC_"+NamePattern[b]+(string)k);
         ObjectDelete("FutureTextRetAC_"+NamePattern[b]+(string)k);
        }
     }
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int PP[];
   int i,j,n,X,A,B,C,D;
   if(ExtSave==true)
     {
      save=TimeToStr(TimeLocal(),TIME_DATE|TIME_SECONDS);
     }
   if(ExtDepth==0){}else {minDepth=ExtDepth;maxDepth=ExtDepth;}
   for(n=minDepth;n<=maxDepth;n++)
     {
      switch(ExtIndicator)
        {
         case 0: {ZZTalex(n);   break;}
/* ����� ����� ��������� ������� �� ������� ����� ��������� */
         default:{ZZTalex(n);   break;}
        }
      ArrayResize(PP,ExtPoint);
      if(ExtIndicator==0)
        {
         for(i=0,j=0;i<Bars-1 && j<=ExtPoint;i++)
           {
            if(zz[i]!=0)
              {
               PP[j]=i;
               j++;
              }
           }
        }
/* if(ExtIndicator!=0)
  {
   for(i=Bars-1;i>=0;i--)
   {
    if(zz[i]!=0)
    {
     for(n=ExtPoint-1;n>=1;n--)
     {
      PP[n]=PP[n-1];
     }
      PP[0]=i;
    }
   }
  }*/
      if(Gartley)
        {
         X=PP[ExtPoint-1];A=PP[ExtPoint-2];B=PP[ExtPoint-3];C=PP[ExtPoint-4];D=PP[ExtPoint-5];
         GartleyPatternsSearch(X,A,B,C,D,n);
        }
      if(Pattern_50)
        {
         X=PP[ExtPoint-1];A=PP[ExtPoint-2];B=PP[ExtPoint-3];C=PP[ExtPoint-4];D=PP[ExtPoint-5];
         Patterns50Search(X,A,B,C,D,n);
        }
      if(ABCD)
        {
         A=PP[ExtPoint-2];B=PP[ExtPoint-3];C=PP[ExtPoint-4];D=PP[ExtPoint-5];
         ABCDSearch(A,B,C,D,n);
        }
      if(WolfWaves)
        {
         X=PP[ExtPoint-1];A=PP[ExtPoint-2];B=PP[ExtPoint-3];C=PP[ExtPoint-4];D=PP[ExtPoint-5];
         WolfWavesSearch(X,A,B,C,D,n);
        }
     }
/*switch (ExtIndicator)
     {
      case 0: {ZZTalex(ExtDepth);   break;}
      default:{ZZTalex(ExtDepth);   break;}
     }*/
   CorrectObject();
   Commentarii();
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*------------------------------------------------------------------+
|  ZigZag_Talex, ���� ����� �������� �� �������. ���������� �����   |
|  �������� ������� ���������� ExtPoint.                            |
+------------------------------------------------------------------*/
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ZZTalex(int n)
  {
/*����������*/
   int    i,j,k,zzbarlow,zzbarhigh,curbar=0,curbar1,curbar2,EP,Mbar[];
   double curpr=0,Mprice[];
   bool flag,fd;
/*������*/
   for(i=0;i<=Bars-1;i++)
     {zz[i]=0.0;}
//----   
   EP=ExtPoint;
   zzbarlow=iLowest(NULL,0,MODE_LOW,n,0);
   zzbarhigh=iHighest(NULL,0,MODE_HIGH,n,0);
//----
   if(zzbarlow<zzbarhigh) {curbar=zzbarlow; curpr=Low[zzbarlow];}
   if(zzbarlow>zzbarhigh) {curbar=zzbarhigh; curpr=High[zzbarhigh];}
   if(zzbarlow==zzbarhigh){curbar=zzbarlow;curpr=funk1(zzbarlow, n);}
//----
   ArrayResize(Mbar,ExtPoint);
   ArrayResize(Mprice,ExtPoint);
   j=0;
   endpr=curpr;
   endbar=curbar;
   Mbar[j]=curbar;
   Mprice[j]=curpr;
   EP--;
   if(curpr==Low[curbar]) flag=true;
   else flag=false;
   fl=flag;
   i=curbar+1;
   while(EP>0)
     {
      if(flag)
        {
         while(i<=Bars-1)
           {
            curbar1=iHighest(NULL,0,MODE_HIGH,n,i);
            curbar2=iHighest(NULL,0,MODE_HIGH,n,curbar1);
            if(curbar1==curbar2){curbar=curbar1;curpr=High[curbar];flag=false;i=curbar+1;j++;break;}
            else i=curbar2;
           }
         Mbar[j]=curbar;
         Mprice[j]=curpr;
         EP--;
        }
      if(EP==0) break;
      if(!flag)
        {
         while(i<=Bars-1)
           {
            curbar1=iLowest(NULL,0,MODE_LOW,n,i);
            curbar2=iLowest(NULL,0,MODE_LOW,n,curbar1);
            if(curbar1==curbar2){curbar=curbar1;curpr=Low[curbar];flag=true;i=curbar+1;j++;break;}
            else i=curbar2;
           }
         Mbar[j]=curbar;
         Mprice[j]=curpr;
         EP--;
        }
     }
/* ����������� ������ */
   if(Mprice[0]==Low[Mbar[0]])fd=true; else fd=false;
   for(k=0;k<=ExtPoint-1;k++)
     {
      if(k==0)
        {
         if(fd==true)
           {
            Mbar[k]=iLowest(NULL,0,MODE_LOW,Mbar[k+1]-Mbar[k],Mbar[k]);Mprice[k]=Low[Mbar[k]];endbar=ExtDepth;
           }
         if(fd==false)
           {
            Mbar[k]=iHighest(NULL,0,MODE_HIGH,Mbar[k+1]-Mbar[k],Mbar[k]);Mprice[k]=High[Mbar[k]];endbar=ExtDepth;
           }
        }
      if(k<ExtPoint-2)
        {
         if(fd==true)
           {
            Mbar[k+1]=iHighest(NULL,0,MODE_HIGH,Mbar[k+2]-Mbar[k]-1,Mbar[k]+1);Mprice[k+1]=High[Mbar[k+1]];
           }
         if(fd==false)
           {
            Mbar[k+1]=iLowest(NULL,0,MODE_LOW,Mbar[k+2]-Mbar[k]-1,Mbar[k]+1);Mprice[k+1]=Low[Mbar[k+1]];
           }
        }
      if(fd==true)fd=false;else fd=true;

/* ��������� ZigZag'a */
      zz[Mbar[k]]=Mprice[k];
      //Print("zz_"+k,"=",zz[Mbar[k]]);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*-------------------------------------------------------------------+
/  ZigZag_Talex �����                                                |
/-------------------------------------------------------------------*/

/*-------------------------------------------------------------------+
/ ������ ��� ������ � ������� ���� (���� �� �������) ����� ��������� |
/ ����� ������������ � �������� �������.                             |
/-------------------------------------------------------------------*/
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double funk1(int zzbarlow,int _ExtDepth)
  {
   double pr=0;
   int fbarlow,fbarhigh;
   fbarlow=iLowest(NULL,0,MODE_LOW,_ExtDepth,zzbarlow);
   fbarhigh=iHighest(NULL,0,MODE_HIGH,_ExtDepth,zzbarlow);
//----
   if(fbarlow>fbarhigh) pr=High[zzbarlow];
   if(fbarlow<fbarhigh) pr=Low[zzbarlow];
   if(fbarlow==fbarhigh)
     {
      fbarlow=iLowest(NULL,0,MODE_LOW,2*_ExtDepth,zzbarlow);
      fbarhigh=iHighest(NULL,0,MODE_HIGH,2*_ExtDepth,zzbarlow);
      if(fbarlow>fbarhigh) pr=High[zzbarlow];
      if(fbarlow<fbarhigh) pr=Low[zzbarlow];
      if(fbarlow==fbarhigh)
        {
         fbarlow=iLowest(NULL,0,MODE_LOW,3*_ExtDepth,zzbarlow);
         fbarhigh=iHighest(NULL,0,MODE_HIGH,3*_ExtDepth,zzbarlow);
         if(fbarlow>fbarhigh) pr=High[zzbarlow];
         if(fbarlow<fbarhigh) pr=Low[zzbarlow];
        }
     }
   return(pr);
  }
//+------------------------------------------------------------------+
//| ������� ����������� ����������� ����������.������.               |
//+------------------------------------------------------------------+
string TimeFrame()
  {
   string TF;
   switch(Period())
     {
      case 1: TF="M1";
      case 5: TF="M5";
      case 15: TF="M15";
      case 30: TF="M30";
      case 60: TF="H1";
      case 240: TF="H4";
      case 1440: TF="D1";
      case 10080: TF="W1";
      case 43200: TF="MN1";
     }
   return(TF);
  }
//+------------------------------------------------------------------+
//|  ������� ��� ������ ��������� ������.  ������.                   |
//+------------------------------------------------------------------+
void GartleyPatternsSearch(int X,int A,int B,int C,int D,int Depth)
  {
/* ���������� ���������� */
   double R0382=0.382,
   R0500=0.500,
   R0618=0.618,
   R0786=0.786,
   R0886=0.886,
   R1128=1.128,
   R1236=1.236,
   R1272=1.272,
   R1618=1.618,
   R2236=2.236,
   R2618=2.618,
   R3618=3.618;
   double   retXD,retXB,retBD,retAC,minret,maxret;
   string BullBear="",NamePattern="",MinMax="";
   static int varX,varA,varB,varC,varD;
//----
   if(varX==X && varA==A && varB==B && varC==C && varD==D)return;
   else {varX=X; varA=A; varB=B; varC=C; varD=D;}
   minret=1-ExtDopusk; maxret=1+ExtDopusk;
/* ���� �������� �� 5-�� ������ */
   if(FuturePattern==false)
     {
      if(zz[D]<zz[B] && zz[C]>zz[B] && zz[C]<zz[A] && zz[B]>zz[X])
        {
         BullBear="Bullish";
         MinMax="Min";
        }
      if(zz[D]>zz[B] && zz[C]<zz[B] && zz[C]>zz[A] && zz[B]<zz[X])
        {
         BullBear="Bearish";
         MinMax="Max";
        }
/* ������� ������������ */
      if(BullBear!="")
        {
         retXB=(zz[A]-zz[B])/(zz[A]-zz[X]+0.000001);
         retAC=(zz[C]-zz[B])/(zz[A]-zz[B]+0.000001);
         retBD=(zz[C]-zz[D])/(zz[C]-zz[B]+0.000001);
         retXD=(zz[A]-zz[D])/(zz[A]-zz[X]+0.000001);
/* ����� ���������� ������������ */
         if((retXB>=R0382*minret) && (retXB<=R0618*maxret) && (retAC>=R0382*minret) && (retAC<=R0886*maxret) && (retBD>=R1128*minret) && (retBD<=R2236*maxret) && (retXD>=R0618*minret) && (retXD<=R0786*maxret))
           {
            NamePattern="Gartley";
           }
         else if((retXB>=R0618*minret) && (retXB<=R0886*maxret) && (retAC>=R0382*minret) && (retAC<=R0886*maxret) && (retBD>=R1272*minret) && (retBD<=R2618*maxret) && (retXD>=R1272*minret) && (retXD<=R1618*maxret))
           {
            NamePattern="Butterfly";
           }
         else if((retXB>=R0382*minret) && (retXB<=R0886*maxret) && (retAC>=R0382*minret) && (retAC<=R0886*maxret) && (retBD>=R1618*minret) && (retBD<=R3618*maxret) && (retXD>=R1618*minret) && (retXD<=R1618*maxret))
           {
            NamePattern="Crab";
           }
         else if((retXB>=R0382*minret) && (retXB<=R0618*maxret) && (retAC>=R0382*minret) && (retAC<=R0886*maxret) && (retBD>=R1272*minret) && (retBD<=R2618*maxret) && (retXD>=R0886*minret) && (retXD<=R0886*maxret))
           { // ��� ������������ ����� �� ������ ���������� � ����� http://onix-trade.net/forum/index.php?s=dde8437cd886b3ef7328f83ddc17c4fe&showtopic=118&st=2780, � ����� ������ TSD � ����� ����� ���������� (������� Nen'� �� ������)
            NamePattern="Bat";
           }
        }
      if(NamePattern!="")
        {
         CreateRealPattern(NamePattern,BullBear,Depth,X,A,B,C,D,retXB,retAC,retBD,retXD,minret,maxret);
         TargetAndFibo(NamePattern,BullBear,MinMax,maxret,Depth,X,A,B,C,D);
        }
     }
   if(FuturePattern==true)
     {
      int X4,A4,B4,C4;
      double retBDminD,retBDmaxD,retXDminD,retXDmaxD,minD=0,maxD=0,maxAC;
      X4=A;A4=B;B4=C;C4=D;
      if(zz[B4]<zz[A4] && zz[B4]>zz[X4] && zz[C4]<zz[A4] && zz[C4]>zz[B4])
        {
         BullBear="Bullish";
         MinMax="Max";
        }
      if(zz[B4]>zz[A4] && zz[B4]<zz[X4] && zz[C4]>zz[A4] && zz[C4]<zz[B4])
        {
         BullBear="Bearish";
         MinMax="Min";
        }
/* ������� ������������ */
/* ��� ������������ ����� �� ������ ���������� � ����� http://onix-trade.net/forum/index.php?s=dde8437cd886b3ef7328f83ddc17c4fe&showtopic=118&st=2780, � ����� ������ TSD � ����� ����� ���������� (������� Nen'� �� ������)*/
      if(BullBear!="")
        {
         retXB=(zz[A4]-zz[B4])/(zz[A4]-zz[X4]+0.000001);
         retAC=(zz[C4]-zz[B4])/(zz[A4]-zz[B4]+0.000001);
/* ����� ���������� ������������ */
         if((retXB>=R0382*minret) && (retXB<=R0618*maxret) && (retAC>=R0382*minret) && (retAC<=R0886*maxret))
           {
            NamePattern="Gartley";
            retBDminD=zz[C4]-R1128*minret*(zz[C4]-zz[B4]);
            retBDmaxD=zz[C4]-R2236*maxret*(zz[C4]-zz[B4]);
            retXDminD=zz[A4]-R0618*minret*(zz[A4]-zz[X4]);
            retXDmaxD=zz[A4]-R0786*maxret*(zz[A4]-zz[X4]);
            maxAC=0.886*maxret*(zz[A4]-zz[B4])+zz[B4];
            if(BullBear=="Bullish")
              {
               if(retBDminD<retXDminD)minD=retBDminD;else minD=retXDminD;
               if(retBDmaxD>retXDmaxD)maxD=retBDmaxD;else maxD=retXDmaxD;
              }
            if(BullBear=="Bearish")
              {
               if(retBDminD>retXDminD)minD=retBDminD;else minD=retXDminD;
               if(retBDmaxD<retXDmaxD)maxD=retBDmaxD;else maxD=retXDmaxD;
              }
            CreateFuturePattern(X4,A4,B4,C4,Depth,minD,maxD,maxAC,retXB,retAC,BullBear,NamePattern,MinMax);
           }
         else if((retXB>=R0618*minret) && (retXB<=R0886*maxret) && (retAC>=R0382*minret) && (retAC<=R0886*maxret))
           {
            NamePattern="Butterfly";
            retBDminD=zz[C4]-R1272*minret*(zz[C4]-zz[B4]);
            retBDmaxD=zz[C4]-R2618*maxret*(zz[C4]-zz[B4]);
            retXDminD=zz[A4]-R1272*minret*(zz[A4]-zz[X4]);
            retXDmaxD=zz[A4]-R1618*maxret*(zz[A4]-zz[X4]);
            maxAC=0.886*maxret*(zz[A4]-zz[B4])+zz[B4];
            if(BullBear=="Bullish")
              {
               if(retBDminD<retXDminD)minD=retBDminD;else minD=retXDminD;
               if(retBDmaxD>retXDmaxD)maxD=retBDmaxD;else maxD=retXDmaxD;
              }
            if(BullBear=="Bearish")
              {
               if(retBDminD>retXDminD)minD=retBDminD;else minD=retXDminD;
               if(retBDmaxD<retXDmaxD)maxD=retBDmaxD;else maxD=retXDmaxD;
              }
            CreateFuturePattern(X4,A4,B4,C4,Depth,minD,maxD,maxAC,retXB,retAC,BullBear,NamePattern,MinMax);
           }
         else if((retXB>=R0382*minret) && (retXB<=R0886*maxret) && (retAC>=R0382*minret) && (retAC<=R0886*maxret))
           {
            NamePattern="Crab";
            retBDminD=zz[C4]-R1618*minret*(zz[C4]-zz[B4]);
            retBDmaxD=zz[C4]-R3618*maxret*(zz[C4]-zz[B4]);
            retXDminD=zz[A4]-R1618*minret*(zz[A4]-zz[X4]);
            retXDmaxD=zz[A4]-R1618*maxret*(zz[A4]-zz[X4]);
            maxAC=0.886*maxret*(zz[A4]-zz[B4])+zz[B4];
            if(BullBear=="Bullish")
              {
               if(retBDminD<retXDminD)minD=retBDminD;else minD=retXDminD;
               if(retBDmaxD>retXDmaxD)maxD=retBDmaxD;else maxD=retXDmaxD;
              }
            if(BullBear=="Bearish")
              {
               if(retBDminD>retXDminD)minD=retBDminD;else minD=retXDminD;
               if(retBDmaxD<retXDmaxD)maxD=retBDmaxD;else maxD=retXDmaxD;
              }
            CreateFuturePattern(X4,A4,B4,C4,Depth,minD,maxD,maxAC,retXB,retAC,BullBear,NamePattern,MinMax);
           }
         else if((retXB>=R0382*minret) && (retXB<=R0618*maxret) && (retAC>=R0382*minret) && (retAC<=R0886*maxret))
           {
            NamePattern="Bat";
            retBDminD=zz[C4]-R1272*minret*(zz[C4]-zz[B4]);
            retBDmaxD=zz[C4]-R2618*maxret*(zz[C4]-zz[B4]);
            retXDminD=zz[A4]-R0886*minret*(zz[A4]-zz[X4]);
            retXDmaxD=zz[A4]-R0886*maxret*(zz[A4]-zz[X4]);
            maxAC=0.886*maxret*(zz[A4]-zz[B4])+zz[B4];
            if(BullBear=="Bullish")
              {
               if(retBDminD<retXDminD)minD=retBDminD;else minD=retXDminD;
               if(retBDmaxD>retXDmaxD)maxD=retBDmaxD;else maxD=retXDmaxD;
              }
            if(BullBear=="Bearish")
              {
               if(retBDminD>retXDminD)minD=retBDminD;else minD=retXDminD;
               if(retBDmaxD<retXDmaxD)maxD=retBDmaxD;else maxD=retXDmaxD;
              }
            CreateFuturePattern(X4,A4,B4,C4,Depth,minD,maxD,maxAC,retXB,retAC,BullBear,NamePattern,MinMax);
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|  ������� ��� ������ �������� 5-0.  ������.                       |
//+------------------------------------------------------------------+
void Patterns50Search(int X,int A,int B,int C,int D,int Depth)
  {
   double   R0500=0.500,
   R1128=1.128,
   R1236=1.236,
   R1272=1.272,
   R1618=1.618,
   R2236=2.236;
   double   retXD,retXB,retBD,retAC,minret,maxret;
   string BullBear="",NamePattern="",MinMax="";
   static int var50X,var50A,var50B,var50C,var50D;
//----
   if(var50X==X && var50A==A && var50B==B && var50C==C && var50D==D)return;
   else {var50X=X; var50A=A; var50B=B; var50C=C; var50D=D;}
   minret=1-ExtDopusk; maxret=1+ExtDopusk;
/* ���� �������� �� 5-�� ������ */
   if(FuturePattern==false)
     {
      if(zz[X]>zz[B] && zz[X]<zz[A] && zz[D]>zz[B] && zz[D]<zz[C] && zz[A]<zz[C])
        {
         BullBear="Bullish";
         MinMax="Min";
        }
      if(zz[X]<zz[B] && zz[X]>zz[A] && zz[D]<zz[B] && zz[D]>zz[C] && zz[A]>zz[C])
        {
         BullBear="Bearish";
         MinMax="Max";
        }
/* ������� ������������ ��� ������� �������� */
      if(BullBear!="")
        {
         retXB=(zz[A]-zz[B])/(zz[A]-zz[X]+0.000001);
         retAC=(zz[C]-zz[B])/(zz[A]-zz[B]+0.000001);
         retBD=(zz[C]-zz[D])/(zz[C]-zz[B]+0.000001);
/* ����� ���������� ������������ */
         if((retXB>=R1128*minret) && (retXB<=R1618*maxret) && (retAC>=R1618*minret) && (retAC<=R2236*maxret) && (retBD>=R0500*minret) && (retBD<=R0500*maxret))
           {
            NamePattern="Pattern_5-0";
           }
        }
      if(NamePattern!="")
        {
         CreateRealPattern(NamePattern,BullBear,Depth,X,A,B,C,D,retXB,retAC,retBD,retXD,minret,maxret);
         TargetAndFibo(NamePattern,BullBear,MinMax,maxret,Depth,X,A,B,C,D);
        }
     }
   if(FuturePattern==true)
     {
      int X4,A4,B4,C4;
      double retBDminD,retBDmaxD,minD=0,maxD=0,maxAC;
      X4=A;A4=B;B4=C;C4=D;
      if(zz[X4]<zz[A4] && zz[X4]>zz[B4] && zz[A4]<zz[C4])
        {
         BullBear="Bullish";
         MinMax="Max";
        }
      if(zz[X4]>zz[A4] && zz[X4]<zz[B4] && zz[A4]>zz[C4])
        {
         BullBear="Bearish";
         MinMax="Min";
        }
/* ������� ������������ */
/* ��� ������������ ����� �� ������ ���������� � ����� http://onix-trade.net/forum/index.php?s=dde8437cd886b3ef7328f83ddc17c4fe&showtopic=118&st=2780, � ����� ������ TSD � ����� ����� ���������� (������� Nen'� �� ������)*/
      if(BullBear!="")
        {
         retXB=(zz[A4]-zz[B4])/(zz[A4]-zz[X4]+0.000001);
         retAC=(zz[C4]-zz[B4])/(zz[A4]-zz[B4]+0.000001);
/* ����� ���������� ������������ */
         if((retXB>=R1128*minret) && (retXB<=R1618*maxret) && (retAC>=R1618*minret) && (retAC<=R2236*maxret))
           {
            NamePattern="Pattern_5-0";
            retBDminD=zz[C4]-R0500*minret*(zz[C4]-zz[B4]);
            retBDmaxD=zz[C4]-R0500*maxret*(zz[C4]-zz[B4]);
            maxAC=2.236*maxret*(zz[A4]-zz[B4])+zz[B4];
            if(BullBear=="Bearish")
              {
               minD=retBDmaxD;maxD=retBDminD;
              }
            if(BullBear=="Bullish")
              {
               minD=retBDminD;maxD=retBDmaxD;
              }
            CreateFuturePattern(X4,A4,B4,C4,Depth,minD,maxD,maxAC,retXB,retAC,BullBear,NamePattern,MinMax);
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| ������� AB=CD. ������.                                           |
//+------------------------------------------------------------------+
void ABCDSearch(int A,int B,int C,int D,int Depth)
  {
   double   R0618=0.618,
   R0786=0.786,
   R1272=1.272,
   R1618=1.618;
   int X;
   double   retBD,retAC,retXB,retXD,minret,maxret;
   string BullBear="",NamePattern="",MinMax="";
   static int varabcdA,varabcdB,varabcdC,varabcdD;
//----
   if(varabcdA==A && varabcdB==B && varabcdC==C && varabcdD==D)return;
   else {varabcdA=A; varabcdB=B; varabcdC=C; varabcdD=D;}
   minret=1-ExtDopusk; maxret=1+ExtDopusk;
/* ���� �������� �� 5-�� ������ */
   if(FuturePattern==false)
     {
      if(MathAbs(zz[A]-zz[B])/MathAbs(zz[C]-zz[D])<=maxret && MathAbs(zz[A]-zz[B])/MathAbs(zz[C]-zz[D])>=minret && (A-C)/(1.0*(B-D))<=1+TimeDopusk && (A-C)/(1.0*(B-D))>=1-TimeDopusk)
        {
         if(zz[A]>zz[C] && zz[B]<zz[C] && zz[B]>zz[D])
           {
            BullBear="Bullish";
            MinMax="Min";
           }
         if(zz[A]<zz[C] && zz[B]>zz[C] && zz[B]<zz[D])
           {
            BullBear="Bearish";
            MinMax="Max";
           }
/* ������� ������������ ��� ������� �������� */
         if(BullBear!="")
           {
            retAC=(zz[C]-zz[B])/(zz[A]-zz[B]+0.000001);
            retBD=(zz[C]-zz[D])/(zz[C]-zz[B]+0.000001);
/* ����� ���������� ������������ */
            if((retAC>=R0618*minret) && (retAC<=R0786*maxret) && (retBD>=R1272*minret) && (retBD<=R1618*maxret))
              {
               NamePattern="AB=CD";
              }
           }
         if(NamePattern!="")
           {
            CreateRealPattern(NamePattern,BullBear,Depth,X,A,B,C,D,retXB,retAC,retBD,retXD,minret,maxret);
            TargetAndFibo(NamePattern,BullBear,MinMax,maxret,Depth,X,A,B,C,D);
           }
        }
     }
   if(FuturePattern==true)
     {
      int X4=0,A4,B4,C4;
      double retBDminD,retBDmaxD,minD=0,maxD=0,maxAC;

      A4=B;B4=C;C4=D;
      if(zz[A4]>zz[C4] && zz[C4]>zz[B4])
        {
         BullBear="Bullish";
         MinMax="Max";
        }
      if(zz[A4]<zz[C4] && zz[C4]<zz[B4])
        {
         BullBear="Bearish";
         MinMax="Min";
        }
      if(BullBear!="")
        {
         retAC=(zz[C4]-zz[B4])/(zz[A4]-zz[B4]+0.000001);
/* ����� ���������� ������������ */
         if((retAC>=R0618*minret) && (retAC<=R0786*maxret))
           {
            NamePattern="AB=CD";
            retBDminD=zz[C4]-minret*(zz[A4]-zz[B4]);
            retBDmaxD=zz[C4]-maxret*(zz[A4]-zz[B4]);
            maxAC=0.786*maxret*(zz[A4]-zz[B4])+zz[B4];
            if(BullBear=="Bearish")
              {
               minD=retBDmaxD;maxD=retBDminD;
              }
            if(BullBear=="Bullish")
              {
               minD=retBDminD;maxD=retBDmaxD;
              }
            CreateFuturePattern(X4,A4,B4,C4,Depth,minD,maxD,maxAC,retXB,retAC,BullBear,NamePattern,MinMax);
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|������� Wolfewaves. ������.                                       |
//+------------------------------------------------------------------+
void WolfWavesSearch(int P1,int P2,int P3,int P4,int P5,int Depth)
  {
   datetime t1,t2,t3,t4,t5,t6,t7,t8,t9;
   double p1,p2,p3,p4,p5,p6,p7,p8,p9;
   double condition1,condition2;
   string BullBear="",NamePattern="";
   static int varP1,varP2,varP3,varP4,varP5;
//----
   if(varP1==P1 && varP2==P2 && varP3==P3 && varP4==P4 && varP5==P5)return;
   else {varP1=P1; varP2=P2; varP3=P3; varP4=P4; varP5=P5;}
//----
   if(FuturePattern==false)
     {
      if(zz[P1]<zz[P2] && zz[P1]>zz[P3] && zz[P4]<zz[P2] && zz[P4]>zz[P1] && zz[P5]<zz[P3] && (P1-P3)/(1.0*(P3-P5))<=1+TimeDopusk && (P1-P3)/(1.0*(P3-P5))>=1-TimeDopusk && (P1-P3)/(1.0*(P2-P4))<=1+TimeDopusk && (P1-P3)/(1.0*(P2-P4))>=1-TimeDopusk && (P2-P4)/(1.0*(P3-P5))<=1+TimeDopusk && (P2-P4)/(1.0*(P3-P5))>=1-TimeDopusk)
        {
         BullBear="Bullish";
        }
      if(zz[P1]>zz[P2] && zz[P1]<zz[P3] && zz[P4]>zz[P2] && zz[P4]<zz[P1] && zz[P5]>zz[P3] && (P1-P3)/(1.0*(P3-P5))<=1+TimeDopusk && (P1-P3)/(1.0*(P3-P5))>=1-TimeDopusk && (P1-P3)/(1.0*(P2-P4))<=1+TimeDopusk && (P1-P3)/(1.0*(P2-P4))>=1-TimeDopusk && (P2-P4)/(1.0*(P3-P5))<=1+TimeDopusk && (P2-P4)/(1.0*(P3-P5))>=1-TimeDopusk)
        {
         BullBear="Bearish";
        }
      if(BullBear!="")
        {
         t1=Time[P1];p1=zz[P1]; /* ��������� �.1 */
         t2=Time[P2];p2=zz[P2]; /* ��������� �.2 */
         t3=Time[P3];p3=zz[P3]; /* ��������� �.3 */
         t4=Time[P4];p4=zz[P4]; /* ��������� �.4 */
         t5=Time[P5];p5=zz[P5]; /* ��������� �.5 */
         t6=Time[P5];p6=zz[P3]-NormalizeDouble(((zz[P1]-zz[P3])/(P1-P3))*(P3-P5),Digits); /* ��������� �.6 - �� ����� 1-3 */
         t7=Time[P5];p7=zz[P3]-NormalizeDouble(((zz[P2]-zz[P4])/(P2-P4))*(P3-P5),Digits); /* ��������� �.7 - �� �.3 ����� ����������� 2-4*/
         t8=Time[0]-(2*P4-P1)*Period()*60;p8=2*zz[P4]-zz[P1]; /* ��������� �.8 - �� ����� 1-4 */
         t9=t8+(P1-P3)*Period()*60;p9=p8-(zz[P1]-zz[P3]); /* ��������� �.9 - �� �.3 ����� ����������� 1-4*/
         //----
         if(p7<p6){condition1=p6;condition2=p7;}
         else {condition2=p6; condition1=p7;}
         if(zz[P5]<=condition1 && zz[P5]>=condition2)
           {
            NamePattern="WolfeWaves";
            WolfWavesDraw(NamePattern,BullBear,Depth,t1,t2,t3,t4,t5,t6,t7,t8,t9,p1,p2,p3,p4,p5,p6,p7,p8,p9);
           }
        }
     }
   if(FuturePattern==true)
     {
      P1=P2;P2=P3;P3=P4;P4=P5;P5=0;
      Print("P1=",zz[P1],"; P2=",zz[P2],"; P3=",zz[P3],"; P4=",zz[P4]);
      if(zz[P1]<zz[P2] && zz[P1]>zz[P3] && zz[P4]<zz[P2] && zz[P4]>zz[P1] && (P1-P3)/(1.0*(P2-P4))<=1+TimeDopusk && (P1-P3)/(1.0*(P2-P4))>=1-TimeDopusk)
        {
         BullBear="Bull";
        }
      if(zz[P1]>zz[P2] && zz[P1]<zz[P3] && zz[P4]>zz[P2] && zz[P4]<zz[P1] && (P1-P3)/(1.0*(P2-P4))<=1+TimeDopusk && (P1-P3)/(1.0*(P2-P4))>=1-TimeDopusk)
        {
         BullBear="Bear";
        }
      if(BullBear!="")
        {
         t1=Time[P1];p1=zz[P1]; /* ��������� �.1 */
         t2=Time[P2];p2=zz[P2]; /* ��������� �.2 */
         t3=Time[P3];p3=zz[P3]; /* ��������� �.3 */
         t4=Time[P4];p4=zz[P4]; /* ��������� �.4 */
         if(2*P3-P1>=0) /* ��������� �.5 */
           {
            t5=Time[2*P3-P1];
           }
         else t5=Time[0]-(2*P3-P1)*Period()*60;
         p5=2*p3-p1;
         if(p4>=p5)return;
         t6=t5;p6=p5; /* ��������� �.6 - �� ����� 1-3 */
         t7=t5;p7=zz[P3]-NormalizeDouble(((zz[P2]-zz[P4])/(P2-P4))*(P1-P3),Digits); /* ��������� �.7 - �� �.3 ����� ����������� 2-4*/
         t8=Time[0]-(2*P4-P1)*Period()*60;p8=2*zz[P4]-zz[P1]; /* ��������� �.8 - �� ����� 1-4 */
         t9=t8+(P1-P3)*Period()*60;p9=p8-(zz[P1]-zz[P3]); /* ��������� �.9 - �� �.3 ����� ����������� 1-4*/
         //----
         NamePattern="WolfeWaves";
         WolfWavesDraw(NamePattern,BullBear,Depth,t1,t2,t3,t4,t5,t6,t7,t8,t9,p1,p2,p3,p4,p5,p6,p7,p8,p9);

        }
     }
  }
//+------------------------------------------------------------------+
//|��������� ��������. ������.                                       |
//+------------------------------------------------------------------+
void CorrectObject()
  {
   string name1,name2;
   int i,j;
//----
   for(i=0;i<ObjectsTotal();i++)
     {
      name1=ObjectName(i);
      for(j=0;j<ObjectsTotal();j++)
        {
         name2=ObjectName(j);
         if(name1!=name2)
           {
            if(ObjectType(name1)==OBJ_TRIANGLE && ObjectType(name2)==OBJ_TRIANGLE)
              {
               if(ObjectGet(name1,OBJPROP_TIME1)==ObjectGet(name2,OBJPROP_TIME1) && ObjectGet(name1,OBJPROP_TIME2)==ObjectGet(name2,OBJPROP_TIME2) && ObjectGet(name1,OBJPROP_TIME3)==ObjectGet(name2,OBJPROP_TIME3) && ObjectGet(name1,OBJPROP_PRICE1)==ObjectGet(name2,OBJPROP_PRICE1) && ObjectGet(name1,OBJPROP_PRICE2)==ObjectGet(name2,OBJPROP_PRICE2) && ObjectGet(name1,OBJPROP_PRICE3)==ObjectGet(name2,OBJPROP_PRICE3))ObjectDelete(name2);
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|����� ����������. ������.                                         |
//+------------------------------------------------------------------+
void Commentarii()
  {
   string name1,name2;
   int i,j=1;
//----
   for(i=0;i<ObjectsTotal();i++)
     {
      name1=ObjectName(i);
      if(ObjectType(name1)==OBJ_TRIANGLE)
        {
         if(j==9)break;
         name2=ObjectDescription(name1);
         if(name2!=com1 && name2!=com2 && name2!=com3 && name2!=com4 && name2!=com5 && name2!=com6 && name2!=com7 && name2!=com8 && name2!=com9)
           {
            if(com1==""){com1=name2;j++;continue;}
            if(com2==""){com2=name2;j++;continue;}
            if(com3==""){com3=name2;j++;continue;}
            if(com4==""){com4=name2;j++;continue;}
            if(com5==""){com5=name2;j++;continue;}
            if(com6==""){com6=name2;j++;continue;}
            if(com7==""){com7=name2;j++;continue;}
            if(com8==""){com8=name2;j++;continue;}
            if(com9==""){com9=name2;j++;break;}
           }
        }
     }
   Comment("Search patterns","\n",com1,"\n",com2,"\n",com3,"\n",com4,"\n",com5,"\n",com6,"\n",com7,"\n",com8,"\n",com9,"\n");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*----------------------------------------------------------
�����. ������.
----------------------------------------------------------/
bool AlertGet(bool AlertPattern)
{
 static string nom1="",nom2="",nom3="",nom4="",nom5="",nom6="",nom7="",nom8="",nom9="";
 bool Al
 if(nom1=="" && nom2=="" && nom3=="" && nom4=="" && nom5=="" && nom6=="" && nom7=="" && nom8=="" && nom9=="")
 {
  nom1=com1;
  nom2=com2;
  nom3=com3;
  nom4=com4;
  nom5=com5;
  nom6=com6;
  nom7=com7;
  nom8=com8;
  nom9=com9;
 }
 if(nom1==com1 || nom2==com1 || nom3==com1 || nom4==com1 || nom5==com1 || nom6==com1 || nom7==com1 || nom8==com1 || nom9==com1)
  {}else 
}
-----------------------------------------------------------*/
//+------------------------------------------------------------------+
//|ExtRet. ������.                                                   |
//+------------------------------------------------------------------+
string ExtRet(double enterret,double minret,double maxret)
  {
   double ret;
   string returnret="",znak="";
   bool Retbool=true;
   if(enterret>=0.382*minret && enterret<=0.382*maxret)
     {
      ret=(enterret/0.382-1)*100;
      if(ret>=0)znak="+";else znak="-";
      Retbool=false;
      returnret=" ("+"0.382"+znak+DoubleToStr(MathAbs(ret),2)+"%"+")";
     }
   if(enterret>=0.5*minret && enterret<=0.5*maxret)
     {
      ret=(enterret/0.5-1)*100;
      if(ret>=0)znak="+";else znak="-";
      Retbool=false;
      returnret=" ("+"0.5"+znak+DoubleToStr(MathAbs(ret),2)+"%"+")";
     }
   if(enterret>=0.618*minret && enterret<=0.618*maxret)
     {
      ret=(enterret/0.618-1)*100;
      if(ret>=0)znak="+";else znak="-";
      Retbool=false;
      returnret=" ("+"0.618"+znak+DoubleToStr(MathAbs(ret),2)+"%"+")";
     }
   if(enterret>=0.707*minret && enterret<=0.707*maxret)
     {
      ret=(enterret/0.707-1)*100;
      if(ret>=0)znak="+";else znak="-";
      Retbool=false;
      returnret=" ("+"0.707"+znak+DoubleToStr(MathAbs(ret),2)+"%"+")";
     }
   if(enterret>=0.786*minret && enterret<=0.786*maxret)
     {
      ret=(enterret/0.786-1)*100;
      if(ret>=0)znak="+";else znak="-";
      Retbool=false;
      returnret=" ("+"0.786"+znak+DoubleToStr(MathAbs(ret),2)+"%"+")";
     }
   if(enterret>=0.886*minret && enterret<=0.886*maxret)
     {
      ret=(enterret/0.886-1)*100;
      if(ret>=0)znak="+";else znak="-";
      Retbool=false;
      returnret=" ("+"0.886"+znak+DoubleToStr(MathAbs(ret),2)+"%"+")";
     }
   if(enterret>=1.128*minret && enterret<=1.128*maxret)
     {
      ret=(enterret/1.128-1)*100;
      if(ret>=0)znak="+";else znak="-";
      Retbool=false;
      returnret=" ("+"1.128"+znak+DoubleToStr(MathAbs(ret),2)+"%"+")";
     }
   if(enterret>=1.236*minret && enterret<=1.236*maxret)
     {
      ret=(enterret/1.236-1)*100;
      if(ret>=0)znak="+";else znak="-";
      Retbool=false;
      returnret=" ("+"1.236"+znak+DoubleToStr(MathAbs(ret),2)+"%"+")";
     }
   if(enterret>=1.272*minret && enterret<=1.272*maxret)
     {
      ret=(enterret/1.272-1)*100;
      if(ret>=0)znak="+";else znak="-";
      Retbool=false;
      returnret=" ("+"1.272"+znak+DoubleToStr(MathAbs(ret),2)+"%"+")";
     }
   if(enterret>=1.414*minret && enterret<=1.414*maxret)
     {
      ret=(enterret/1.414-1)*100;
      if(ret>=0)znak="+";else znak="-";
      Retbool=false;
      returnret=" ("+"1.414"+znak+DoubleToStr(MathAbs(ret),2)+"%"+")";
     }
   if(enterret>=1.618*minret && enterret<=1.618*maxret)
     {
      ret=(enterret/1.618-1)*100;
      if(ret>=0)znak="+";else znak="-";
      Retbool=false;
      returnret=" ("+"1.618"+znak+DoubleToStr(MathAbs(ret),2)+"%"+")";
     }
   if(enterret>=2.236*minret && enterret<=2.236*maxret)
     {
      ret=(enterret/2.236-1)*100;
      if(ret>=0)znak="+";else znak="-";
      Retbool=false;
      returnret=" ("+"2.236"+znak+DoubleToStr(MathAbs(ret),2)+"%"+")";
     }
   if(enterret>=2.618*minret && enterret<=2.618*maxret)
     {
      ret=(enterret/2.618-1)*100;
      if(ret>=0)znak="+";else znak="-";
      Retbool=false;
      returnret=" ("+"2.618"+znak+DoubleToStr(MathAbs(ret),2)+"%"+")";
     }
   if(enterret>=3.618*minret && enterret<=3.618*maxret)
     {
      ret=(enterret/3.618-1)*100;
      if(ret>=0)znak="+";else znak="-";
      Retbool=false;
      returnret=" ("+"3.618"+znak+DoubleToStr(MathAbs(ret),2)+"%"+")";
     }
   if(Retbool){returnret=" (n/a)";}
   return(returnret);
  }
//+------------------------------------------------------------------+
//|TargetAndFibo.������.                                             |
//+------------------------------------------------------------------+
void TargetAndFibo(string NamePattern,string BullBear,string MinMax,double maxret,int Depth,int X,int A,int B,int C,int D)
  {
   double PriceD=0,PriceD_XD=0,PriceD_BD=0,TextMove=0.0;
//----
   if(BullBear=="Bearish")TextMove=TextEdit();
   if(NamePattern=="Pattern_5-0")PriceD=zz[C]-0.5*maxret*(zz[C]-zz[B]);
   if(NamePattern=="AB=CD")PriceD=zz[C]-maxret*(zz[A]-zz[B]);
   if(NamePattern=="Gartley")
     {
      PriceD_XD=zz[A]-0.786*maxret*(zz[A]-zz[X]);
      PriceD_BD=zz[C]-2.236*maxret*(zz[C]-zz[B]);
     }
   if(NamePattern=="Butterfly")
     {
      PriceD_XD=zz[A]-1.618*maxret*(zz[A]-zz[X]);
      PriceD_BD=zz[C]-2.618*maxret*(zz[C]-zz[B]);
     }
   if(NamePattern=="Crab")
     {
      PriceD_XD=zz[A]-1.618*maxret*(zz[A]-zz[X]);
      PriceD_BD=zz[C]-3.618*maxret*(zz[C]-zz[B]);
     }
   if(NamePattern=="Bat")
     {
      PriceD_XD=zz[A]-0.886*maxret*(zz[A]-zz[X]);
      PriceD_BD=zz[C]-2.618*maxret*(zz[C]-zz[B]);
     }
   if(NamePattern=="Gartley" || NamePattern=="Butterfly" || NamePattern=="Crab" || NamePattern=="Bat")
     {
      if((BullBear=="Bullish" && PriceD_XD<PriceD_BD) || (BullBear=="Bearish" && PriceD_XD>PriceD_BD))
         PriceD=PriceD_BD;
      else PriceD=PriceD_XD;
     }
   datetime timeD;
   if(D-10>=0)timeD=Time[D-10];else timeD=Time[0]-(D-10)*Period()*60;
   ObjectDelete("RealTargetD_"+NamePattern+(string)Depth+save);
   ObjectDelete("RealTextTargetD_"+NamePattern+(string)Depth+save);
   ObjectDelete("RealFiboTarget_"+NamePattern+(string)Depth+save);
   ObjectCreate("RealTargetD_"+NamePattern+(string)Depth+save,OBJ_TREND,0,Time[D],PriceD,timeD,PriceD);
   ObjectSet("RealTargetD_"+NamePattern+(string)Depth+save,OBJPROP_RAY,false);
   ObjectCreate("RealTextTargetD_"+NamePattern+(string)Depth+save,OBJ_TEXT,0,Time[D],PriceD+TextMove);
   ObjectSetText("RealTextTargetD_"+NamePattern+(string)Depth+save,NamePattern+MinMax+"PriceD="+DoubleToStr(PriceD,Digits),10,"Times New Roman",ExtColorRet);
   ObjectCreate("RealFiboTarget_"+NamePattern+(string)Depth+save,OBJ_FIBO,0,Time[C],zz[C],Time[D],zz[D]);
   ObjectSet("RealFiboTarget_"+NamePattern+(string)Depth+save,OBJPROP_LEVELCOLOR,Yellow);
   ObjectSet("RealFiboTarget_"+NamePattern+(string)Depth+save,OBJPROP_LEVELSTYLE,STYLE_DOT);
//ObjectSet("RealFiboTarget_"+NamePattern+(string)Depth+save,OBJPROP_RAY,false);
   ObjectSet("RealFiboTarget_"+NamePattern+(string)Depth+save,OBJPROP_LEVELWIDTH,1);
   ObjectSet("RealFiboTarget_"+NamePattern+(string)Depth+save,OBJPROP_FIBOLEVELS,13);
   ObjectSet("RealFiboTarget_"+NamePattern+(string)Depth+save,OBJPROP_FIRSTLEVEL+0,0.0);
   ObjectSet("RealFiboTarget_"+NamePattern+(string)Depth+save,OBJPROP_FIRSTLEVEL+1,0.146);
   ObjectSet("RealFiboTarget_"+NamePattern+(string)Depth+save,OBJPROP_FIRSTLEVEL+2,0.236);
   ObjectSet("RealFiboTarget_"+NamePattern+(string)Depth+save,OBJPROP_FIRSTLEVEL+3,0.382);
   ObjectSet("RealFiboTarget_"+NamePattern+(string)Depth+save,OBJPROP_FIRSTLEVEL+4,0.5);
   ObjectSet("RealFiboTarget_"+NamePattern+(string)Depth+save,OBJPROP_FIRSTLEVEL+5,0.618);
   ObjectSet("RealFiboTarget_"+NamePattern+(string)Depth+save,OBJPROP_FIRSTLEVEL+6,0.764);
   ObjectSet("RealFiboTarget_"+NamePattern+(string)Depth+save,OBJPROP_FIRSTLEVEL+7,0.854);
   ObjectSet("RealFiboTarget_"+NamePattern+(string)Depth+save,OBJPROP_FIRSTLEVEL+8,1.0);
   ObjectSet("RealFiboTarget_"+NamePattern+(string)Depth+save,OBJPROP_FIRSTLEVEL+9,1.236);
   ObjectSet("RealFiboTarget_"+NamePattern+(string)Depth+save,OBJPROP_FIRSTLEVEL+10,1.618);
   ObjectSet("RealFiboTarget_"+NamePattern+(string)Depth+save,OBJPROP_FIRSTLEVEL+11,2.618);
   ObjectSet("RealFiboTarget_"+NamePattern+(string)Depth+save,OBJPROP_FIRSTLEVEL+12,3.618);
   ObjectSetFiboDescription("RealFiboTarget_"+NamePattern+(string)Depth+save,0,NamePattern+" - 0 %"+" ("+DoubleToStr(zz[D],Digits)+")");
   ObjectSetFiboDescription("RealFiboTarget_"+NamePattern+(string)Depth+save,1,NamePattern+" - 14.6 %"+" ("+DoubleToStr(zz[D]-(zz[D]-zz[C])*0.146,Digits)+")");
   ObjectSetFiboDescription("RealFiboTarget_"+NamePattern+(string)Depth+save,2,NamePattern+" - 23.6 %"+" ("+DoubleToStr(zz[D]-(zz[D]-zz[C])*0.236,Digits)+")");
   ObjectSetFiboDescription("RealFiboTarget_"+NamePattern+(string)Depth+save,3,NamePattern+" - 38.2 %"+" ("+DoubleToStr(zz[D]-(zz[D]-zz[C])*0.382,Digits)+")");
   ObjectSetFiboDescription("RealFiboTarget_"+NamePattern+(string)Depth+save,4,NamePattern+" - 50 %"+" ("+DoubleToStr(zz[D]-(zz[D]-zz[C])*0.5,Digits)+")");
   ObjectSetFiboDescription("RealFiboTarget_"+NamePattern+(string)Depth+save,5,NamePattern+" - 61.8 %"+" ("+DoubleToStr(zz[D]-(zz[D]-zz[C])*0.618,Digits)+")");
   ObjectSetFiboDescription("RealFiboTarget_"+NamePattern+(string)Depth+save,6,NamePattern+" - 76.4 %"+" ("+DoubleToStr(zz[D]-(zz[D]-zz[C])*0.764,Digits)+")");
   ObjectSetFiboDescription("RealFiboTarget_"+NamePattern+(string)Depth+save,7,NamePattern+" - 85.4 %"+" ("+DoubleToStr(zz[D]-(zz[D]-zz[C])*0.854,Digits)+")");
   ObjectSetFiboDescription("RealFiboTarget_"+NamePattern+(string)Depth+save,8,NamePattern+" - 100 %"+" ("+DoubleToStr(zz[C],Digits)+")");
   ObjectSetFiboDescription("RealFiboTarget_"+NamePattern+(string)Depth+save,9,NamePattern+" - 123.6 %"+" ("+DoubleToStr(zz[D]-(zz[D]-zz[C])*1.236,Digits)+")");
   ObjectSetFiboDescription("RealFiboTarget_"+NamePattern+(string)Depth+save,10,NamePattern+" - 161.8 %"+" ("+DoubleToStr(zz[D]-(zz[D]-zz[C])*1.618,Digits)+")");
   ObjectSetFiboDescription("RealFiboTarget_"+NamePattern+(string)Depth+save,11,NamePattern+" - 261.8 %"+" ("+DoubleToStr(zz[D]-(zz[D]-zz[C])*2.618,Digits)+")");
   ObjectSetFiboDescription("RealFiboTarget_"+NamePattern+(string)Depth+save,12,NamePattern+" - 361.8 %"+" ("+DoubleToStr(zz[D]-(zz[D]-zz[C])*3.618,Digits)+")");
  }
//+------------------------------------------------------------------+
//|CreateFuturePattern.������.                                       |
//+------------------------------------------------------------------+
void CreateFuturePattern(int X4,int A4,int B4,int C4,int Depth,double minD,double maxD,double maxAC,double retXB,double retAC,string BullBear,string NamePattern,string MinMax)
  {
   datetime Tm;
   double minret,maxret,TextMove=0.0;
   minret=1-ExtDopusk; maxret=1+ExtDopusk;
//----
   if(2*B4-X4>=0)Tm=Time[2*B4-X4];else Tm=Time[0]-(2*B4-X4)*Period()*60;
   if(NamePattern=="Pattern_5-0" || NamePattern=="AB=CD")
     {
      ObjectDelete("Future3_"+NamePattern+(string)Depth+save);
      ObjectCreate("Future3_"+NamePattern+(string)Depth+save,OBJ_TRIANGLE,0,Time[A4],zz[A4],Time[B4],zz[B4],Time[C4],zz[C4]);
      ObjectSetText("Future3_"+NamePattern+(string)Depth+save,NamePattern+"_"+BullBear+"_"+TimeFrame()+"_"+(string)Depth);
      if(C4-(A4-B4)>=0)Tm=Time[C4-(A4-B4)];else Tm=Time[0]-(C4-(A4-B4))*Period()*60;
     }
   if(NamePattern!="AB=CD")
     {
      ObjectDelete("Future1_"+NamePattern+(string)Depth+save);
      ObjectCreate("Future1_"+NamePattern+(string)Depth+save,OBJ_TRIANGLE,0,Time[X4],zz[X4],Time[A4],zz[A4],Time[B4],zz[B4]);
      ObjectSetText("Future1_"+NamePattern+(string)Depth+save,NamePattern+"_"+BullBear+"_"+TimeFrame()+"_"+(string)Depth);
     }
   ObjectDelete("Future2_"+NamePattern+(string)Depth+save);
   ObjectCreate("Future2_"+NamePattern+(string)Depth+save,OBJ_TRIANGLE,0,Time[B4],zz[B4],Time[C4],zz[C4],Tm,(minD+maxD)/2);
   ObjectSetText("Future2_"+NamePattern+(string)Depth+save,NamePattern+"_"+BullBear+"_"+TimeFrame()+"_"+(string)Depth);
//--------------
   if(NamePattern!="WolfeWaves" && BullBear=="Bullish")TextMove=TextEdit();
   ObjectDelete("FutureTargetC_"+NamePattern+(string)Depth+save);
   ObjectDelete("FutureTextTargetC_"+NamePattern+(string)Depth+save);
   ObjectCreate("FutureTargetC_"+NamePattern+(string)Depth+save,OBJ_TREND,0,Time[C4],maxAC,Time[C4]+10*Period()*60,maxAC);
   ObjectSet("FutureTargetC_"+NamePattern+(string)Depth+save,OBJPROP_RAY,false);
   ObjectCreate("FutureTextTargetC_"+NamePattern+(string)Depth+save,OBJ_TEXT,0,Time[C4],maxAC+TextMove);
   ObjectSetText("FutureTextTargetC_"+NamePattern+(string)Depth+save,NamePattern+MinMax+"PriceC="+DoubleToStr(maxAC,Digits),10,"Times New Roman",ExtColorRet);
//--------------
   ObjectDelete("FutureMinTargetD_"+NamePattern+(string)Depth+save);
   ObjectDelete("FutureTextMinTargetD_"+NamePattern+(string)Depth+save);
   ObjectCreate("FutureMinTargetD_"+NamePattern+(string)Depth+save,OBJ_TREND,0,Tm,minD,Tm+10*Period()*60,minD);
   ObjectSet("FutureMinTargetD_"+NamePattern+(string)Depth+save,OBJPROP_RAY,false);
   ObjectCreate("FutureTextMinTargetD_"+NamePattern+(string)Depth+save,OBJ_TEXT,0,Tm,minD+TextMove);
   ObjectSetText("FutureTextMinTargetD_"+NamePattern+(string)Depth+save,NamePattern+"MinPriceD="+DoubleToStr(minD,Digits),10,"Times New Roman",ExtColorRet);
//--------------
   TextMove=0.0;
   if(NamePattern!="WolfeWaves" && BullBear=="Bearish")TextMove=TextEdit();
   ObjectDelete("FutureMaxTargetD_"+NamePattern+(string)Depth+save);
   ObjectDelete("FutureTextMaxTargetD_"+NamePattern+(string)Depth+save);
   ObjectCreate("FutureMaxTargetD_"+NamePattern+(string)Depth+save,OBJ_TREND,0,Tm,maxD,Tm+10*Period()*60,maxD);
   ObjectSet("FutureMaxTargetD_"+NamePattern+(string)Depth+save,OBJPROP_RAY,false);
   ObjectCreate("FutureTextMaxTargetD_"+NamePattern+(string)Depth+save,OBJ_TEXT,0,Tm,maxD+TextMove);
   ObjectSetText("FutureTextMaxTargetD_"+NamePattern+(string)Depth+save,NamePattern+"MaxPriceD="+DoubleToStr(maxD,Digits),10,"Times New Roman",ExtColorRet);
   TextMove=0.0;
//--------------
   string RXB=DoubleToStr(retXB,3)+ExtRet(retXB,minret,maxret);
   string RAC=DoubleToStr(retAC,3)+ExtRet(retAC,minret,maxret);
   if(NamePattern!="AB=CD")
     {
      if(NamePattern!="WolfeWaves" && BullBear=="Bearish")TextMove=TextEdit();
      ObjectDelete("FutureRetXB_"+NamePattern+(string)Depth+save);
      ObjectDelete("FutureTextRetXB_"+NamePattern+(string)Depth+save);
      ObjectCreate("FutureRetXB_"+NamePattern+(string)Depth+save,OBJ_TREND,0,Time[X4],zz[X4],Time[B4],zz[B4]);
      ObjectSet("FutureRetXB_"+NamePattern+(string)Depth+save,OBJPROP_COLOR,ExtColorRet);
      ObjectSet("FutureRetXB_"+NamePattern+(string)Depth+save,OBJPROP_STYLE,STYLE_DOT);
      ObjectSet("FutureRetXB_"+NamePattern+(string)Depth+save,OBJPROP_RAY,false);
      ObjectCreate("FutureTextRetXB_"+NamePattern+(string)Depth+save,OBJ_TEXT,0,Time[X4]/2+Time[B4]/2,(zz[X4]+zz[B4])/2+TextMove);
      ObjectSetText("FutureTextRetXB_"+NamePattern+(string)Depth+save,RXB,10,"Times New Roman",ExtColorRet);
      ObjectSet("FutureTextRetXB_"+NamePattern+(string)Depth+save,OBJPROP_ANGLE,AngleEdit(X4,zz[X4],B4,zz[B4]));
      TextMove=0.0;
     }
   if(NamePattern!="WolfeWaves" && BullBear=="Bullish")TextMove=TextEdit();
   ObjectDelete("FutureRetAC_"+NamePattern+(string)Depth+save);
   ObjectDelete("FutureTextRetAC_"+NamePattern+(string)Depth+save);
   ObjectCreate("FutureRetAC_"+NamePattern+(string)Depth+save,OBJ_TREND,0,Time[A4],zz[A4],Time[C4],zz[C4]);
   ObjectSet("FutureRetAC_"+NamePattern+(string)Depth+save,OBJPROP_COLOR,ExtColorRet);
   ObjectSet("FutureRetAC_"+NamePattern+(string)Depth+save,OBJPROP_STYLE,STYLE_DOT);
   ObjectSet("FutureRetAC_"+NamePattern+(string)Depth+save,OBJPROP_RAY,false);
   ObjectCreate("FutureTextRetAC_"+NamePattern+(string)Depth+save,OBJ_TEXT,0,Time[A4]/2+Time[C4]/2,(zz[A4]+zz[C4])/2+TextMove);
   ObjectSetText("FutureTextRetAC_"+NamePattern+(string)Depth+save,RAC,10,"Times New Roman",ExtColorRet);
   ObjectSet("FutureTextRetAC_"+NamePattern+(string)Depth+save,OBJPROP_ANGLE,AngleEdit(A4,zz[A4],C4,zz[C4]));
   TextMove=0.0;
//--------------
  }
//+------------------------------------------------------------------+
//|CreateRealPattern.������.                                         |
//+------------------------------------------------------------------+
void CreateRealPattern(string NamePattern,string BullBear,int Depth,int X,int A,int B,int C,int D,double retXB,double retAC,double retBD,double retXD,double minret,double maxret)
  {
   double TextMove=0.0;
   int XB=(int)MathCeil((X+B)/2);
   int AC=(int)MathCeil((A+C)/2);
   int BD=(int)MathCeil((B+D)/2);
   int XD=(int)MathCeil((X+D)/2);
   string RXB=DoubleToStr(retXB,3)+ExtRet(retXB,minret,maxret);
   string RAC=DoubleToStr(retAC,3)+ExtRet(retAC,minret,maxret);
   string RBD=DoubleToStr(retBD,3)+ExtRet(retBD,minret,maxret);
   string RXD=DoubleToStr(retXD,3)+ExtRet(retXD,minret,maxret);
//----
   if(NamePattern!="AB=CD")
     {
      ObjectDelete("Real1_"+NamePattern+(string)Depth+save);
      ObjectCreate("Real1_"+NamePattern+(string)Depth+save,OBJ_TRIANGLE,0,Time[X],zz[X],Time[A],zz[A],Time[B],zz[B]);
      ObjectSet("Real1_"+NamePattern+(string)Depth+save,OBJPROP_COLOR,ExtColorGartley);
      ObjectSetText("Real1_"+NamePattern+(string)Depth+save,"Real_"+NamePattern+"_"+BullBear+"_"+TimeFrame()+"_"+(string)Depth);
     }
   ObjectDelete("Real2_"+NamePattern+(string)Depth+save);
   ObjectCreate("Real2_"+NamePattern+(string)Depth+save,OBJ_TRIANGLE,0,Time[B],zz[B],Time[C],zz[C],Time[D],zz[D]);
   ObjectSet("Real2_"+NamePattern+(string)Depth+save,OBJPROP_COLOR,ExtColorGartley);
   ObjectSetText("Real2_"+NamePattern+(string)Depth+save,"Real_"+NamePattern+"_"+BullBear+"_"+TimeFrame()+"_"+(string)Depth);
   if(NamePattern=="Pattern_5-0" || NamePattern=="AB=CD")
     {
      ObjectDelete("Real3_"+NamePattern+(string)Depth+save);
      ObjectCreate("Real3_"+NamePattern+(string)Depth+save,OBJ_TRIANGLE,0,Time[A],zz[A],Time[B],zz[B],Time[C],zz[C]);
      ObjectSet("Real3_"+NamePattern+(string)Depth+save,OBJPROP_COLOR,ExtColorGartley);
      ObjectSetText("Real3_"+NamePattern+(string)Depth+save,"Real_"+NamePattern+"_"+BullBear+"_"+TimeFrame()+"_"+(string)Depth);
     }
   if(NamePattern!="WolfeWaves" && BullBear=="Bullish")TextMove=TextEdit();
   ObjectDelete("RealRetAC_"+NamePattern+(string)Depth+save);
   ObjectDelete("RealTextRetAC_"+NamePattern+(string)Depth+save);
   ObjectCreate("RealRetAC_"+NamePattern+(string)Depth+save,OBJ_TREND,0,Time[A],zz[A],Time[C],zz[C]);
   ObjectSet("RealRetAC_"+NamePattern+(string)Depth+save,OBJPROP_COLOR,ExtColorRet);
   ObjectSet("RealRetAC_"+NamePattern+(string)Depth+save,OBJPROP_STYLE,STYLE_DOT);
   ObjectSet("RealRetAC_"+NamePattern+(string)Depth+save,OBJPROP_RAY,false);
   ObjectCreate("RealTextRetAC_"+NamePattern+(string)Depth+save,OBJ_TEXT,0,Time[AC],(zz[A]+zz[C])/2+TextMove);
   ObjectSetText("RealTextRetAC_"+NamePattern+(string)Depth+save,RAC,10,"Times New Roman",ExtColorRet);
   ObjectSet("RealTextRetAC_"+NamePattern+(string)Depth+save,OBJPROP_ANGLE,AngleEdit(A,zz[A],C,zz[C]));
   TextMove=0.0;
   if(NamePattern!="WolfeWaves" && BullBear=="Bearish")TextMove=TextEdit();
   if(NamePattern!="AB=CD")
     {
      ObjectDelete("RealRetXB_"+NamePattern+(string)Depth+save);
      ObjectDelete("RealTextRetXB_"+NamePattern+(string)Depth+save);
      ObjectCreate("RealRetXB_"+NamePattern+(string)Depth+save,OBJ_TREND,0,Time[X],zz[X],Time[B],zz[B]);
      ObjectSet("RealRetXB_"+NamePattern+(string)Depth+save,OBJPROP_COLOR,ExtColorRet);
      ObjectSet("RealRetXB_"+NamePattern+(string)Depth+save,OBJPROP_STYLE,STYLE_DOT);
      ObjectSet("RealRetXB_"+NamePattern+(string)Depth+save,OBJPROP_RAY,false);
      ObjectCreate("RealTextRetXB_"+NamePattern+(string)Depth+save,OBJ_TEXT,0,Time[XB],(zz[X]+zz[B])/2+TextMove);
      ObjectSetText("RealTextRetXB_"+NamePattern+(string)Depth+save,RXB,10,"Times New Roman",ExtColorRet);
      ObjectSet("RealTextRetXB_"+NamePattern+(string)Depth+save,OBJPROP_ANGLE,AngleEdit(X,zz[X],B,zz[B]));
     }
   ObjectDelete("RealRetBD_"+NamePattern+(string)Depth+save);
   ObjectDelete("RealTextRetBD_"+NamePattern+(string)Depth+save);
   ObjectCreate("RealRetBD_"+NamePattern+(string)Depth+save,OBJ_TREND,0,Time[B],zz[B],Time[D],zz[D]);
   ObjectSet("RealRetBD_"+NamePattern+(string)Depth+save,OBJPROP_COLOR,ExtColorRet);
   ObjectSet("RealRetBD_"+NamePattern+(string)Depth+save,OBJPROP_STYLE,STYLE_DOT);
   ObjectSet("RealRetBD_"+NamePattern+(string)Depth+save,OBJPROP_RAY,false);
   ObjectCreate("RealTextRetBD_"+NamePattern+(string)Depth+save,OBJ_TEXT,0,Time[BD],(zz[B]+zz[D])/2+TextMove);
   ObjectSetText("RealTextRetBD_"+NamePattern+(string)Depth+save,RBD,10,"Times New Roman",ExtColorRet);
   ObjectSet("RealTextRetBD_"+NamePattern+(string)Depth+save,OBJPROP_ANGLE,AngleEdit(B,zz[B],D,zz[D]));
//----
   if(NamePattern!="Pattern_5-0" && NamePattern!="AB=CD")
     {
      ObjectDelete("RealRetXD_"+NamePattern+(string)Depth+save);
      ObjectDelete("RealTextRetXD_"+NamePattern+(string)Depth+save);
      ObjectCreate("RealRetXD_"+NamePattern+(string)Depth+save,OBJ_TREND,0,Time[X],zz[X],Time[D],zz[D]);
      ObjectSet("RealRetXD_"+NamePattern+(string)Depth+save,OBJPROP_COLOR,ExtColorRet);
      ObjectSet("RealRetXD_"+NamePattern+(string)Depth+save,OBJPROP_STYLE,STYLE_DOT);
      ObjectSet("RealRetXD_"+NamePattern+(string)Depth+save,OBJPROP_RAY,false);
      ObjectCreate("RealTextRetXD_"+NamePattern+(string)Depth+save,OBJ_TEXT,0,Time[XD],(zz[X]+zz[D])/2+TextMove);
      ObjectSetText("RealTextRetXD_"+NamePattern+(string)Depth+save,RXD,10,"Times New Roman",ExtColorRet);
      ObjectSet("RealTextRetXD_"+NamePattern+(string)Depth+save,OBJPROP_ANGLE,AngleEdit(X,zz[X],D,zz[D]));
     }
   TextMove=0.0;
   if(NamePattern!="AB=CD")
     {
      ObjectDelete("RealLineXA_"+NamePattern+(string)Depth+save);
      ObjectCreate("RealLineXA_"+NamePattern+(string)Depth+save,OBJ_TREND,0,Time[X],zz[X],Time[A],zz[A]);
      ObjectSet("RealLineXA_"+NamePattern+(string)Depth+save,OBJPROP_COLOR,SkyBlue);
      ObjectSet("RealLineXA_"+NamePattern+(string)Depth+save,OBJPROP_STYLE,STYLE_DOT);
      ObjectSet("RealLineXA_"+NamePattern+(string)Depth+save,OBJPROP_RAY,false);
      ObjectSet("RealLineXA_"+NamePattern+(string)Depth+save,OBJPROP_WIDTH,2);
     }
   ObjectDelete("RealLineAB_"+NamePattern+(string)Depth+save);
   ObjectDelete("RealLineBC_"+NamePattern+(string)Depth+save);
   ObjectDelete("RealLineCD_"+NamePattern+(string)Depth+save);
   ObjectCreate("RealLineAB_"+NamePattern+(string)Depth+save,OBJ_TREND,0,Time[A],zz[A],Time[B],zz[B]);
   ObjectSet("RealLineAB_"+NamePattern+(string)Depth+save,OBJPROP_COLOR,SkyBlue);
   ObjectSet("RealLineAB_"+NamePattern+(string)Depth+save,OBJPROP_STYLE,STYLE_DOT);
   ObjectSet("RealLineAB_"+NamePattern+(string)Depth+save,OBJPROP_RAY,false);
   ObjectSet("RealLineAB_"+NamePattern+(string)Depth+save,OBJPROP_WIDTH,2);
   ObjectCreate("RealLineBC_"+NamePattern+(string)Depth+save,OBJ_TREND,0,Time[B],zz[B],Time[C],zz[C]);
   ObjectSet("RealLineBC_"+NamePattern+(string)Depth+save,OBJPROP_COLOR,SkyBlue);
   ObjectSet("RealLineBC_"+NamePattern+(string)Depth+save,OBJPROP_STYLE,STYLE_DOT);
   ObjectSet("RealLineBC_"+NamePattern+(string)Depth+save,OBJPROP_RAY,false);
   ObjectSet("RealLineBC_"+NamePattern+(string)Depth+save,OBJPROP_WIDTH,2);
   ObjectCreate("RealLineCD_"+NamePattern+(string)Depth+save,OBJ_TREND,0,Time[C],zz[C],Time[D],zz[D]);
   ObjectSet("RealLineCD_"+NamePattern+(string)Depth+save,OBJPROP_COLOR,SkyBlue);
   ObjectSet("RealLineCD_"+NamePattern+(string)Depth+save,OBJPROP_STYLE,STYLE_DOT);
   ObjectSet("RealLineCD_"+NamePattern+(string)Depth+save,OBJPROP_RAY,false);
   ObjectSet("RealLineCD_"+NamePattern+(string)Depth+save,OBJPROP_WIDTH,2);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*----------------------------------------------
�������� ��������. ������.
-----------------------------------------------/
void DeleteObject()
{
 string name;
   for(int i=0;i<ObjectsTotal();i++)
   {
    name=ObjectName(i);
    if(StringSubstr(name,0,4)=="Real" || StringSubstr(name,0,4)=="Futu")
    {ObjectDelete(name);}
   }
}
/*------------------------------------------------
�������� ��������. �����.
-----------------------------------------------*/
//+------------------------------------------------------------------+
//|���������� WW. ������.                                            |
//+------------------------------------------------------------------+
void WolfWavesDraw(string NamePattern,string BullBear,int Depth,datetime t1,datetime t2,datetime t3,datetime t4,datetime t5,datetime t6,datetime t7,datetime t8,datetime t9,double p1,double p2,double p3,double p4,double p5,double p6,double p7,double p8,double p9)
  {
   ObjectCreate("RealRetXB_"+NamePattern+(string)Depth+save,OBJ_TREND,0,t1,p1,t6,p6);
   ObjectSet("RealRetXB_"+NamePattern+(string)Depth+save,OBJPROP_COLOR,Blue);
   ObjectSet("RealRetXB_"+NamePattern+(string)Depth+save,OBJPROP_RAY,false);
   ObjectCreate("RealRetXD_"+NamePattern+(string)Depth+save,OBJ_TREND,0,t1,p1,t8,p8);
   ObjectSet("RealRetXD_"+NamePattern+(string)Depth+save,OBJPROP_COLOR,Red);
   ObjectSet("RealRetXD_"+NamePattern+(string)Depth+save,OBJPROP_RAY,false);
   ObjectCreate("RealRetAC_"+NamePattern+(string)Depth+save,OBJ_TREND,0,t2,p2,t4,p4);
   ObjectSet("RealRetAC_"+NamePattern+(string)Depth+save,OBJPROP_COLOR,Blue);
   ObjectSet("RealRetAC_"+NamePattern+(string)Depth+save,OBJPROP_RAY,false);
//----
   if(SweetZoneStart)
     {
      ObjectCreate("Real1_"+NamePattern+(string)Depth+save,OBJ_TRIANGLE,0,t3,p3,t6,p6,t7,p7);
      ObjectSet("Real1_"+NamePattern+(string)Depth+save,OBJPROP_COLOR,SZScolor);
      ObjectSetText("Real1_"+NamePattern+(string)Depth+save,NamePattern+"-"+BullBear+"_"+TimeFrame()+"_"+(string)Depth);
     }
   if(SweetZoneEnd)
     {
      ObjectCreate("Real2_"+NamePattern+(string)Depth+save,OBJ_TRIANGLE,0,t1,p1,t3,p3,t8,p8);
      ObjectCreate("Real3_"+NamePattern+(string)Depth+save,OBJ_TRIANGLE,0,t3,p3,t8,p8,t9,p9);
      ObjectSet("Real2_"+NamePattern+(string)Depth+save,OBJPROP_COLOR,SZEcolor);
      ObjectSet("Real3_"+NamePattern+(string)Depth+save,OBJPROP_COLOR,SZEcolor);
      ObjectSetText("Real2_"+NamePattern+(string)Depth+save,NamePattern+"-"+BullBear+"_"+TimeFrame()+"_"+(string)Depth);
      ObjectSetText("Real3_"+NamePattern+(string)Depth+save,NamePattern+"-"+BullBear+"_"+TimeFrame()+"_"+(string)Depth);
     }
  }
//+------------------------------------------------------------------------+
//| ������� ���������� �������� ������, ����� �� �� ������� �� ����.������.|
//+------------------------------------------------------------------------+
double TextEdit()
  {
   double MaxPrice,MinPrice,Diapazon,PixelsOfPips,edit;
//----
   MaxPrice=WindowPriceMax();// ������������ ���� � ������� ����
   MinPrice=WindowPriceMin();// ����������� ���� � ������� ����
   Diapazon=MaxPrice-MinPrice; // ����� ����� ������� ��������� �� ����������� �����������, ����� �������� ��������� � �������, �� � ����� �������� �������� ������ �������, ������� � �� �����.
   PixelsOfPips=VPixels/Diapazon; // ���-�� �������� �� 1 �����
   edit=19/PixelsOfPips; /* ��� 19 - ��� ������ � �������� ���������� ������� */
//Comment("edit: ",edit,"\n","Left: ",rect[0]," Top: ",rect[1]," Right: ",rect[2]," Bottom: ",rect[3],"\n","MaxPrice=",WindowPriceMax(),"; MinPrice=",WindowPriceMin());
   return(edit);
  }
//+-----------------------------------------------------------------------------------------+
//|������� ���������� ���� ������� ������, ����� �� �� ������� �� ����� ������������.������.|                                                                  |
//+-----------------------------------------------------------------------------------------+
double AngleEdit(int BarPoint1,double PricePoint1,int BarPoint2,double PricePoint2)
  {
   double MaxPrice,MinPrice,Angle,edit;
   int BarChart;
//----
   MaxPrice=WindowPriceMax();// ������������ ���� � ������� ����
   MinPrice=WindowPriceMin();// ����������� ���� � ������� ����
   BarChart=WindowBarsPerChart(); // ���������� ����� ������������ � ����.
   Angle=MathArctan(((PricePoint2-PricePoint1)*VPixels/(MaxPrice-MinPrice))/((BarPoint1-BarPoint2)*GPixels/BarChart));
   edit=Angle*57.3;
   return(edit);
  }
//+------------------------------------------------------------------+
