package net.http.cgi
{
    /**
     * Meta-variables contain data about the request passed from the server
     * to the script, and are accessed by the script in a system-defined
     * manner.
     * 
     * @see http://tools.ietf.org/html/rfc3875#section-4.1 Request Meta-Variables
     */ 
    public class MetaVariables
    {
        
        /**
         * The AUTH_TYPE variable identifies any mechanism used by the server
         * to authenticate the user.
         * 
         * @see http://tools.ietf.org/html/rfc3875#section-4.1.1 AUTH_TYPE
         */ 
        public static const AUTH_TYPE:String = "AUTH_TYPE";
        
        /**
         * The CONTENT_LENGTH variable contains the size of the message-body
         * attached to the request, if any, in decimal number of octets.
         * 
         * @see http://tools.ietf.org/html/rfc3875#section-4.1.2 CONTENT_LENGTH
         */
        public static const CONTENT_LENGTH:String = "CONTENT_LENGTH";
        
        /**
         * If the request includes a message-body, the CONTENT_TYPE variable is
         * set to the Internet Media Type of the message-body.
         * 
         * There is no default value for this variable.
         * 
         * @see http://tools.ietf.org/html/rfc3875#section-4.1.3 CONTENT_TYPE
         */
        public static const CONTENT_TYPE:String = "CONTENT_TYPE";
        
        /**
         * The GATEWAY_INTERFACE variable MUST be set to the dialect of CGI
         * being used by the server to communicate with the script.
         * 
         * @see http://tools.ietf.org/html/rfc3875#section-4.1.4 GATEWAY_INTERFACE
         */
        public static const GATEWAY_INTERFACE:String = "GATEWAY_INTERFACE";
        
        /**
         * The PATH_INFO variable specifies a path to be interpreted by the CGI
         * script.
         * 
         * @see http://tools.ietf.org/html/rfc3875#section-4.1.5 PATH_INFO
         */
        public static const PATH_INFO:String = "PATH_INFO";
        
        /**
         * The PATH_TRANSLATED variable is derived by taking the PATH_INFO
         * value, parsing it as a local URI in its own right, and performing
         * any virtual-to-physical translation appropriate to map it onto the
         * server's document repository structure.
         * 
         * @see http://tools.ietf.org/html/rfc3875#section-4.1.6 PATH_TRANSLATED
         */
        public static const PATH_TRANSLATED:String = "PATH_TRANSLATED";
        
        /**
         * The QUERY_STRING variable contains a URL-encoded search or parameter
         * string; it provides information to the CGI script to affect or refine
         * the document to be returned by the script.
         * 
         * @see http://tools.ietf.org/html/rfc3875#section-4.1.7 QUERY_STRING
         */
        public static const QUERY_STRING:String = "QUERY_STRING";
        
        /**
         * The REMOTE_ADDR variable MUST be set to the network address of the
         * client sending the request to the server.
         * 
         * @see http://tools.ietf.org/html/rfc3875#section-4.1.8 REMOTE_ADDR
         */
        public static const REMOTE_ADDR:String = "REMOTE_ADDR";
        
        /**
         * The REMOTE_HOST variable contains the fully qualified domain name of
         * the client sending the request to the server, if available, otherwise
         * NULL.
         * 
         * @see http://tools.ietf.org/html/rfc3875#section-4.1.9 REMOTE_HOST
         */
        public static const REMOTE_HOST:String = "REMOTE_HOST";
        
        /**
         * The REMOTE_IDENT variable MAY be used to provide identity information
         * reported about the connection by an RFC 1413 request to the
         * remote agent, if available.
         * 
         * @see http://tools.ietf.org/html/rfc3875#section-4.1.10 REMOTE_IDENT
         */
        public static const REMOTE_IDENT:String = "REMOTE_IDENT";
        
        /**
         * The REMOTE_USER variable provides a user identification string
         * supplied by client as part of user authentication.
         * 
         * @see http://tools.ietf.org/html/rfc3875#section-4.1.11 REMOTE_USER
         */
        public static const REMOTE_USER:String = "REMOTE_USER";
        
        /**
         * The REQUEST_METHOD meta-variable MUST be set to the method which
         * should be used by the script to process the request.
         * 
         * @see http://tools.ietf.org/html/rfc3875#section-4.1.12 REQUEST_METHOD
         */
        public static const REQUEST_METHOD:String = "REQUEST_METHOD";
        
        /**
         * The SCRIPT_NAME variable MUST be set to a URI path (not URL-encoded)
         * which could identify the CGI script (rather than the script's
         * output).
         * 
         * @see http://tools.ietf.org/html/rfc3875#section-4.1.13 SCRIPT_NAME
         */
        public static const SCRIPT_NAME:String = "SCRIPT_NAME";
        
        /**
         * The SERVER_NAME variable MUST be set to the name of the server host
         * to which the client request is directed.
         * 
         * @see http://tools.ietf.org/html/rfc3875#section-4.1.14 SERVER_NAME
         */
        public static const SERVER_NAME:String = "SERVER_NAME";
        
        /**
         * The SERVER_PORT variable MUST be set to the TCP/IP port number on
         * which this request is received from the client.
         * 
         * @see http://tools.ietf.org/html/rfc3875#section-4.1.15 SERVER_PORT
         */
        public static const SERVER_PORT:String = "SERVER_PORT";
        
        /**
         * The SERVER_PROTOCOL variable MUST be set to the name and version of
         * the application protocol used for this CGI request.
         * 
         * @see http://tools.ietf.org/html/rfc3875#section-4.1.16 SERVER_PROTOCOL
         */
        public static const SERVER_PROTOCOL:String = "SERVER_PROTOCOL";
        
        /**
         * The SERVER_SOFTWARE meta-variable MUST be set to the name and version
         * of the information server software making the CGI request (and
         * running the gateway).
         * 
         * @see http://tools.ietf.org/html/rfc3875#section-4.1.17 SERVER_SOFTWARE
         */
        public static const SERVER_SOFTWARE:String = "SERVER_SOFTWARE";
        
        public function MetaVariables()
        {
            super();
        }
    }
}