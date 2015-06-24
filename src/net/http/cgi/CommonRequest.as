package net.http.cgi
{
    import net.http.HttpRequest;
    
    /**
     * Implementation of Common Request.
     */
    public class CommonRequest extends HttpRequest
    {
        
        private var _query:String;
        
        public function CommonRequest( method:String, contentType:String,
                                       query:String = "", headers:Array = null )
        {
            super();
            
            set( "" );
            this.method      = method;
            this.contentType = contentType;
            this.query       = query;
            
            if( headers )
            {
                this.headers = headers;
            }
            
        }
    }
}