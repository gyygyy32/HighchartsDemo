using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Data;
using System.Web.Script.Serialization;
/// <summary>
///ws 的摘要说明
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
//若要允许使用 ASP.NET AJAX 从脚本中调用此 Web 服务，请取消对下行的注释。 
 [System.Web.Script.Services.ScriptService]
public class ws : System.Web.Services.WebService {

    public ws () {

        //如果使用设计的组件，请取消注释以下行 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }

    [WebMethod]
    public string CheckCTM(string lot)
    {
        DataTable dt;
        JavaScriptSerializer js = new JavaScriptSerializer();
        double upper;
        double lower;
        double pmax;
        double modulecellqty;
        double cellpower;
        dt = CRUD.QueryPmaxByLot(lot);
        if (dt.Rows.Count > 0)
        {
            if (dt.Rows[0]["lowerlimit"].ToString() == "" || dt.Rows[0]["upperlimit"].ToString() == "")
            {
                return js.Serialize(new { error = "未查询到上下限设置" });
            }
            lower = Convert.ToDouble(dt.Rows[0]["lowerlimit"].ToString());
            upper = Convert.ToDouble(dt.Rows[0]["upperlimit"].ToString());
            pmax = Convert.ToDouble(dt.Rows[0]["pmax"].ToString());
            modulecellqty = Convert.ToDouble(dt.Rows[0]["modulecellqty"].ToString());
            cellpower = Convert.ToDouble(dt.Rows[0]["cellpower"].ToString());
            if (pmax / (cellpower * modulecellqty) >= lower && pmax / (cellpower * modulecellqty) <= upper)
            {
                return js.Serialize(new { result = "OK" });
            }
            else
            {
                return js.Serialize(new { result = "NG" });
            }

        }
        else
        {
           return js.Serialize(new { error = "未查询到该批次" });
        }
    }

    [WebMethod(Description = "查询批次")]
    public void Querylot(string lot,string Type)
    {
        DataTable dt;
        string strResult;
        if (Type == "LotNo")
        {
            dt = CRUD.QueryLot(lot);
        }
        else //if (Type == "PalletNo")
        {
            dt = CRUD.QueryPallet(lot);
        }
        if (dt.Rows.Count > 0)
        {
            strResult = CRUD.ToJson(dt);
            HttpContext.Current.Response.Write(strResult);
            HttpContext.Current.Response.End();
        }
        //else if (Type.ToString() == "ModuleID")
        //{
        //    HttpContext.Current.Response.Write("{\"error\":\"module\"}");
        //    HttpContext.Current.Response.End();
        //}
        else
        {
            HttpContext.Current.Response.Write("{\"error\":\"error\"}");
            HttpContext.Current.Response.End();
        }
    }
    
}
