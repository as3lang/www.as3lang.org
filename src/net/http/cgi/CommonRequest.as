package net.http.cgi
{
    import flash.utils.ByteArray;
    
    import net.http.HttpRequest;
    import net.http.HttpUtils;
    
    /**
     * Implementation of Common Request.
     */
    public class CommonRequest extends HttpRequest
    {
        
        private var _postMap:Object;
        private var _postFile:Object;
        
        public function CommonRequest( method:String, contentType:String,
                                       query:String = "", headers:Array = null,
                                       post:ByteArray = null )
        {
            super();
            
            _postMap  = null;
            _postFile = null;
            
            set( "" );
            this.method      = method;
            this.contentType = contentType;
            this.query       = query;
            
            if( headers )
            {
                this.headers = headers;
            }
            
            /* Note:
               If we have POST data we save it in the body
               and if we understand the content-type
               we parse the data
            */
            if( post )
            {
                this.bodyBytes = post;
                
                switch( contentType )
                {
                    case "application/x-www-form-urlencoded":
                    _postMap = HttpUtils.parse_form_urlencoded( post );
                    break;
                
                    default:
                    if( contentType && 
                        (contentType.indexOf( "multipart/form-data" ) == 0) )
                    {
                        // not implemented yet
                        _postFile = HttpUtils.parse_form_data( post );
                    }
                }
            }
        }
        
        /**
         * The serialized content of the post data
         * when the content type is "application/x-www-form-urlencoded".
         */
        public function get postMap():Object { return _postMap; }
        
        /**
         * The serialized content of the post data
         * when the content type is "multipart/form-data".
         */
        public function get postFile():Object { return _postFile; }
    }
}