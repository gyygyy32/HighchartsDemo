<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CIM.aspx.cs" Inherits="CIM" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <style>
        .hide {
            display: none;
        }
        #lotID {
            font-size:150px;
        }
    </style>
    
    <script src="JS/jquery-3.2.1.min.js"></script>
    <script type="text/javascript">
<%--        function EnterTextBox() {
            if (event.keyCode == 13 && document.getElementById("<%=txtLot.ClientID%>").value != "") {
                event.keyCode = 9;
                event.returnValue = false;
                document.getElementById("<%=btnEnter.ClientID %>").click();
            }
        }--%>

        function getData()
        {
            if (event.keyCode == 13) {
                event.keyCode = 9;
                event.returnValue = false;
                var lot = document.getElementById('txtLot').value;
                
                if (lot == '') {
                    alert('请输入批次号');
                    return false;
                }
                var sendata = "{ lot:'" + lot + "'}";
                $.ajax({
                    type: "POST",
                    url: "/Webservices/ws.asmx/CheckCTM",
                    data: sendata,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        var myData = JSON.parse(data.d); // data.d is a JSON formatted string, to turn it into a JSON object
                        // we use JSON.parse
                        // now that myData is a JSON object we can access its properties like normal
                        //$("#searchresultsD").html(myData.Greeting + " " + myData.Name);
                        if (myData.error != "" && myData.error != undefined)
                        {
                            alert(myData.error);
                            document.getElementById('txtLot').value = '';
                            $("#lotID").val('321');
                            return false;
                        }
                        if (myData.result == "OK") {
                            $("body").css("background-color", "green");
                            document.getElementById('txtLot').value = '';
                            
                            
                        }
                        else if (myData.result=="NG")
                        {
                            $("body").css("background-color", "red");
                            document.getElementById('txtLot').value = '';
                        }
                        //document.getElementById('lotID').innerHTML = lot;
                        $("#lotID").html(lot);
                        var history = $("#history").html() + '<br>' + lot + ':' + myData.result;
                        $("#history").html(history);
                    }
                });
                
                
                
            }
        }
    </script>
</head>

<body>
    <form id="form1" runat="server">
        <div id ="background">
            <label>组件序列号</label>         
            <input id="txtLot" type="text"  onkeydown="getData();" />           
        </div>
        <div>
            <h1 id="lotID"></h1>
        </div>
        <div id="history">

        </div>
    </form>
</body>
</html>
