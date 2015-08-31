package net.http
{
    import C.stdlib.getenv;
    
    import encoding.base64.decodeBase64;
    import encoding.base64.encodeBase64;
    
    /* Note:
    
       Basic auth:
    
        server:
        ----
        WWW-Authenticate: Basic realm="WallyWorld"
        ----
    
        client:
        ----
        Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==
        ----
    
    
       Digest auth:
    
        server:
        ----
        HTTP/1.1 401 Unauthorized
        WWW-Authenticate: Digest
            realm="testrealm@host.com",
            qop="auth,auth-int",
            nonce="dcd98b7102dd2f0e8b11d0f600bfb0c093",
            opaque="5ccc069c403ebaf9f0171e9517f40e41"
        ----
    
        client:
        ----
        Authorization: Digest username="Mufasa",
            realm="testrealm@host.com",
            nonce="dcd98b7102dd2f0e8b11d0f600bfb0c093",
            uri="/dir/index.html",
            qop=auth,
            nc=00000001,
            cnonce="0a4f113b",
            response="6629fae49393a05397450978507c4ef1",
            opaque="5ccc069c403ebaf9f0171e9517f40e41"
        ----
    
    */
    
    /**
     * Helper class for HTTP Authentification scheme.
     * 
     * We immplement for now only Basic Authentification (eg. Digest can wait).
     * 
     * @usage
     * <listing>
     * public static function onSomePage( r:Route ):Response
     * {
     *     // get the HTTP request
     *     var httpRequest:HttpRequest = r.gateway.request as HttpRequest;
     * 
     *     // flag to verify the username:password combo
     *     var authenticated:Boolean = false;
     * 
     *     // create an httpauth instance
     *     var auth:HttpAuthentication = HttpAuthentication.authenticate( httpRequest );
     * 
     *     // the HTTP Response to send back
     *     var page:Response = new TextResponse();
     *     var httpResponse:HttpResponse = page as HttpResponse;
     * 
     *    // if found header or env vars with credentials
     *    if( auth )
     *    {
     *        // provide your own implementation
     *        // from file, db, etc.
     *        authenticated = otherClass.verifyAuthentification( auth );
     *    }
     * 
     *    if( !authenticated )
     *    {
     *        //ask for credentials for the realm="test"
     *        var realm:String = "test";
     *        // generate the WWW-Authenticate header
     *        var header:HttpHeader = HttpAuthentication.basicChallenge( realm );
     *        
     *        httpResponse.addHeader( header, true );
     *        httpResponse.status = StatusCode.fromCode( "401" ).toString();
     *    }
     *    else
     *    {
     *        // the protected content
     *        httpResponse.body = "you are authenticated ...";
     *    }
     * 
     *    return httpResponse;
     * }
     * </listing>
     * 
     * @see https://tools.ietf.org/html/rfc2617 HTTP Authentication: Basic and Digest Access Authentication
     * @see https://tools.ietf.org/html/rfc7235 Hypertext Transfer Protocol (HTTP/1.1): Authentication
     * @see http://www.iana.org/assignments/http-authschemes/http-authschemes.xhtml Hypertext Transfer Protocol (HTTP) Authentication Scheme Registry
     * @see https://en.wikipedia.org/wiki/Basic_access_authentication Basic access authentication
     * @see https://en.wikipedia.org/wiki/Digest_access_authentication Digest access authentication
     * @see https://en.wikipedia.org/wiki/HTTP%2BHTML_form-based_authentication HTTP+HTML form-based authentication
     */
    public class HttpAuthentication
    {
        
        /**
         * Generates a Basic Authentification Challenge.
         * 
         * 
         * 
         * @param realm 
         * @param useCharset Boolean flag
         * @return Returns a HTTP Header to add to the server HTTP Response
         */
        public static function basicChallenge( realm:String, useCharset:Boolean = false ):HttpHeader
        {
            /* Note:
               WWW-Authenticate: Basic realm="WallyWorld"
               WWW-Authenticate: Basic realm="foo", charset="UTF-8"
            */
            var challenge:String = "";
            challenge += HttpHeader.BASIC;
            challenge += " " + HttpHeader.REALM + "=";
            challenge += "\"";
            challenge += realm;
            challenge += "\"";
            
            if( useCharset )
            {
                challenge += ", ";
                challenge += "\"";
                challenge += "UTF-8";
                challenge += "\"";
            }
            
            
            var header:HttpHeader = new HttpHeader( HttpHeader.WWW_AUTHENTICATE, challenge );
            
            return header;
        }
        
        /**
         * Generates a Basic Authentification Response.
         * 
         * @param username
         * @param password
         * @return Returns a HTTP Header to add to the client HTTP Request.
         */
        public static function basicResponse( username:String, password:String ):HttpHeader
        {
            /* Note:
               Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==
            */
            var credentials:String = "";
                credentials += HttpHeader.BASIC;
                
            var userpass:String = "";
                userpass += username;
                userpass += ":";
                userpass += password;
            
                credentials += " " + encodeBase64( userpass );
            
            var header:HttpHeader = new HttpHeader( HttpHeader.AUTHORIZATION, credentials );
            
            return header;
        }
        
        /* Retrieve the Authorization value
           from either the environment variables
           ----
           HTTP_AUTHORIZATION=Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==
           ----
           
           or from the HTTP request headers.
           ----
           Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==
           ----
        
           With Apache CGI this one filters out Authorization headers
           so we use this .htaccess to obtain them as env vars
           ----
           RewriteEngine on
           RewriteCond %{HTTP:Authorization} ^(.*)
           RewriteRule .* - [e=HTTP_AUTHORIZATION:%1]
           ----
        
           We basically replicating the Apache behaviours which is
           to take any HTTP request headers and set them as environment variables
           for ex:
           ----
           Host: 127.0.0.1:8080
           Connection: keep-alive
           ----
           become
           ----
           HTTP_HOST=127.0.0.1:8080
           HTTP_CONNECTION=keep-alive
           ----
        */
        private static function _getAuthorizationValue( request:HttpRequest ):String
        {
            var value:String = getenv( HttpHeader.formatEnvName( HttpHeader.AUTHORIZATION ) );
            
            //env vars take precedence over http headers
            if( value != "" )
            {
                return value;
            }
            
            if( request.hasHeader( HttpHeader.AUTHORIZATION ) )
            {
                value = request.getHeaderValue( HttpHeader.AUTHORIZATION );
            }
            
            return value;
        }
        
        /**
         * Search for an HTTP Authentification.
         * 
         * @param request
         * @return Returns an <code>HttpAuthentication</code> if found,
         *         otherwise returns <code>null</code>.
         */
        public static function authenticate( request:HttpRequest ):HttpAuthentication
        {
            //Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==
            var authval:String = _getAuthorizationValue( request );
            
            if( authval != "" )
            {
                //starts with "Basic "
                if( authval.indexOf( HttpHeader.BASIC + " " ) == 0 )
                {
                    //QWxhZGRpbjpvcGVuIHNlc2FtZQ==
                    var encoded:String = authval.substr( HttpHeader.BASIC.length + 1 );
                    //username:password
                    var decoded:String = decodeBase64( encoded );
                    var pos:int = decoded.indexOf( ":" );
                    if( pos > -1 )
                    {
                        var username:String = decoded.substring( 0, pos );
                        var password:String = decoded.substr( pos + 1 );
                        return new HttpAuthentication( username, password, HttpHeader.BASIC );
                    }
                }
                
                /* Digest not implemented
                   eg. authval.indexOf( HttpHeader.DIGEST + " " )
                */
                
            }
            
            return null;
        }
        
        
        
        public var scheme:String;
        
        public var username:String;
        public var password:String;
        
        public function HttpAuthentication( username:String = "", password:String = "",
                                            scheme:String = "" )
        {
            super();
            
            this.username = username;
            this.password = password;
            
            this.scheme = scheme;
        }
        
    }
}