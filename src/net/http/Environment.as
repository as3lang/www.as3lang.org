package net.http
{
    
    /**
     * The contract of an HTTP Environment.
     */
    public interface Environment
    {
        function get authType():String;
        
        function get contentLength():String;
        
        function get contentType():String;
        
        function get gatewayInterface():String;
        
        function get pathInfo():String;
        
        function get pathTranslated():String;
        
        function get querySring():String;
        
        function get remoteAddress():String;
        
        function get remoteHost():String;
        
        function get remoteIdent():String;
        
        function get remoteUser():String;
        
        function get requestMethod():String;
        
        function get scriptName():String;
        
        function get serverName():String;
        
        function get serverPort():String;
        
        function get serverProtocol():String;
        
        function get serverSoftware():String;
    }
}