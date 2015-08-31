package database.couchdb
{
    import net.URI;
    import net.http.HttpRequest;
    import net.http.HttpResponse;
    import net.http.HttpUtils;
    import net.http.RequestMethod;
    
    /* Note:
       based on CouchDB 1.5.0 http://localhost:5984/_utils/script/couch.js.
       also https://github.com/apache/couchdb/releases/tag/1.5.0

       see: https://github.com/apache/couchdb/blob/master/test/javascript/couch.js
       see: https://wiki.apache.org/couchdb/Getting_started_with_JavaScript CouchDB Wiki - Getting started with JavaScript
    
       Here we use our own HttpConnection implementation to connect to the REST API
    */
    public class CouchDB
    {
        
        private var _enableErrorChecking:Boolean;
        
        private var _uri:URI;
        private var _dbname:String;
        private var _design:String;
        
        /**
         * Creates a CouchDB instance.
         * 
         * <p>
         * Creating the instance does not activily test nor verify the database connection.
         * </p>
         * 
         * @param server The server address or hostname to connect to.
         *               Default is <code>"127.0.0.1"</code>. 
         * @param port The server port to connect to.
         *             Default is <code>"5984"</code>
         * @param enableErrorChecking Enable error checking if set to <code>true</code>.
         */
        public function CouchDB( server:String = "127.0.0.1", port:String = "5984",
                                 enableErrorChecking:Boolean = false )
        {
            super();
            
            _uri    = new URI( "http://" + server + ":" + port + "/" );
            _dbname = "";
            _design = "";
            
            _enableErrorChecking = enableErrorChecking;
        }
        
        // we need to escape special properties
        private function _JSONvalue( o:Object ):Object
        {
            var m:String;
            var v:*;
            for( m in o )
            {
                v = o[m];
                if( v is String )
                {
                    switch( m )
                    {
                        case "key":
                        case "startkey":
                        case "endkey":
                        case "rev":
                        o[m] = v;
                        break;
                        
                        default:
                        o[m] = JSON.stringify( v );
                    }
                }
            }
            return o;
        }
        
        /* Build an HTTP Request based on the parameters
           first, it will build a URI based on the current _uri (server and port)
           then it will merge the path and the options
           second, the method will decide which HTTP Request to build
           
           if post is not empty, it will add a body to the request
           (it qill only work with PUT and POST request).
        
           if headers are not empty it will parse and add them to the request
        
           if httpRequest.send(); returns null, this method returns
           an error "server_not_found".
        */
        public function _request( method:String, path:String = "",
                                  options:Object = null,
                                  post:String = "",
                                  headers:Array = null ):String
        {
            var result:String = "";
            
            var local:URI = new URI();
                local.copyURI( _uri );
            
            if( path && (path != "") )
            {
                local.path = path;
            }
            
            if( options != null )
            {
                options = _JSONvalue( options );
                local.setQueryByMap( options );
            }
            
            var destination:String = local.toString();
            //trace( "destination = " + destination );
            
            var httpRequest:HttpRequest;
            
            switch( method )
            {
                case RequestMethod.DELETE:
                httpRequest = HttpRequest.DELETE( destination );
                break;
                
                case RequestMethod.PUT:
                httpRequest = HttpRequest.PUT( destination );
                break;
                
                case RequestMethod.POST:
                httpRequest = HttpRequest.POST( destination );
                break;
                
                case RequestMethod.GET:
                default:
                httpRequest = HttpRequest.GET( destination );
            }
            
            if( post != "" )
            {
                httpRequest.body = post;
            }
            
            if( (headers != null) && (headers.length > 0) )
            {
                var len:uint = headers.length;
                var i:uint;
                var header:String = "";
                for( i = 0; i < len; i++ )
                {
                    header = headers[i];
                    httpRequest.addHeader( HttpUtils.parse_header_line( header ) );
                }
            }
            
            //trace( "--------" );
            //trace( httpRequest.toDebugString() );
            //trace( "--------" );
            
                //httpRequest.connection = new HttpConnection( true ); //debug
            var httpResponse:HttpResponse = httpRequest.send();
            var response:String;
            if( httpResponse )
            {
                response = httpResponse.body;
            }
            else
            {
                var obj:Object = { error: "server_not_found", reason: "Could not open a connection to " + local.authority + ":" + local.port };
                response = JSON.stringify( obj, null, "    " );
            }
            
            return response;
        }
        
        /**
         * Specifies whether errors encountered by the CouchDB database are reported
         * to the application.
         * 
         * <p>
         * When enableErrorChecking is <code>true</code> methods are synchronous
         * and can throw errors. When enableErrorChecking is <code>false</code>,
         * the default, the methods are asynchronous and errors are not reported.
         * </p>
         */ 
        public function get enableErrorChecking():Boolean { return _enableErrorChecking; }
        /** @private */
        public function set enableErrorChecking( value:Boolean ):void { _enableErrorChecking = value; }
        
        public function get informations():Object
        {
            var result:String = _request( RequestMethod.GET, "/" );
            return JSON.parse( result );
        }
        
        public function get version():String
        {
            var infos:Object = this.informations;
            
            if( "version" in infos )
            {
                return infos.version;
            }
            
            return "0.0.0";
        }
        
        public function get databases():Array
        {
            var json:String = _request( RequestMethod.GET, "/_all_dbs" );
            var obj:* = JSON.parse( json );
            if( obj is Array )
            {
                return obj as Array;
            }
            return [];
        }
        
        public function get database():Object
        {
            if( _dbname == "" )
            {
                if( enableErrorChecking )
                {
                    throw new Error( "No database selected" );
                }
                
                return null;
            }
            
            var result:String = _request( RequestMethod.GET );
            return JSON.parse( result );
        }
        
        private function _getDesignPath():String
        {
            return _uri.path + "/_design/" + _design;
        }
        
        public function get designs():Object
        {
            if( (_dbname == "") || (_design == "") )
            {
                if( enableErrorChecking )
                {
                    if(_dbname == "")
                    {
                        throw new Error( "No database selected" );
                    }
                    
                    if(_design == "")
                    {
                        throw new Error( "No design selected" );
                    }
                }
                
                return null;
            }
            
            var path:String = _getDesignPath();
            var result:String = _request( RequestMethod.GET, path );
            return JSON.parse( result );
        }

        public function get views():Array
        {
            if( (_dbname == "") || (_design == "") )
            {
                if( enableErrorChecking )
                {
                    if(_dbname == "")
                    {
                        throw new Error( "No database selected" );
                    }
                    
                    if(_design == "")
                    {
                        throw new Error( "No design selected" );
                    }
                }
                
                return null;
            }
            
            var d:Object = this.designs;
            var views:Array = [];
            
            if( "views" in d )
            {
                var w:Object = d.views;
                var m:String;
                for( m in w )
                {
                    views.push( m );
                }
            }
            
            return views;
        }
        
        public function get documents():Object
        {
            if( _dbname == "" )
            {
                if( enableErrorChecking )
                {
                    throw new Error( "No database selected" );
                }
                
                return null;
            }
            
            var path:String = _uri.path + "/_all_docs";
            var result:String = _request( RequestMethod.GET, path );
            return JSON.parse( result );
        }
        
        public function createDatabase( name:String ):Object
        {
            var result:String = _request( RequestMethod.PUT, "/" + name );
            return JSON.parse( result );
        }

        public function deleteDatabase( name:String ):Object
        {
            var options:Object = { sync: true };
            var result:String = _request( RequestMethod.DELETE, "/" + name, options );
            return JSON.parse( result );
        }
        
        private function _getUUIDs( max:uint = 1 ):Array
        {
            var json:String = _request( RequestMethod.GET, "/_uuids", {count: max } );
            var obj:Object = JSON.parse( json );
            
            if( "uuids" in obj )
            {
                return obj.uuids;
            }
            
            return [];
        }
        
        public function getUUID():String
        {
            var uuids:Array = _getUUIDs();
            if( uuids && (uuids.length > 0) )
            {
                return uuids.shift();
            }
            
            return "";
        }
        
        
        public function selectDB( name:String ):void
        {
            _dbname = name;
            _uri.path = "/" + _dbname;
        }

        public function selectDesign( name:String ):void
        {
            _design = name;
        }
        
        public function select( database:String, design:String = "" ):void
        {
            selectDB( database );
            
            if( design != "" )
            {
                selectDesign( design );
            }
        }
        
        public function clear():void
        {
            _dbname = "";
            _design = "";
            _uri.path = "/";
        }
        
        public function query( map:String, reduce:String = "", options:Object = null ):Object
        {
            if( _dbname == "" )
            {
                if( enableErrorChecking )
                {
                    throw new Error( "No database selected" );
                }
                
                return null;
            }
            
            var body:Object = {};
                body.language = "javascript";
                body.map      = map;

            if( reduce != "" )
            {
                body.reduce   = reduce;
            }
            
            var path:String = _uri.path + "/_temp_view";
            //var header:String = "Content-Type: application/json";
            var header:String = "Content-Type: application/json; charset=utf-8";
            var post:String = JSON.stringify( body );
            
            var result:String = _request( RequestMethod.POST, path, options, post, [ header ] );
            //return result;
            return JSON.parse( result );
        }
        
        public function view( name:String, options:Object = null ):Object
        {
            if( (_dbname == "") || (_design == "") )
            {
                return null;
            }
            
            var path:String = _getDesignPath() + "/_view/" + name;
            var result:String = _request( RequestMethod.GET, path, options );
            return JSON.parse( result );
        }
        
        public function openDocument( name:String, options:Object = null ):Object
        {
            if( _dbname == "" )
            {
                if( enableErrorChecking )
                {
                    throw new Error( "No database selected" );
                }
                
                return null;
            }
            
            var path:String = _uri.path + "/" + encodeURIComponent( name );
            var result:String = _request( RequestMethod.GET, path, options );
            return JSON.parse( result );
        }
        
        public function deleteDocument( document:Object ):Object
        {
            if( _dbname == "" )
            {
                if( enableErrorChecking )
                {
                    throw new Error( "No database selected" );
                }
                
                return null;
            }
            
            var response:Object = {};
            
            var hasID:Boolean = false;
            var hasREV:Boolean = false;
            var id:String = "";
            var rev:String = "";
            
            if("_id" in document)
            {
                id = document._id;
                hasID = true;
            }
            
            if("_rev" in document)
            {
                rev = document._rev;
                hasREV = true;
            }
            
            var path:String;
            var options:Object;
            var result:String = "";
            
            if( hasID && hasREV )
            {
                path    = _uri.path + "/" + encodeURIComponent( id );
                options = { rev: rev };
                result = _request( RequestMethod.DELETE, path, options );
                
                response = JSON.parse( result );
            }
            else
            {
                if( !hasID )
                {
                    response = { error: "missing_data", reason: "Document ID is missing" };
                }
                else if( !hasREV )
                {
                    response = { error: "missing_data", reason: "Document revision is missing" };
                }
            }
            
            return response;
        }
        
        public function saveDocument( document:Object, options:Object = null ):Object
        {
            if( _dbname == "" )
            {
                if( enableErrorChecking )
                {
                    throw new Error( "No database selected" );
                }
                
                return null;
            }
            
            var hasID:Boolean = false;
            var id:String = "";
            var response:Object = {};
            var path:String;
            var result:String;
            var header:String = "Content-Type: application/json; charset=utf-8";
            //var header:String = ""; //debug error
            
            if( "_id" in document )
            {
                id = document._id;
                delete document._id;
                hasID = true;
            }
            
            if( hasID )
            {
                path   = _uri.path + "/" + encodeURIComponent( id );
                result = _request( RequestMethod.PUT, path, options, JSON.stringify( document ), [header] );
            }
            else
            {
                path   = _uri.path;
                result = _request( RequestMethod.POST, path, options, JSON.stringify( document ), [header] );
            }
            
            response = JSON.parse( result );
            //response.hasID = hasID; //debug
            return response;
        }
        
    }
}