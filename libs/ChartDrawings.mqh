//+------------------------------------------------------------------+
//|                                                ChartDrawings.mqh |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include <Object.mqh>

class CChartDrawing : public CObject
{
   public:
      void Link(string name, long chartId = NULL, int window = 0)
      {
         this._name = name;
         this._window = window;
         this._chartId = chartId == NULL ? ChartID() : chartId;
         this._linked = true;
      }
      
      void Unlink()
      {
         this._name = NULL;
         this._window = -1;
         this._chartId = -1;
         this._linked = false;
      }
      
      void Delete()
      {
         ObjectDelete(this._chartId, this._name);
         Unlink();
      }
      
      static bool Exists(string name, long chartId = NULL)
      {
         return ObjectFind(chartId == NULL ? ChartID() : chartId, name) >= 0;
      }
      
      datetime Time(int point) { return (datetime)this.GetInt(OBJPROP_TIME, point); }
      double Price(int point) { return this.GetDbl(OBJPROP_PRICE, point); }
      
   protected:
      CChartDrawing() { this.Unlink(); }
      
      void SetObj(int prop, double value) { ObjectSet(this._name, prop, value); }
      void SetInt(ENUM_OBJECT_PROPERTY_INTEGER prop, int value) { ObjectSetInteger(this._chartId, this._name, prop, value); }
      void SetInt(ENUM_OBJECT_PROPERTY_INTEGER prop, long value, int mod) { ObjectSetInteger(this._chartId, this._name, prop, mod, value); }
      long GetInt(ENUM_OBJECT_PROPERTY_INTEGER prop) { return ObjectGetInteger(this._chartId, this._name, prop); }
      long GetInt(ENUM_OBJECT_PROPERTY_INTEGER prop, int mod) { return ObjectGetInteger(this._chartId, this._name, prop, mod); }
      void SetStr(ENUM_OBJECT_PROPERTY_STRING prop, string value, int mod) { ObjectSetString(this._chartId, this._name, prop, mod, value); }
      void SetStr(ENUM_OBJECT_PROPERTY_STRING prop, string value) { ObjectSetString(this._chartId, this._name, prop, value); }
      void SetDbl(ENUM_OBJECT_PROPERTY_DOUBLE prop, double value) { ObjectSetDouble(this._chartId, this._name, prop, value); }
      void SetDbl(const ENUM_OBJECT_PROPERTY_DOUBLE prop, const double value, int mod) { ObjectSetDouble(this._chartId, this._name, prop, mod, value); }
      double GetDbl(ENUM_OBJECT_PROPERTY_DOUBLE prop, int mod) { return ObjectGetDouble(this._chartId, this._name, prop, mod); }
      double GetDbl(ENUM_OBJECT_PROPERTY_DOUBLE prop) { return ObjectGetDouble(this._chartId, this._name, prop); }
      
      string _name;
      int _window;
      long _chartId;
      bool _linked;
};

class CVLine : public CChartDrawing
{
   public:
      bool Create(string objName, datetime time)
      {
         Link(objName);
         this.Delete();
         if(!ObjectCreate(ChartID(), objName, OBJ_VLINE, 0, time, 0.0))
            return false;
         Link(objName);
         Selectable(false);
         return true;
      }
      
     CVLine * Color(const color clr)
      {
         this.SetObj(OBJPROP_COLOR, clr);
         return &this;
      }
      
      CVLine * Selectable(const bool selectable)
      {
         this.SetObj(OBJPROP_SELECTABLE, selectable);
         return &this;
      }
      
      CVLine * Style(const ENUM_LINE_STYLE lineStyle)
      {
         this.SetObj(OBJPROP_STYLE, lineStyle);
         return &this;
      }
      
      CVLine * Background(const bool background)
      {
         this.SetObj(OBJPROP_BACK, background);
         return &this;
      }
      
      CVLine * Width(const double width)
      {
         this.SetObj(OBJPROP_WIDTH, width);
         return &this;
      }
};

class CHLine : public CChartDrawing
{
   public:
      bool Create(string objName, double price)
      {
         Link(objName);
         this.Delete();
         if(!ObjectCreate(ChartID(), objName, OBJ_HLINE, 0, 0, price))
            return false;
         Link(objName);
         Selectable(false);
         return true;
      }
      
     CHLine * Color(const color clr)
      {
         this.SetObj(OBJPROP_COLOR, clr);
         return &this;
      }
      
      CHLine * Selectable(const bool selectable)
      {
         this.SetObj(OBJPROP_SELECTABLE, selectable);
         return &this;
      }
      
      CHLine * Style(const ENUM_LINE_STYLE lineStyle)
      {
         this.SetObj(OBJPROP_STYLE, lineStyle);
         return &this;
      }
      
      CHLine * Background(const bool background)
      {
         this.SetObj(OBJPROP_BACK, background);
         return &this;
      }
      
      CHLine * Width(const double width)
      {
         this.SetObj(OBJPROP_WIDTH, width);
         return &this;
      }
};

class CText : public CChartDrawing
{
   public:
      bool Create(string objName, datetime time, double price)
      {
         Link(objName);
         this.Delete();
         if(!ObjectCreate(ChartID(), objName, OBJ_TEXT, 0, time, price))
            return false;
         Link(objName);
         return true;
      }
      
      CText * Selectable(const bool selectable)
      {
         this.SetObj(OBJPROP_SELECTABLE, selectable);
         return &this;
      }
      
      CText * Color(const color clr)
      {
         this.SetObj(OBJPROP_COLOR, clr);
         return &this;
      }
      
      CText * Text(const string txt)
      {
         this.SetStr(OBJPROP_TEXT, txt);
         return &this;
      }
      
      CText * Background(const bool back)
      {
         this.SetObj(OBJPROP_BACK, back);
         return &this;
      }
      
      CText * FontSize(const int size)
      {
         this.SetInt(OBJPROP_FONTSIZE, size);
         return &this;
      }
      
      CText * Rotate(const int rotation)
      {
         this.SetDbl(OBJPROP_ANGLE, rotation);
         return &this;
      }
      
      CText * PivotPoint(ENUM_ANCHOR_POINT pivot)
      {
         this.SetObj(OBJPROP_ANCHOR, pivot);
         return &this;
      }
};

class CRectangle : public CChartDrawing
{
   public:
      bool Create(string objName, datetime time1, double price1, datetime time2, double price2)
      {
         this.Link(objName);
         this.Delete();
         if(!ObjectCreate(ChartID(), objName, OBJ_RECTANGLE, 0, time1, price1, time2, price2))
            return false;
         this.Link(objName);
         return true;
      }
      
      CRectangle * Color(const color clr)
      {
         this.SetObj(OBJPROP_COLOR, clr);
         return &this;
      }
      
      CRectangle * Background(const bool back)
      {
         this.SetObj(OBJPROP_BACK, back);
         return &this;
      }
      
      CRectangle * Selectable(const bool selectable)
      {
         this.SetObj(OBJPROP_SELECTABLE, selectable);
         return &this;
      }
      
      CRectangle * Width(const double width)
      {
         this.SetObj(OBJPROP_WIDTH, width);
         return &this;
      }
      
      CRectangle * Time(const int point, const datetime time)
      {
         this.SetInt(OBJPROP_TIME, time, point);
         return &this;
      }
      
      CRectangle * Price(const int point, const double price)
      {
         this.SetDbl(OBJPROP_PRICE, price, point);
         return &this;
      }
};

class CTrend : public CChartDrawing
{
   public:
      bool Create(string objName, datetime time1, double price1, datetime time2, double price2)
      {
         Link(objName);
         this.Delete();
         if(!ObjectCreate(ChartID(), objName, OBJ_TREND, 0, time1, price1, time2, price2))
            return false;
         this.Link(objName);
         return true;
      }
      
      CTrend * Color(const color clr)
      {
         this.SetObj(OBJPROP_COLOR, clr);
         return &this;
      }
      
      CTrend * Background(const bool back)
      {
         this.SetObj(OBJPROP_BACK, back);
         return &this;
      }
      
      CTrend * Selectable(const bool selectable)
      {
         this.SetObj(OBJPROP_SELECTABLE, selectable);
         return &this;
      }
      
      CTrend * Width(const double width)
      {
         this.SetObj(OBJPROP_WIDTH, width);
         return &this;
      }
      
      CTrend * Style(const ENUM_LINE_STYLE lineStyle)
      {
         this.SetInt(OBJPROP_STYLE, lineStyle);
         return &this;
      }
      
      CTrend * RayRight(const bool rayRight)
      {
         this.SetInt(OBJPROP_RAY_RIGHT, rayRight);
         return &this;
      }
};

class CTriangle : public CChartDrawing
{
   public:
      bool Create(string objName, datetime time1, double price1, datetime time2, double price2, datetime time3, double price3)
      {
         this.Link(objName);
         this.Delete();
         if(!ObjectCreate(ChartID(), objName, OBJ_TRIANGLE, 0, time1, price1, time2, price2, time3, price3))
            return false;
         this.Link(objName);
         return true;
      }
      
      CTriangle * Color(const color clr)
      {
         this.SetObj(OBJPROP_COLOR, clr);
         return &this;
      }
      
      CTriangle * Background(const bool back)
      {
         this.SetObj(OBJPROP_BACK, back);
         return &this;
      }
      
      CTriangle * Selectable(const bool selectable)
      {
         this.SetObj(OBJPROP_SELECTABLE, selectable);
         return &this;
      }
      
      CTriangle * Width(const double width)
      {
         this.SetObj(OBJPROP_WIDTH, width);
         return &this;
      }
      
      CTriangle * Style(const ENUM_LINE_STYLE lineStyle)
      {
         this.SetInt(OBJPROP_STYLE, lineStyle);
         return &this;
      }
      
      CTriangle * Time(const int point, const datetime time)
      {
         this.SetInt(OBJPROP_TIME, time, point);
         return &this;
      }
      
      CTriangle * Price(const int point, const double price)
      {
         this.SetDbl(OBJPROP_PRICE, price, point);
         return &this;
      }
};

class CFibo : public CChartDrawing
{
   public:
      bool Create(string objName, datetime time1, double price1, datetime time2, double price2)
      {
         this.Link(objName);
         this.Delete();
         if(!ObjectCreate(ChartID(), objName, OBJ_FIBO, 0, time1, price1, time2, price2))
            return false;
         this.Link(objName);
         return true;
      }
      
      CFibo * LevelsCount(int count)
      {
         this.SetInt(OBJPROP_LEVELS, count);
         return &this;
      }
      
      CFibo * LevelColor(int index, color clr)
      {
         this.SetInt(OBJPROP_LEVELCOLOR, clr, index);
         return &this;
      }
      
      CFibo * LevelValue(int index, double value)
      {
         this.SetDbl(OBJPROP_LEVELVALUE, value, index);
         return &this;
      }
      
      CFibo * LevelDesc(int index, string text)
      {
         this.SetStr(OBJPROP_LEVELTEXT, text, index);
         return &this;
      }
};
