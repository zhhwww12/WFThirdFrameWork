
var script = document.createElement('script');
script.type = 'text/javascript';
script.text = "
JSI =
{
    sendMessage: function(code, json)
    {
        var message = {'code':code,'json':json};
        window.webkit.messageHandlers.DDKY.postMessage(message);
    },
}
";
document.getElementsByTagName('head')[0].appendChild(script);


