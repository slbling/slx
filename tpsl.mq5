//+------------------------------------------------------------------+
//|                                                         tpsl.mq5 |
//|                                                 xxxforest@qq.com |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "xxxforest@qq.com"
#property link      "https://www.mql5.com"
#property version   "1.00"

#property description "Script creates \"Label\" graphical object."
//--- 启动脚本期间显示输入参数的窗口
#property script_show_inputs
//--- 脚本的输入参数
input string            InpName="Label";         // 标签名称
input int               InpX=150;                // X-轴距离
input int               InpY=150;                // Y-轴距离
input string            InpFont="Arial";         // 字体
input double            InpAngle=0.0;            // 倾斜角度
input ENUM_ANCHOR_POINT InpAnchor=ANCHOR_LEFT_UPPER; // 定位类型
input bool              InpBack=false;           // 背景对象
input bool              InpSelection=true;       // 突出移动
input bool              InpHidden=true;          // 隐藏对象列表中
input long              InpZOrder=0;             // 鼠标单击优先
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int orders_buy,orders_sell;
int orders_all,lots_all;
double buy_lots,sell_lots,net_lots;
double buy_pro,sell_pro;
double buy_av,sell_av;
double balance_point,pro;
double stopout,pp;
string sb = "";
int OnInit()
  {
//-
   int orders_buy,orders_sell;
   int orders_all,lots_all;
   double buy_lots,sell_lots,net_lots;
   double buy_pro,sell_pro;
   double buy_av,sell_av;
   double balance_point,pro;
   double stopout,pp;
   string sb = "";

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   ObjectsDeleteAll(0,-1,-1);
  }
//+------------------------------------------------------------------+
//| 创建文本标签                                                       |
//+------------------------------------------------------------------+
bool LabelCreate(const long              chart_ID=0,               // 图表 ID
                 const string            name="Label",             // 标签名称
                 const int               sub_window=0,             // 子窗口指数
                 const int               x=0,                      // X 坐标
                 const int               y=0,                      // Y 坐标
                 const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // 图表定位角
                 const string            text="Label",             // 文本
                 const string            font="微软雅黑",             // 字体
                 const int               font_size=8,             // 字体大小
                 const color             clr=clrRed,               // 颜色
                 const double            angle=0.0,                // 文本倾斜
                 const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // 定位类型
                 const bool              back=false,               // 在背景中
                 const bool              selection=false,          // 突出移动
                 const bool              hidden=true,              // 隐藏在对象列表
                 const long              z_order=0)                // 鼠标单击优先
  {
//--- 重置错误的值
   ResetLastError();
//--- 创建文本标签
   if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create text label! Error code = ",GetLastError());
      return(false);
     }
//--- 设置标签坐标
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- 设置相对于定义点坐标的图表的角
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- 设置文本
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- 设置文本字体
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- 设置字体大小
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- 设置文本的倾斜角
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
//--- 设置定位类型
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
//--- 设置颜色
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- 显示前景 (false) 或背景 (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- 启用 (true) 或禁用 (false) 通过鼠标移动标签的模式
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- 在对象列表隐藏(true) 或显示 (false) 图形对象名称
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- 设置在图表中优先接收鼠标点击事件
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- 成功执行
   return(true);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//--- 在本地变量存储标签坐标
   int x=InpX;
   int y=InpY;
//--- 图表窗口大小
   long x_distance;
   long y_distance;
//--- 设置窗口大小
   if(!ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0,x_distance))
     {
      Print("Failed to get the chart width! Error code = ",GetLastError());
      return;
     }
   if(!ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0,y_distance))
     {
      Print("Failed to get the chart height! Error code = ",GetLastError());
      return;
     }
//--- 检查输入参数的正确性
   if(InpX<0 || InpX>x_distance-1 || InpY<0 || InpY>y_distance-1)
     {
      Print("Error! Incorrect values of input parameters!");
      return;
     }
//================================================================================================================
   LabelCreate(0,"label"+1,0,30,50,CORNER_LEFT_UPPER,"净手数 "+getev(),InpFont,12,clrMediumSpringGreen,InpAngle,InpAnchor,InpBack,false,InpHidden,InpZOrder);
   LabelCreate(0,"label"+2,0,30,80,CORNER_LEFT_UPPER,"盈利点 "+(string)yld(),InpFont,12,clrYellow,InpAngle,InpAnchor,InpBack,false,InpHidden,InpZOrder);
   LabelCreate(0,"label"+3,0,30,110,CORNER_LEFT_UPPER,"浮盈亏合计 "+(string)tprofit(),InpFont,12,clrMagenta,InpAngle,InpAnchor,InpBack,false,InpHidden,InpZOrder);
   LabelCreate(0,"label"+4,0,30,140,CORNER_LEFT_UPPER,"当前点位 "+(string)cpoint(),InpFont,12,clrDodgerBlue,InpAngle,InpAnchor,InpBack,false,InpHidden,InpZOrder);
   LabelCreate(0,"label"+5,0,30,170,CORNER_LEFT_UPPER,"爆仓点 "+(string)pcd(),InpFont,15,clrRed,InpAngle,InpAnchor,InpBack,false,InpHidden,InpZOrder);
   LabelCreate(0,"label"+6,0,30,280,CORNER_LEFT_UPPER,"多单手数合计 "+(string)getbuyvolume(),InpFont,10,clrTomato,InpAngle,InpAnchor,InpBack,false,InpHidden,InpZOrder);
   LabelCreate(0,"label"+7,0,30,300,CORNER_LEFT_UPPER,"多单数量 "+(string)getbuytotal(),InpFont,10,clrTomato,InpAngle,InpAnchor,InpBack,false,InpHidden,InpZOrder);
   LabelCreate(0,"label"+8,0,30,320,CORNER_LEFT_UPPER,"多单浮盈亏 "+(string)buyprofit(),InpFont,10,clrTomato,InpAngle,InpAnchor,InpBack,false,InpHidden,InpZOrder);
   LabelCreate(0,"label"+9,0,30,340,CORNER_LEFT_UPPER,"多单仓位 "+(string)buycw(),InpFont,10,clrTomato,InpAngle,InpAnchor,InpBack,false,InpHidden,InpZOrder);
   LabelCreate(0,"label"+10,0,30,380,CORNER_LEFT_UPPER,"空单手数合计 "+(string)getsellvolume(),InpFont,10,clrLime,InpAngle,InpAnchor,InpBack,false,InpHidden,InpZOrder);
   LabelCreate(0,"label"+11,0,30,400,CORNER_LEFT_UPPER,"空单数量 "+(string)getselltotal(),InpFont,10,clrLime,InpAngle,InpAnchor,InpBack,false,InpHidden,InpZOrder);
   LabelCreate(0,"label"+12,0,30,420,CORNER_LEFT_UPPER,"空单浮盈亏 "+(string)sellprofit(),InpFont,10,clrLime,InpAngle,InpAnchor,InpBack,false,InpHidden,InpZOrder);
   LabelCreate(0,"label"+13,0,30,440,CORNER_LEFT_UPPER,"空单仓位 "+(string)sellcw(),InpFont,10,clrLime,InpAngle,InpAnchor,InpBack,false,InpHidden,InpZOrder);
//================================================================================================================

  }
//+------------------------------------------------------------------+
int getbuytotal()//获取多单数量
  {
//--- 订单属性返回值的变量
   int countbuy=0;
   ulong    ct;

   ENUM_POSITION_TYPE   cty;

//--- 当前单量
   uint     ctotal=PositionsTotal();

//--- 反复检查通过订单
   for(uint i=0; i<ctotal; i++)
     {
      //--- 通过列表中的仓位返回订单报价
      string position_symbol=PositionGetString(POSITION_SYMBOL);                        // 交易品种
      if(position_symbol!=_Symbol)
         continue;
      if(ct=PositionGetTicket(i))
        {
         //--- 返回订单属性

         cty     =ENUM_POSITION_TYPE(PositionGetInteger(POSITION_TYPE));
         if(cty==POSITION_TYPE_BUY)
           {
            countbuy++;
           }
        }
     }
   return countbuy;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int getselltotal()//获取空单数量
  {
//--- 订单属性返回值的变量
   int countsell=0;
   ulong    ct;

   ENUM_POSITION_TYPE   cty;

//--- 当前单量
   uint     ctotal=PositionsTotal();

//--- 反复检查通过订单
   for(uint i=0; i<ctotal; i++)
     {
      string position_symbol=PositionGetString(POSITION_SYMBOL);                        // 交易品种
      if(position_symbol!=_Symbol)
         continue;
      //--- 通过列表中的仓位返回订单报价
      if(ct=PositionGetTicket(i))
        {
         //--- 返回订单属性
         cty     =ENUM_POSITION_TYPE(PositionGetInteger(POSITION_TYPE));
         if(cty==POSITION_TYPE_SELL)
           {
            countsell++;
           }
        }
     }
   return countsell;
  }
//+------------------------------------------------------------------+
double getsellvolume()//获取空单手数
  {
//--- 订单属性返回值的变量
   double csev=NormalizeDouble(0,2);
   ulong    ct;

   ENUM_POSITION_TYPE   cty;

//--- 当前单量
   uint     ctotal=PositionsTotal();

//--- 反复检查通过订单
   for(uint i=0; i<ctotal; i++)
     {
      //--- 通过列表中的仓位返回订单报价
      string position_symbol=PositionGetString(POSITION_SYMBOL);                        // 交易品种
      if(position_symbol!=_Symbol)
         continue;
      if(ct=PositionGetTicket(i))
        {
         //--- 返回订单属性
         //csev =PositionGetDouble(POSITION_VOLUME);
         cty  =ENUM_POSITION_TYPE(PositionGetInteger(POSITION_TYPE));
         if(cty==POSITION_TYPE_SELL)
           {
            csev=csev+PositionGetDouble(POSITION_VOLUME);
           }
        }
     }
   return csev;
  }
//+------------------------------------------------------------------+
double getbuyvolume()//获取多单手数
  {
//--- 订单属性返回值的变量
   double cbuv=NormalizeDouble(0,2);
   ulong    ct;

   ENUM_POSITION_TYPE   cty;

//--- 当前单量
   uint     ctotal=PositionsTotal();

//--- 反复检查通过订单
   for(uint i=0; i<ctotal; i++)
     {
      //--- 通过列表中的仓位返回订单报价
      string position_symbol=PositionGetString(POSITION_SYMBOL);                        // 交易品种
      if(position_symbol!=_Symbol)
         continue;
      if(ct=PositionGetTicket(i))
        {
         //--- 返回订单属性
         //csev =PositionGetDouble(POSITION_VOLUME);
         cty  =ENUM_POSITION_TYPE(PositionGetInteger(POSITION_TYPE));
         if(cty==POSITION_TYPE_BUY)
           {
            cbuv=cbuv+PositionGetDouble(POSITION_VOLUME);
           }
        }
     }
   return cbuv;
  }
//+------------------------------------------------------------------+
double cpoint()//当前点位
  {
   double a;
   a=(SymbolInfoDouble(Symbol(),SYMBOL_ASK)+SymbolInfoDouble(Symbol(),SYMBOL_BID))/2;
   a=NormalizeDouble(a,_Digits);
   return a;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
double buyprofit()//获取多单盈利
  {
//--- 订单属性返回值的变量
   double bp=NormalizeDouble(0,2);
   ulong    ct;

   ENUM_POSITION_TYPE   cty;

//--- 当前单量
   uint     ctotal=PositionsTotal();

//--- 反复检查通过订单
   for(uint i=0; i<ctotal; i++)
     {
      //--- 通过列表中的仓位返回订单报价
      ulong  position_ticket=PositionGetTicket(i);                                      // 持仓价格
      string position_symbol=PositionGetString(POSITION_SYMBOL);                        // 交易品种
      //--- 输出持仓信息
      if(position_symbol!=_Symbol)
         continue;
      if(ct=PositionGetTicket(i))
        {
         //--- 返回订单属性
         //csev =PositionGetDouble(POSITION_VOLUME);
         cty  =ENUM_POSITION_TYPE(PositionGetInteger(POSITION_TYPE));
         if(cty==POSITION_TYPE_BUY)
           {
            bp=bp+PositionGetDouble(POSITION_PROFIT);
            bp=NormalizeDouble(bp,_Digits);
           }
        }
     }
   return bp;
  }
//+------------------------------------------------------------------+
double sellprofit()//获取空单盈利
  {
//--- 订单属性返回值的变量
   double sp=NormalizeDouble(0,2);
   ulong    ct;

   ENUM_POSITION_TYPE   cty;

//--- 当前单量
   uint     ctotal=PositionsTotal();

//--- 反复检查通过订单
   for(uint i=0; i<ctotal; i++)
     {
      //--- 通过列表中的仓位返回订单报价
      ulong  position_ticket=PositionGetTicket(i);                                      // 持仓价格
      string position_symbol=PositionGetString(POSITION_SYMBOL);                        // 交易品种
      //--- 输出持仓信息
      if(position_symbol!=_Symbol)
         continue;
      if(ct=PositionGetTicket(i))
        {
         //--- 返回订单属性
         //csev =PositionGetDouble(POSITION_VOLUME);
         cty  =ENUM_POSITION_TYPE(PositionGetInteger(POSITION_TYPE));
         if(cty==POSITION_TYPE_SELL)
           {
            sp=sp+PositionGetDouble(POSITION_PROFIT);
            sp=NormalizeDouble(sp,_Digits);
           }
        }
     }
   return sp;
  }
//+------------------------------------------------------------------+
double tprofit()//获取空单盈利
  {
//--- 订单属性返回值的变量
   double tpr=NormalizeDouble(0,2);
   ulong  ct;
   ENUM_POSITION_TYPE   cty;

//--- 当前单量
   uint     ctotal=PositionsTotal();

//--- 反复检查通过订单
   for(uint i=0; i<ctotal; i++)
     {
      ulong  position_ticket=PositionGetTicket(i);                                      // 持仓价格
      string position_symbol=PositionGetString(POSITION_SYMBOL);                        // 交易品种
      //--- 输出持仓信息
      if(position_symbol!=_Symbol)
         continue;
      //--- 通过列表中的仓位返回订单报价
      if(ct=PositionGetTicket(i))
        {
         //--- 返回订单属性
         //csev =PositionGetDouble(POSITION_VOLUME);

         tpr=tpr+PositionGetDouble(POSITION_PROFIT);
         tpr=NormalizeDouble(tpr,_Digits);
        }
     }
   return tpr;
  }

//+------------------------------------------------------------------+
string getev()//获取净手数
  {
//getbuyvolume()//多单手数
//getsellvolume()//空单手数
   if(getbuyvolume()==getsellvolume())  //多单空单相等；
     {
      return (string)NormalizeDouble(0,2);
     }
   if(getbuyvolume()>getsellvolume())
     {
      return "buy"+(string)(getbuyvolume()-getsellvolume());
     }
   if(getbuyvolume()<getsellvolume())
     {
      return "sell"+(string)(getsellvolume()-getbuyvolume());
     }
   else
      return " ";
  }
//+------------------------------------------------------------------+
double buycw()//获取多单仓位
  {
   double vv=0;
   double pp=0;
   int total=PositionsTotal(); // 持仓数
//--- 重做所有持仓
   for(int i=total-1; i>=0; i--)
     {
      ulong  position_ticket=PositionGetTicket(i);                                      // 持仓价格
      double v=PositionGetDouble(POSITION_VOLUME);                                      // 持仓交易量
      double p=PositionGetDouble(POSITION_PRICE_OPEN);                                  // 持仓交易量
      ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);    // 持仓类型
      string position_symbol=PositionGetString(POSITION_SYMBOL);                        // 交易品种
      if(position_symbol!=_Symbol)
         continue;
      if(type==POSITION_TYPE_BUY)
        {
         pp=pp+v*p;
         vv=vv+v;
        }
     }
   if(vv==0)
      return 0.0;
   else
      return(NormalizeDouble(pp/vv,_Digits));
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double sellcw()//获取空单仓位
  {
   double vv=0;
   double pp=0;
   int total=PositionsTotal(); // 持仓数
//--- 重做所有持仓
   for(int i=total-1; i>=0; i--)
     {
      ulong  position_ticket=PositionGetTicket(i);                                      // 持仓价格
      double v=PositionGetDouble(POSITION_VOLUME);                                      // 持仓交易量
      double p=PositionGetDouble(POSITION_PRICE_OPEN);                                  // 持仓交易量
      ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);    // 持仓类型
      string position_symbol=PositionGetString(POSITION_SYMBOL);                        // 交易品种
      if(position_symbol!=_Symbol)
         continue;
      if(type==POSITION_TYPE_SELL)
        {
         pp=pp+v*p;
         vv=vv+v;
        }
     }
   if(vv==0)
      return 0.0;
   else
      return(NormalizeDouble(pp/vv,_Digits));
  }
//+------------------------------------------------------------------+
//多空平衡点 = (多单仓位*多单手数 - 空单仓位*空单手数) / 净手数
double yld()
  {
   if(getbuyvolume()==getsellvolume())  //多单空单相等；
     {
      return NormalizeDouble(0,2);
     }
   if(getbuyvolume()>getsellvolume())
     {
      return NormalizeDouble((buycw()*getbuyvolume() - sellcw()*getsellvolume())/((getbuyvolume()-getsellvolume())),_Digits);
     }
   if(getbuyvolume()<getsellvolume())
     {
      return NormalizeDouble((buycw()*getbuyvolume() - sellcw()*getsellvolume())/((getsellvolume()-getbuyvolume())),_Digits);
     }
   else
      return 0;
  }
//+------------------------------------------------------------------+
double pcd()//暴仓点 = 余额 - (可用预付款*杠杆*0.01) /净手数*最小点*当前品种每一点对应的金额(美元)
  {
   double  c=0;
   if(getsellvolume()==getbuyvolume())
      return NormalizeDouble(c,_Digits);
   if(getsellvolume()>getbuyvolume())
     {
      c=(AccountInfoDouble(ACCOUNT_BALANCE)-(AccountInfoDouble(ACCOUNT_MARGIN_FREE)*AccountInfoInteger(ACCOUNT_LEVERAGE)*0.01))
        /(getsellvolume()-getbuyvolume())*_Point*SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
      return NormalizeDouble(c,_Digits);
     }
   if(getsellvolume()<getbuyvolume())
     {
      c = (AccountInfoDouble(ACCOUNT_BALANCE)-
           (AccountInfoDouble(ACCOUNT_MARGIN_FREE)*AccountInfoInteger(ACCOUNT_LEVERAGE)*0.01))/
          (getbuyvolume()-getsellvolume())*_Point*SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);

      return NormalizeDouble(c,_Digits);
     }
   else
      return NormalizeDouble(c,_Digits);
  }
//+------------------------------------------------------------------+
