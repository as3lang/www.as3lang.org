package net.http.cgi
{
    import C.stdlib.getenv;
    import net.http.Environment;
    
    /**
     * Implementation of Common Environment.
     */
    public class CommonEnvironment implements Environment
    {
        private var _authType:String;
        private var _contentLength:String;
        private var _contentType:String;
        private var _gatewayInterface:String;
        private var _pathInfo:String;
        private var _pathTranslated:String;
        private var _querySring:String;
        private var _remoteAddress:String;
        private var _remoteHost:String;
        private var _remoteIdent:String;
        private var _remoteUser:String;
        private var _requestMethod:String;
        private var _scriptName:String;
        private var _serverName:String;
        private var _serverPort:String;
        private var _serverProtocol:String;
        private var _serverSoftware:String;
        
        public function CommonEnvironment()
        {
            super();
            
            _authType         = getenv( MetaVariables.AUTH_TYPE );
            _contentLength    = getenv( MetaVariables.CONTENT_LENGTH );
            _contentType      = getenv( MetaVariables.CONTENT_TYPE );
            _gatewayInterface = getenv( MetaVariables.GATEWAY_INTERFACE );
            _pathInfo         = getenv( MetaVariables.PATH_INFO );
            _pathTranslated   = getenv( MetaVariables.PATH_TRANSLATED );
            _querySring       = getenv( MetaVariables.QUERY_STRING );
            _remoteAddress    = getenv( MetaVariables.REMOTE_ADDR );
            _remoteHost       = getenv( MetaVariables.REMOTE_HOST );
            _remoteIdent      = getenv( MetaVariables.REMOTE_IDENT );
            _remoteUser       = getenv( MetaVariables.REMOTE_USER );
            _requestMethod    = getenv( MetaVariables.REQUEST_METHOD );
            _scriptName       = getenv( MetaVariables.SCRIPT_NAME );
            _serverName       = getenv( MetaVariables.SERVER_NAME );
            _serverPort       = getenv( MetaVariables.SERVER_PORT );
            _serverProtocol   = getenv( MetaVariables.SERVER_PROTOCOL );
            _serverSoftware   = getenv( MetaVariables.SERVER_SOFTWARE );
        }
        
        public function get authType():String { return _authType; }
        
        public function get contentLength():String { return _contentLength; }
        
        public function get contentType():String { return _contentType; }
        
        public function get gatewayInterface():String { return _gatewayInterface; }
        
        public function get pathInfo():String { return _pathInfo; }
        
        public function get pathTranslated():String { return _pathTranslated; }
        
        public function get querySring():String { return _querySring; }
        
        public function get remoteAddress():String { return _remoteAddress; }
        
        public function get remoteHost():String { return _remoteHost; }
        
        public function get remoteIdent():String { return _remoteIdent; }
        
        public function get remoteUser():String { return _remoteUser; }
        
        public function get requestMethod():String { return _requestMethod; }
        
        public function get scriptName():String { return _scriptName; }
        
        public function get serverName():String { return _serverName; }
        
        public function get serverPort():String { return _serverPort; }
        
        public function get serverProtocol():String { return _serverProtocol; }
        
        public function get serverSoftware():String { return _serverSoftware; }
        
        public function toString():String
        {
            var str:String = "";
            
                str += MetaVariables.AUTH_TYPE + " = " + authType + "\n";
                str += MetaVariables.CONTENT_LENGTH + " = " + contentLength + "\n";
                str += MetaVariables.CONTENT_TYPE + " = " + contentType + "\n";
                str += MetaVariables.GATEWAY_INTERFACE + " = " + gatewayInterface + "\n";
                str += MetaVariables.PATH_INFO + " = " + pathInfo + "\n";
                str += MetaVariables.PATH_TRANSLATED + " = " + pathTranslated + "\n";
                str += MetaVariables.QUERY_STRING + " = " + querySring + "\n";
                str += MetaVariables.REMOTE_ADDR + " = " + remoteAddress + "\n";
                str += MetaVariables.REMOTE_HOST + " = " + remoteHost + "\n";
                str += MetaVariables.REMOTE_IDENT + " = " + remoteIdent + "\n";
                str += MetaVariables.REMOTE_USER + " = " + remoteUser + "\n";
                str += MetaVariables.REQUEST_METHOD + " = " + requestMethod + "\n";
                str += MetaVariables.SCRIPT_NAME + " = " + scriptName + "\n";
                str += MetaVariables.SERVER_NAME + " = " + serverName + "\n";
                str += MetaVariables.SERVER_PORT + " = " + serverPort + "\n";
                str += MetaVariables.SERVER_PROTOCOL + " = " + serverProtocol + "\n";
                str += MetaVariables.SERVER_SOFTWARE + " = " + serverSoftware + "\n";
            
            return str;
        }
    }
}