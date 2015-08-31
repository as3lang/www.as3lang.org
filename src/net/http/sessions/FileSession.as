package net.http.sessions
{
    import net.http.Gateway;
    import net.http.HttpRequest;
    import net.http.web.WebConfig;
    import net.http.web.WebGateway;
    
    /* TODO:
       add try/catch for when accessing storage
    
       for ex:
    Error: Error #1501: Error occurred writing to file /home/vhosts/as3lang.org/www/data/sessions/47846ab4-ceaa-4e13-ad29-10a361ed4106.
    at Error$/throwError()
    at shell::FileSystem$/write()
    at net.http.sessions::FileSessionStorage/flush()
    at net.http.sessions::FileSessionStorage/open()
    at net.http.sessions::FileSession/start()
    at org.as3lang.www::Home$/onTestSession()
    at net.http.router.rules::RegExpRule/call()
    at net.http.cgi::CommonRouter/_route()
    at net.http.cgi::CommonRouter/route()
    at net.http.web::WebGateway/route()
    at net.http.web::WebGateway/apply()
    at net.http.cgi::CommonGateway/run()
    at global$init()
    
       the Session have access to the gateway
       and so is responsible to catch and log/throw errors
    */
    
    public class FileSession implements Session
    {
        private var _gateway:Gateway;
        private var _storage:FileSessionStorage
        
        private var _id:String;
        
        public function FileSession( gateway:Gateway )
        {
            super();
            
            _gateway = gateway;
            _storage = new FileSessionStorage();
            
            _id = "";
        }
        
        public function get id():String
        {
            var sessions:SessionManager = WebGateway( _gateway ).sessions;
            
            if( (sessions.status == SessionStatus.disabled) ||
                (sessions.status == SessionStatus.stopped) )
            {
                return "";
            }
            
            return _id;
        }
        
        public function get data():Object
        {
            var sessions:SessionManager = WebGateway( _gateway ).sessions;
            
            if( (sessions.status == SessionStatus.disabled) ||
                (sessions.status == SessionStatus.stopped) )
            {
                return null;
            }
            
            return _storage.data;
        }
        
        public function start():void
        {
            var config:WebConfig = _gateway.config as WebConfig;
            var sessions:SessionManager = WebGateway( _gateway ).sessions;
            
            if( (sessions.status == SessionStatus.disabled) ||
                (sessions.status == SessionStatus.active) )
            {
                return;
            }
            
            if( sessions.current == "" )
            {
                var uuid:String = sessions.findToken( _gateway.request as HttpRequest );
                if ( uuid == "" )
                {
                    _id = sessions.createUUID();
                    sessions.isNew = true;    
                }
                else
                {
                    _id = uuid;
                }
            }
            else
            {
                _id = sessions.current;
            }
            
            sessions.current  = _id;
            _storage.filename = config.sessionStorageFilepath + _id;
            _storage.ipaddress = _gateway.environment.remoteAddress;
            _storage.open();
            
            sessions.status = SessionStatus.active;
        }
        
        public function clear():void
        {
            var sessions:SessionManager = WebGateway( _gateway ).sessions;
            
            if( (sessions.status == SessionStatus.disabled) ||
                (sessions.status == SessionStatus.stopped) )
            {
                return;
            }
            
            if( _storage.isValid() )
            {
                _storage.clear();
            }
        }
        
        public function stop():void
        {
            var sessions:SessionManager = WebGateway( _gateway ).sessions;
            
            //simpler/faster to (sessions.status != SessionStatus.active)
            if( (sessions.status == SessionStatus.disabled) ||
                (sessions.status == SessionStatus.none) ||
                (sessions.status == SessionStatus.stopped) )
            {
                return;
            }
            
            if( _storage.isValid() )
            {
                _storage.ipaddress = _gateway.environment.remoteAddress;
                _storage.flush();
                sessions.status = SessionStatus.stopped;   
            }
        }
        
        public function destroy():void
        {
            var sessions:SessionManager = WebGateway( _gateway ).sessions;
            
            if( sessions.status == SessionStatus.disabled )
            {
                return;
            }
            
            if( _storage.isValid() )
            {
                sessions.destroy( _id );
                sessions.needCleanUp = true;
                
                _storage.destroy();
                
                sessions.status = SessionStatus.none;   
            }
        }
        
    }
}