function setCounter(){
    var arabic = /[\u0600-\u06FF]/;

    if(arabic.test(document.frmSendSms.txtMessage.value) == true){
        document.frmSendSms.hiddcount.value = 70
    }else{
        document.frmSendSms.hiddcount.value = 160
    }
	var charactercount = textCounter(document.frmSendSms.txtMessage, document.frmSendSms.hiddcount.value);
	document.frmSendSms.txtcount.value = charactercount;
}

function setMessageLength1()
{
    if (document.frmSendSms.cmbMessageType.value == "0")
    {
        document.frmSendSms.hiddcount.value = "160";
        setCounter();
        document.frmSendSms.txtMessage.dir = "ltr";
    }
    if (document.frmSendSms.cmbMessageType.value == "1")
    {
        document.frmSendSms.hiddcount.value = "70";
        setCounter();
        document.frmSendSms.txtMessage.dir = "ltr";
    }
    if (document.frmSendSms.cmbMessageType.value == "2")
    {
        document.frmSendSms.hiddcount.value = "160";
        setCounter();
        document.frmSendSms.txtMessage.dir = "ltr";
    }
    if (document.frmSendSms.cmbMessageType.value == "3")
    {
        document.frmSendSms.hiddcount.value = "70";
        setCounter();
        document.frmSendSms.txtMessage.dir = "ltr";
    }
    if (document.frmSendSms.cmbMessageType.value == "4")
    {
        document.frmSendSms.hiddcount.value = "70";
        setCounter();
        document.frmSendSms.txtMessage.dir = "rtl";
    }
    if (document.frmSendSms.cmbMessageType.value == "5")
    {
        document.frmSendSms.hiddcount.value = "70";
        setCounter();
        document.frmSendSms.txtMessage.dir = "ltr";
    }
}


function textCounter(field, maxlimit)
{
    var messagelen = 1;
    var mesagelenudh;
    var messagelenudh1;
    var charactercount = checkLength(field);
    if (charactercount > maxlimit) {
        if (maxlimit == 160) {
            messagelen = Math.ceil(charactercount / maxlimit) * 7;
        } else if (maxlimit == 70) {
            messagelen = Math.ceil(charactercount / maxlimit) * 3;
        } else {
            messagelen = Math.ceil(charactercount / maxlimit) * 3;
        }
        messagelenudh1 = messagelen + charactercount;
        messagelenudh = Math.ceil(messagelenudh1 / maxlimit);
        return checkLength(field) + " : " + messagelenudh + " SMS Message(s)";
    } else {
        return checkLength(field) + " : 1 SMS Message(s)";
    }
}

function checkLength(field)
{
    //var countMe = field.value.replace(/[\n\r\n]+/g, '');
    if (BrowserDetect.browser == "Firefox") {
        var countMe = field.value.replace(/[\n\r\n]/g, ' ');
        countMe = countMe.replace(/[\n\~\|\^\�\}\{\]\[\\]/g, '  ');
    } else if (BrowserDetect.browser == "Chrome") {
        var countMe = field.value.replace(/[\n\r\n]/g, '  ');
        countMe = countMe.replace(/[\n\~\|\^\�\}\{\]\[\\]/g, '  ');
    } else {
        var countMe = field.value;
    }
    var escapedStr = (countMe);
    if (escapedStr.indexOf("�") != -1) {
        var count = escapedStr.split("�").length - 1;
        /*var occur = escapedStr.match(/%0A/g);
         count = count + occur.length;*/
        if (count == 0)
            count++;  //perverse case; can't happen with real UTF-8
        var tmp = escapedStr.length - (count * 3);
        count = count + tmp;
    } else {
        count = escapedStr.length;
    }
    //alert(escapedStr + ": size is " + count)
    return count;
}

var BrowserDetect = {
    init: function () {
        this.browser = this.searchString(this.dataBrowser) || "An unknown browser";
        this.version = this.searchVersion(navigator.userAgent)
            || this.searchVersion(navigator.appVersion)
            || "an unknown version";
        this.OS = this.searchString(this.dataOS) || "an unknown OS";
    },
    searchString: function (data) {
        for (var i = 0; i < data.length; i++) {
            var dataString = data[i].string;
            var dataProp = data[i].prop;
            this.versionSearchString = data[i].versionSearch || data[i].identity;
            if (dataString) {
                if (dataString.indexOf(data[i].subString) != -1)
                    return data[i].identity;
            }
            else if (dataProp)
                return data[i].identity;
        }
    },
    searchVersion: function (dataString) {
        var index = dataString.indexOf(this.versionSearchString);
        if (index == -1)
            return;
        return parseFloat(dataString.substring(index + this.versionSearchString.length + 1));
    },
    dataBrowser: [
        {
            string: navigator.userAgent,
            subString: "Chrome",
            identity: "Chrome"
        },
        {
            string: navigator.userAgent,
            subString: "OmniWeb",
            versionSearch: "OmniWeb/",
            identity: "OmniWeb"
        },
        {
            string: navigator.vendor,
            subString: "Apple",
            identity: "Safari",
            versionSearch: "Version"
        },
        {
            prop: window.opera,
            identity: "Opera"
        },
        {
            string: navigator.vendor,
            subString: "iCab",
            identity: "iCab"
        },
        {
            string: navigator.vendor,
            subString: "KDE",
            identity: "Konqueror"
        },
        {
            string: navigator.userAgent,
            subString: "Firefox",
            identity: "Firefox"
        },
        {
            string: navigator.vendor,
            subString: "Camino",
            identity: "Camino"
        },
        {// for newer Netscapes (6+)
            string: navigator.userAgent,
            subString: "Netscape",
            identity: "Netscape"
        },
        {
            string: navigator.userAgent,
            subString: "MSIE",
            identity: "Explorer",
            versionSearch: "MSIE"
        },
        {
            string: navigator.userAgent,
            subString: "Gecko",
            identity: "Mozilla",
            versionSearch: "rv"
        },
        {// for older Netscapes (4-)
            string: navigator.userAgent,
            subString: "Mozilla",
            identity: "Netscape",
            versionSearch: "Mozilla"
        }
    ],
    dataOS: [
        {
            string: navigator.platform,
            subString: "Win",
            identity: "Windows"
        },
        {
            string: navigator.platform,
            subString: "Mac",
            identity: "Mac"
        },
        {
            string: navigator.userAgent,
            subString: "iPhone",
            identity: "iPhone/iPod"
        },
        {
            string: navigator.platform,
            subString: "Linux",
            identity: "Linux"
        }
    ]

};

BrowserDetect.init();

$('.form_datetime').datetimepicker({
    format: "yyyy-mm-dd hh:ii:ss",
    autoclose: true,
    todayBtn: true,
    pickerPosition: "bottom-left",
    startDate: new Date()
});

function submit_single(){
    var rightNow = (new Date(Date.now()-(new Date()).getTimezoneOffset() * 60000));
    var date = rightNow.toISOString().slice(0, 10).replace(/[^0-9]/g, "-");
    var time = rightNow.toISOString().slice(11, 19).replace(/[^0-9]/g, ":");
    $("#current_date").val(date + ' ' + time);
}