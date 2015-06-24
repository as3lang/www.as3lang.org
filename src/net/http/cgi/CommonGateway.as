package net.http.cgi
{
    import net.http.Environment;
    import net.http.Gateway;
    import net.http.HttpUtils;
    import net.http.Request;
    import net.http.Response;
    
    import shell.Program;
    
    /**
     * Basic implementation of a Gateway.
     */ 
    public class CommonGateway implements Gateway
    {
        private var _env:Environment;
        
        protected var _request:Request;
        
        public function CommonGateway():void
        {
            super();
            
            _env     = null;
            _request = null;
        }
        
        /** @inheritDoc */
        public function get environment():Environment { return _env; }
        
        /** @inheritDoc */
        public function get request():Request { return _request; }
        
        /** @inheritDoc */
        public function run():void
        {
            /* We initialise the environment variables
               based on the CGI Meta-variables
            */
            _env = new CommonEnvironment();
            
            var method:String  = _env.requestMethod;
            var cType:String   = _env.contentType;
            var cLength:String = _env.contentLength;
            var query:String   = _env.querySring;
            
            // we prepare a response
            var response:Response;
            
            /* From the environment variables
               we also grab all the vars starting with "HTTP_"
            */
            var headers:Array = HttpUtils.environ_http_headers( Program.environ );
            
            // with all these informations we build a request object
            _request = new CommonRequest( method, cType, query, headers );
            
            try
            {
                response = apply( request );
            }
            catch( e:Error )
            {
                // e.toString()
                // e.getStackTrace()
                // Error.getErrorMessage( e.errorID )
            }
            
            /* If we failed to obtain a response
               we need to build a default one
            */
            if( response == null )
            {
                response = new CommonResponse();
                response.contentType = "text/plain; charset=utf-8";
                response.body = "nothing to display";
            }
            
            /* If at this point the request is still not
               attached to the response then we attach it
            */
            if( !response.httpRequest )
            {
                response.httpRequest = _request;
            }
            
            /* We write the response content stream
               to the output, eg. we flush all data to stdout
            */
            var output:CommonResponse = response as CommonResponse;
                output.display();
                output.flush();
        }
        
        /** @inheritDoc */
        public function apply( request:Request ):Response
        {
            // by default our gateway has no logic and so returns nothing
            return null;
        }
        
    }
    
}