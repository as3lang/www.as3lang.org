package net.http.web
{
    import flash.system.System;
    import flash.utils.describeType;
    
    import net.http.Configuration;
    
    import shell.FileSystem;
    
    /**
     * The WebGateway configuration.
     * 
     * We need a way to configure our server and
     * we need it to work at different level
     * - internal defaults
     *   those are the properties we want to set by default
     *   but also allow them to be overrided by the user.
     * - user config
     *   your own config for your website
     *   where you can define your own properties for your website
     *   and where you can override the defaults.
     * - file config
     *   all of the above but defined in an external file loaded dynamically
     *   so you can override some behaviours without having to recompile.
     * 
     * In the WebConfig class you will find the "web framework" defaults
     * 
     * If you don't define your own config, this class properties will be used
     * as the defaults to configure the <code>WebGateway</code> behaviour.
     * 
     * The general usage is to extend this class with your own class
     * `Config extends WebConfig`
     * and pass this config to the WebGateway or the class extending it.
     *
     * for example:
     * 
     * import org.as3lang.www.Config;
     * import org.as3lang.www.WebSite;
     * 
     * var config:Config;
     * var website:WebSite;
     * 
     * config = new Config();
     * website = new WebSite( config );
     * 
     *  
     * Another usage is to create a JSON configuration file
     * and load it from the beginning 
     * 
     * for example:
     * 
     * import net.http.web.WebConfig;
     * import org.as3lang.www.WebSite;
     * 
     * var config:WebConfig;
     * var website:WebSite;
     * 
     * config = new WebConfig();
     * config.load( "config.json" );
     * website = new WebSite( config );
     * 
     * Note:
     * In this configuration we advise you to favour
     * 
     * - 1 level of properties
     *   you would not want (even if it could work)
     *   public var something:Object = { aaa: true, bbb: false };
     *   you certainly don't want to use a custom type as it will not work
     *   public var other:Thing = new Thing( true, false );
     * 
     * - descriptive properties
     *   using the first word as category
     *   public var somethingAaa:Boolean = true;
     *   public var somethingBbb:Boolean = false;
     * 
     * - use only JSON types
     *   if you need to deal with custom types
     *   use a String of the full class path
     *   and dynamic instanciation
     *   
     * 
     */ 
    public class WebConfig implements Configuration
    {
        
        /* Sessions */
        
        /**
         * Allows to enable (or disable) sessions.
         */ 
        public var sessionEnabled:Boolean = true;
        
        /**
         * The session token name to use in the cookie.
         * 
         * <p>
         * If you look at the HTTP headers you should see something like
         * <code>Cookie: AS3SESSID=80146134-a17f-4f89-81f5-995de9889e2c</code>
         * </p>
         */
        public var sessionTokenName:String = "AS3SESSID";
        
        /**
         * Specifies wether the session is automatically created as soon
         * as the Gateway receive an HttpRequest.
         */
        public var sessionAutoStart:Boolean = false;
        
        /**
         * Specifies the type of <code>Session</code> to use.
         */
        public var sessionType:String = "net.http.sessions.FileSession";
        
        /* Note:
           We want to support only sessions using cookie
           and decide to not support passing session id in the URL.
        
           The default cookie options found here reflect the one
           found in the Cookie class
        */
        
        /**
         * The lifetime of the cookie in milliseconds.
         * 
         * <p>
         * <code>0</code> is for "Session Cookies" (eg. "until the browser is closed").
         * <code>-1</code> (or any negative integer) will force the cookie to expire.
         * </p>
         * 
         * @example Usage
         * <listing>
         * // set the timeout to 15 minutes
         * SessionManager.cookieExpires = 15 * Cookie.MINUTE;
         * </listing>
         */
        public var sessionCookieExpires:int = 0;
        
        /**
         * 
         */
        public var sessionCookieDomain:String = "";
        
        /**
         * 
         */
        public var sessionCookiePath:String = "/";
        
        /**
         * 
         */
        public var sessionCookieSecure:Boolean = false;
        
        /**
         * 
         */
        public var sessionCookieHttpOnly:Boolean = false;
        
        /* FileSessionStorage */
        
        /**
         * 
         */
        public var sessionStorageFilepath:String = "";
        
        
        
        public function WebConfig()
        {
            super();
        }

        /**
         * Load an external JSON files
         * and merge the data into the <code>WebConfig</code> object.
         * 
         * @param filename the path to the JSON config file.
         */
        public function load( filename:String ):void
        {
            if( FileSystem.exists( filename ) )
            {
                var str:String = FileSystem.read( filename );
                var obj:Object = JSON.parse( str );
                
                if( obj )
                {
                    merge( obj );
                }
            }
        }
        
        /**
         * Merge the properties of a litteral object
         * into the <code>WebConfig</code> object.
         * 
         * <p>
         * Only pre-existing <code>WebConfig</code> object properties
         * will be merged, any other will be ignored.
         * </p>
         * 
         * @param o The litteral Object.
         */ 
        public function merge( o:Object ):void
        {
            for( var m:String in o )
            {
                if( hasOwnProperty( m ) )
                {
                    this[m] = o[m];
                }
            }
        }
        
        /**
         * 
         */
        public function toObject():Object
        {
            var obj:Object = {};
            var _class:XML = describeType( this );
            //trace( _class );
            
            var properties:Array = [];
            for each( var member:XML in _class.variable )
            {
                properties.push( member.@name );
            }
            System.disposeXML( _class );
            
            var i:uint;
            var len:uint = properties.length;
            var property:String;
            for( i = 0; i < len; i++ )
            {
                property = properties[i];
                //trace( "[" + i +"]: " + property );
                obj[ property ] = this[ property ];
            }
            
            return obj;
        }
        
    }
}