package net.http
{
    
    /**
     * The set of common methods for HTTP/1.1.
     * 
     * @see http://tools.ietf.org/html/rfc2616#section-9 Method Definitions
     */
    public class RequestMethod
    {
        
        /**
         * The OPTIONS method represents a request for information about the
         * communication options available on the request/response chain
         * identified by the Request-URI.
         * 
         * @see http://tools.ietf.org/html/rfc2616#section-9.2 OPTIONS
         */
        public static const OPTIONS:String = "OPTIONS";
        
        /**
         * The GET method means retrieve whatever information (in the form of an
         * entity) is identified by the Request-URI.
         * 
         * @see http://tools.ietf.org/html/rfc2616#section-9.3 GET
         */
        public static const GET:String = "GET";
        
        /**
         * The HEAD method is identical to GET except that the server MUST NOT
         * return a message-body in the response.
         * 
         * @see http://tools.ietf.org/html/rfc2616#section-9.4 HEAD
         */
        public static const HEAD:String = "HEAD";
        
        /**
         * The POST method is used to request that the origin server accept the
         * entity enclosed in the request as a new subordinate of the resource
         * identified by the Request-URI in the Request-Line.
         * 
         * @see http://tools.ietf.org/html/rfc2616#section-9.5 POST
         */
        public static const POST:String = "POST";
        
        /**
         * The PUT method requests that the enclosed entity be stored under the
         * supplied Request-URI.
         * 
         * @see http://tools.ietf.org/html/rfc2616#section-9.6 PUT
         */
        public static const PUT:String = "PUT";
        
        /**
         * The DELETE method requests that the origin server delete the resource
         * identified by the Request-URI.
         * 
         * @see http://tools.ietf.org/html/rfc2616#section-9.7 DELETE
         */
        public static const DELETE:String = "DELETE";
        
        /**
         * The TRACE method is used to invoke a remote, application-layer loop-
         * back of the request message.
         * 
         * @see http://tools.ietf.org/html/rfc2616#section-9.8 TRACE
         */
        public static const TRACE:String = "TRACE";
        
        /**
         * The method name CONNECT for use with a proxy that can dynamically
         * switch to being a tunnel (e.g. SSL tunneling).
         * 
         * @see http://tools.ietf.org/html/rfc2616#section-9.9 CONNECT
         */
        public static const CONNECT:String = "CONNECT";
        
        /**
         * 
         * 
         * not RFC ?
         */
        public static const PATCH:String = "PATCH";
        
        public function RequestMethod()
        {
            super();
        }
    }
}