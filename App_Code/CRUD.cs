using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Data.Common;
using System.Text;

/// <summary>
///CRUD 的摘要说明

/// </summary>
public class CRUD
{
    static DbUtility iModuleHelp = new DbUtility(System.Configuration.ConfigurationManager.ConnectionStrings["iMESModule"].ToString(), DbProviderType.Oracle );
    static DbUtility iModuleHelp1 = new DbUtility(System.Configuration.ConfigurationManager.ConnectionStrings["iMESModule"].ToString(), DbProviderType.SqlServer);

    public CRUD()
    {
        //
        //TODO: 在此处添加构造函数逻辑
        //


    }

    public static DataTable  QueryLot(string lot)
    {
        string sql = "select BASELOTNO,PMAX,ISC,VOC,IPM,VPM,RS,RSH,FF,\"Comment\" EQP,TESTTIME TIME from tblwiplotbasis where baselotno = '" + lot + "'";
        return iModuleHelp.ExecuteDataTable(sql, null);
    }

    public static DataTable QueryPallet(string Palletno)
    {
        string sql = "select BASELOTNO,PMAX,ISC,VOC,IPM,VPM,RS,RSH,FF,\"Comment\" EQP,TESTTIME TIME " 
                   +"from tblwiplotbasis a , TBLWIPCARTONDATADETAIL b "  
                   +"where a.baselotno = b.moduleno and cartonno = '"+Palletno +"'";
        return iModuleHelp.ExecuteDataTable(sql, null);
    }

    public static DataTable QueryPmaxByLot(string lot)
    {
        string sql = 
        " select a.pmax " +
        " ,a.cellpower " +
        " ,a.pmax " +
        " ,a.baselotno " +
        " ,a.productno " +
        " ,b.factoryno " +
        " ,c.modulecellqty " +
        " ,d.lowerlimit "+
        " ,d.upperlimit "+
        " from tblwiplotbasis a  " +
        " inner join tblwiplotstate b on a.baselotno = b.lotno " +
        " inner join tblprdproductbasis c on a.productno = c.productno " +
        " left join tblctmconfig d on d.workshop = b.factoryno and d.cellpower = a.cellpower and d.modulecellqty = c.modulecellqty "+
        " where a.baselotno = '"+lot+"'";
        //sql = " select * from tblctmconfig ";
        return iModuleHelp.ExecuteDataTable(sql, null);

    }

 




    /// <summary>     
    /// Datatable转换为Json     
    /// </summary>    
    /// <param name="table">Datatable对象</param>     
    /// <returns>Json字符串</returns>     
    public static string ToJson(DataTable dt)
    {
        StringBuilder jsonString = new StringBuilder();
        //jsonString.Append("{\"");
        //jsonString.Append("tbjson");
        //jsonString.Append("\":[");
        jsonString.Append("[");
        DataRowCollection drc = dt.Rows;
        for (int i = 0; i < drc.Count; i++)
        {
            jsonString.Append("{");
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                string strKey = dt.Columns[j].ColumnName;
                string strValue = drc[i][j].ToString();
                Type type = dt.Columns[j].DataType;
                jsonString.Append("\"" + strKey + "\":");
                strValue = StringFormat(strValue, type);
                if (j < dt.Columns.Count - 1)
                {
                    jsonString.Append(strValue + ",");
                }
                else
                {
                    jsonString.Append(strValue);
                }
            }
            jsonString.Append("},");
        }
        jsonString.Remove(jsonString.Length - 1, 1);
        jsonString.Append("]");
        return jsonString.ToString();
    }
    /// <summary>
    /// 格式化字符型、日期型、布尔型
    /// </summary>
    /// <param name="str"></param>
    /// <param name="type"></param>
    /// <returns></returns>
    private static string StringFormat(string str, Type type)
    {
        if (type == typeof(string))
        {
            str = String2Json(str);
            str = "\"" + str + "\"";
        }
        else if (type == typeof(DateTime))
        {
            str = "\"" + str + "\"";
        }
        else if (type == typeof(bool))
        {
            str = str.ToLower();
        }
        else if (type != typeof(string) && string.IsNullOrEmpty(str))
        {
            str = "\"" + str + "\"";
        }
        return str;
    }
    /// <summary>
    /// 过滤特殊字符
    /// </summary>
    /// <param name="s">字符串</param>
    /// <returns>json字符串</returns>
    private static string String2Json(String s)
    {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < s.Length; i++)
        {
            char c = s.ToCharArray()[i];
            switch (c)
            {
                case '\"':
                    sb.Append("\\\""); break;
                case '\\':
                    sb.Append("\\\\"); break;
                case '/':
                    sb.Append("\\/"); break;
                case '\b':
                    sb.Append("\\b"); break;
                case '\f':
                    sb.Append("\\f"); break;
                case '\n':
                    sb.Append("\\n"); break;
                case '\r':
                    sb.Append("\\r"); break;
                case '\t':
                    sb.Append("\\t"); break;
                default:
                    sb.Append(c); break;
            }
        }
        return sb.ToString();
    }
    //#region dataTable转换成Json格式
    ///// <summary>      
    ///// dataTable转换成Json格式      
    ///// </summary>      
    ///// <param name="dt"></param>      
    ///// <returns></returns>      
    //private static string ToJson(DataTable dt, int count)
    //{
    //    StringBuilder jsonBuilder = new StringBuilder();
    //    jsonBuilder.Append("{\"");
    //    jsonBuilder.Append("tbjson");
    //    jsonBuilder.Append("\":[");
    //    for (int i = 0; i < dt.Rows.Count; i++)
    //    {
    //        jsonBuilder.Append("{");
    //        for (int j = 0; j < dt.Columns.Count; j++)
    //        {
    //            jsonBuilder.Append("\"");
    //            jsonBuilder.Append(dt.Columns[j].ColumnName);
    //            jsonBuilder.Append("\":\"");
    //            jsonBuilder.Append(dt.Rows[i][j].ToString());
    //            jsonBuilder.Append("\",");
    //        }
    //        jsonBuilder.Remove(jsonBuilder.Length - 1, 1);
    //        jsonBuilder.Append("},");
    //    }
    //    //jsonBuilder.Remove(jsonBuilder.Length - 1, 1);

    //    //添加行数
    //    jsonBuilder.Append("{");
    //    jsonBuilder.Append("\"");
    //    jsonBuilder.Append("rowcount");
    //    jsonBuilder.Append("\":\"");
    //    jsonBuilder.Append(count.ToString());
    //    jsonBuilder.Append("\"");
    //    jsonBuilder.Append("}");
    //    //添加行数
    //    jsonBuilder.Append("]");
    //    jsonBuilder.Append("}");
    //    return jsonBuilder.ToString();
    //}

    //#endregion dataTable转换成Json格式
}
