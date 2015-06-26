package net.http
{
    public class StatusCode
    {
        private static var _codes:Array = [];
        
        // Informational - 1xx
        public static const CONTINUE:StatusCode = new StatusCode("100", "Continue");
        public static const SWITCHING_PROTOCOLS:StatusCode = new StatusCode("101", "Switching Protocols");
        public static const PROCESSING:StatusCode = new StatusCode("102", "Processing");
        
        // Success - 2xx
        public static const OK:StatusCode = new StatusCode("200", "OK");
        public static const CREATED:StatusCode = new StatusCode("201", "Created");
        public static const ACCEPTED:StatusCode = new StatusCode("202", "Accepted");
        public static const NON_AUTHORITATIVE_INFORMATION:StatusCode = new StatusCode("203", "Non-Authoritative Information");
        public static const NO_CONTENT:StatusCode = new StatusCode("204", "No Content");
        public static const RESET_CONTENT:StatusCode = new StatusCode("205", "Reset Content");
        public static const PARTIAL_CONTENT:StatusCode = new StatusCode("206", "Partial Content");
        public static const MULTI_STATUS:StatusCode = new StatusCode("207", "Multi-Status");
        public static const ALREADY_REPORTED:StatusCode = new StatusCode("208", "Already Reported");
        public static const IM_USED:StatusCode = new StatusCode("226", "IM Used");
        
        // Redirection - 3xx
        public static const MULTIPLE_CHOICES:StatusCode = new StatusCode("300", "Multiple Choices");
        public static const MOVED_PERMANENTLY:StatusCode = new StatusCode("301", "Moved Permanently");
        public static const FOUND:StatusCode = new StatusCode("302", "Found");
        public static const SEE_OTHER:StatusCode = new StatusCode("303", "See Other");
        public static const NOT_MODIFIED:StatusCode = new StatusCode("304", "Not Modified");
        public static const USE_PROXY:StatusCode = new StatusCode("305", "Use Proxy");
        public static const TEMPORARY_REDIRECT:StatusCode = new StatusCode("307", "Temporary Redirect");
        public static const PERMANENT_REDIRECT:StatusCode = new StatusCode("308", "Permanent Redirect");
        
        // Client Error - 4xx
        public static const BAD_REQUEST:StatusCode = new StatusCode("400", "Bad Request");
        public static const UNAUTHORIZED:StatusCode = new StatusCode("401", "Unauthorized");
        public static const PAYMENT_REQUIRED:StatusCode = new StatusCode("402", "Payment Required");
        public static const FORBIDDEN:StatusCode = new StatusCode("403", "Forbidden");
        public static const NOT_FOUND:StatusCode = new StatusCode("404", "Not Found");
        public static const METHOD_NOT_ALLOWED:StatusCode = new StatusCode("405", "Method Not Allowed");
        public static const NOT_ACCEPTABLE:StatusCode = new StatusCode("406", "Not Acceptable");
        public static const PROXY_AUTHENTICATION_REQUIRED:StatusCode = new StatusCode("407", "Proxy Authentication Required");
        public static const REQUEST_TIMEOUT:StatusCode = new StatusCode("408", "Request Timeout");
        public static const CONFLICT:StatusCode = new StatusCode("409", "Conflict");
        public static const GONE:StatusCode = new StatusCode("410", "Gone");
        public static const LENGTH_REQUIRED:StatusCode = new StatusCode("411", "Length Required");
        public static const PRECONDITION_FAILED:StatusCode = new StatusCode("412", "Precondition Failed");
        public static const PAYLOAD_TOO_LARGE:StatusCode = new StatusCode("413", "Payload Too Large");
        public static const URI_TOO_LONG:StatusCode = new StatusCode("414", "URI Too Long");
        public static const UNSUPPORTED_MEDIA_TYPE:StatusCode = new StatusCode("415", "Unsupported Media Type");
        public static const RANGE_NOT_SATISFIABLE:StatusCode = new StatusCode("416", "Range Not Satisfiable");
        public static const EXPECTATION_FAILED:StatusCode = new StatusCode("417", "Expectation Failed");
        public static const UNPROCESSABLE_ENTITY:StatusCode = new StatusCode("422", "Unprocessable Entity");
        public static const LOCKED:StatusCode = new StatusCode("423", "Locked");
        public static const FAILED_DEPENDENCY:StatusCode = new StatusCode("424", "Failed Dependency");
        public static const UPGRADE_REQUIRED:StatusCode = new StatusCode("426", "Upgrade Required");
        public static const PRECONDITION_REQUIRED:StatusCode = new StatusCode("428", "Precondition Required");
        public static const TOO_MANY_REQUESTS:StatusCode = new StatusCode("429", "Too Many Requests");
        public static const REQUEST_HEADER_FIELDS_TOO_LARGE:StatusCode = new StatusCode("431", "Request Header Fields Too Large");
        
        // Server Error - 5xx
        public static const INTERNAL_SERVER_ERROR:StatusCode = new StatusCode("500", "Internal Server Error");
        public static const NOT_IMPLEMENTED:StatusCode = new StatusCode("501", "Not Implemented");
        public static const BAD_GATEWAY:StatusCode = new StatusCode("502", "Bad Gateway");
        public static const SERVICE_UNAVAILABLE:StatusCode = new StatusCode("503", "Service Unavailable");
        public static const GATEWAY_TIMEOUT:StatusCode = new StatusCode("504", "Gateway Timeout");
        public static const HTTP_VERSION_NOT_SUPPORTED:StatusCode = new StatusCode("505", "HTTP Version Not Supported");
        public static const VARIANT_ALSO_NEGOTIATES:StatusCode = new StatusCode("506", "Variant Also Negotiates");
        public static const INSUFFICIENT_STORAGE:StatusCode = new StatusCode("507", "Insufficient Storage");
        public static const LOOP_DETECTED:StatusCode = new StatusCode("508", "Loop Detected");
        public static const NOT_EXTENDED:StatusCode = new StatusCode("510", "Not Extended");
        public static const NETWORK_AUTHENTICATION_REQUIRED:StatusCode = new StatusCode("511", "Network Authentication Required");
        
        public static function fromCode( num:String ) : StatusCode
        {
            if( _codes[ num ] )
            {
                return _codes[ num ];
            }
            
            return null;
        }
        
        
        private var _code:String;
        private var _description:String;
        
        public function StatusCode( code:String, description:String )
        {
            super();
            
            _code        = code;
            _description = description;
            
            _codes[ _code ] = this;
        }
        
        private function _codeIndex():uint
        {
            return parseInt(  code.charAt(0) );
        }
        
        public function get code():String { return _code; }
        
        public function get description():String { return _description; }
        
        public function isInformational():Boolean
        {
            return _codeIndex() == 1;
        }
        
        public function isSuccess():Boolean
        {
            return _codeIndex() == 2;
        }
        
        public function isRedirection():Boolean
        {
            return _codeIndex() == 3;
        }
        
        public function isClientError():Boolean
        {
            return _codeIndex() == 4;
        }
        
        public function isServerError():Boolean
        {
            return _codeIndex() == 5;
        }
        
        public function toString():String
        {
            return code + " " + description;
        }
    }
}