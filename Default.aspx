<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="CSS/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="CSS/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="JS/jquery-1.8.3.min.js" type="text/javascript"></script>
    <script src="JS/highcharts.js" type="text/javascript"></script>
    <script src="JS/exporting.js" type="text/javascript"></script>
    <script src="JS/offline-exporting.js" type="text/javascript"></script>
    <script src="JS/jquery.easyui.min.js" type="text/javascript"></script>

     
     
     
 
</head>
<body>
    <form id="form1" runat= "server">
  <!--  <div style ="float:right; " >
    <input id="txtLot" type="text" />&nbsp; <input id="btnQuery" type="button" value="查询" onclick ="LoadChart()" />
</div>-->
<div class="easyui-panel1" style="width:100%;max-width:300px;float:right;">
		<input class="easyui-searchbox" data-options="prompt:'Please Input Value',menu:'#mm',searcher:doSearch" style="width:100%">
	</div>
	<div id="mm">
		<div data-options="name:'LotNo'">组件序列号</div>
		<div data-options="name:'PalletNo'">托盘号</div>
	</div>

    <div id ="Menu">
        <img alt="" src="pic/Logo.png" />
    </div>
 <div id = "Chart" style="">   
   
</div>
<script>
    function creatediv(index) {
        //index = 3;
        var div = document.getElementById("Chart");
        div.innerHTML = "";
        var divContent = "";
        for (var i = 1; i <= index; i++) {
            divContent = divContent+ ' <div id="container'+i.toString()+'" style="height:400px;margin:0 auto;width:600px;"align="center"></div>';
        }
        div.innerHTML = divContent;
    }
    function doSearch(value, name) {
        //alert('You input: ' + value + '(' + name + ')');
        LoadChart(name,value);
    }

    function LoadChart(name,value) {
        //var lotValue = document.getElementById('txtLot').value
        var senddata = { "Type":name,"lot": value };
        var jsonAry;
        $.ajax({
            url: "Webservices/ws.asmx/Querylot",
            //async:false,
            type: "post",
            //contentType: "application/json; charset=utf-8",
            dataType: "json",
            //data: "{ workshop: 'All', product: 'All', station: 'All',Index:1,Size:20 }",
            data: senddata,
            success: function (data) {
                //alert( data);
                //var jsonData = jQuery.parseJSON(data); //eval("(" + data + ")");
                if (data.error == "error") {
                    alert("没有查询到符合的数据！");
                    return false;
                }
                Print(data);
                //                jsonAry = [[0, parseFloat(data[0].ISC)], [parseFloat(data[0].VPM), parseFloat(data[0].IPM)], [parseFloat(data[0].VOC), 0]]
                //                PrintChart(jsonAry, lotValue,data,'#container');
            },
            //            complete: function (data) {
            //                var strType= typeof(data);
            //                var jsonData = jQuery.parseJSON(data);
            //            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                alert(XMLHttpRequest.status);
                alert(XMLHttpRequest.readyState);
                alert(textStatus);
            }
        });
    }

    function Print(data) {
        creatediv(data.length);
        for (var i = 0; i <= data.length-1; i++) {
            PrintChart(i + 1, data[i]);   
        }
    }

    //****生成图片*****//
    //****dataAry:数据
    //****lotNo:组件序列号
    //****jsonData:ajax返回的组件序列号json数据
    //****id:chart容器ID
    //*****************//
    function PrintChart(id,jsonData) {
        //循环json数组
        var divID = "container" + id.toString();
        var dataAry =  [[0, parseFloat(jsonData.ISC)], [parseFloat(jsonData.VPM), parseFloat(jsonData.IPM)], [parseFloat(jsonData.VOC), 0]]
        
        var chart = new Highcharts.Chart({
            chart:{
                renderTo : divID,
                type: 'spline'

            },
        
//        $("container1").highcharts({
//            chart: {
//                type: 'spline'
//                //inverted: true
//            },
            title: {
                text: 'I-V Curves'
            },
            subtitle: {
                text: jsonData.BASELOTNO
            },
            xAxis: {
                reversed: false,
                title: {
                    enabled: true,
                    text: 'Voltage(V)'
                },
                //                labels: {
                //                    formatter: function () {
                //                        return this.value + 'km';
                //                    }
                //                },
                maxPadding: 1,
                showLastLabel: true,
                gridLineWidth: 1,
                gridLineColor: '#C0C0C0',
                max: 60
            },
            yAxis: {
                title: {
                    text: 'Current'
                },
                staggerLines: 10,
                tickInterval: 1,
                showLastLabel: true,
                gridlineWidth: 1,
                gridLineColor: '#C0C0C0',
                gridLineDashStyle: 'Solid'
            },
            legend: {
                enabled: false
            },
            tooltip: {
                enabled: false
            },
            plotOptions: {
                spline: {
                    marker: {
                        enable: true
                    }
                }
            },

            labels: {
                style: {
                    color: "#006cee"
                },
                items: [
                {
                    html: 'Pmax : <p>' + jsonData.PMAX + '</p>',
                    style:
                    {
                        left: '340px',
                        top: '30px'
                    }
                },
                {
                    html: 'Isc : <p>' + jsonData.ISC + '</p>',
                    style:
                        {
                            left: '340px',
                            top: '45px'
                        }
                },
                    {
                        html: 'Voc : <p>' + jsonData.VOC + '</p>',
                        style:
                        {
                            left: '340px',
                            top: '60px'
                        }
                    },
                    {
                        html: 'Ipm : <p>' + jsonData.IPM + '</p>',
                        style:
                        {
                            left: '340px',
                            top: '75px'
                        }
                    },
                    {
                        html: 'Vpm : <p>' + jsonData.VPM + '</p>',
                        style:
                        {
                            left: '340px',
                            top: '90px'
                        }
                    },
                    {
                        html: 'Rs : <p>' + jsonData.RS + '</p>',
                        style:
                        {
                            left: '340px',
                            top: '105px'
                        }
                    },
                    {
                        html: 'Rsh : <p>' + jsonData.RSH + '</p>',
                        style:
                        {
                            left: '340px',
                            top: '120px'
                        }
                    },
                    {
                        html: 'FF : <p>' + jsonData.FF + '</p>',
                        style:
                        {
                            left: '340px',
                            top: '135px'
                        }
                    },
                    {
                        html: 'Eqp : <p>' + jsonData.EQP + '</p>',
                        style:
                        {
                            left: '340px',
                            top: '150px'
                        }
                    },
                    {
                        html: 'Time : <p>' + jsonData.TIME + '</p>',
                        style:
                        {
                            left: '340px',
                            top: '165px'
                        }
                    }

                ]
            },

            series: [{
                marker: { radius: 0,
                    symbol: 'circle'
                },
                name: 'Temperature',
                data: dataAry
            }]
        });

//        //-----
//        $('#container1').highcharts({
//            title: {
//                text: 'Monthly Average Temperature',
//                x: -20 //center
//            },
//            subtitle: {
//                text: 'Source: WorldClimate.com',
//                x: -20
//            },
//            xAxis: {
//                categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
//                         'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
//            },
//            yAxis: {
//                title: {
//                    text: 'Temperature (°C)'
//                },
//                plotLines: [{
//                    value: 0,
//                    width: 1,
//                    color: '#808080'
//                }]
//            },
//            tooltip: {
//                valueSuffix: '°C'
//            },
//            legend: {
//                layout: 'vertical',
//                align: 'right',
//                verticalAlign: 'middle',
//                borderWidth: 0
//            },
//            series: [{
//                name: 'Tokyo',
//                data: [7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]
//            }, {
//                name: 'New York',
//                data: [-0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5]
//            }, {
//                name: 'Berlin',
//                data: [-0.9, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6, 17.9, 14.3, 9.0, 3.9, 1.0]
//            }, {
//                name: 'London',
//                data: [3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8]
//            }]
//        });
//        //-----
    }
    </script>
    </form>
</body>
</html>
