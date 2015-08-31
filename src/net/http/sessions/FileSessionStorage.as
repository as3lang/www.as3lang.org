package net.http.sessions
{
    
    import shell.FileSystem;
    
    /**
     * The FileSessionStorage sue the FileSystem to store the user data.
     * 
     * The format to save the data is JSON.
     */ 
    public class FileSessionStorage implements SessionStorage
    {
        private var _locked:Boolean;
        
        private var _ipaddress:String;
        private var _created:Date;
        private var _synchronised:Date;
        private var _data:Object;
        
        public var filename:String;
        
        public function FileSessionStorage( filename:String = "" )
        {
            super();
            
            _locked       = true;
            
            _created      = null;
            _synchronised = null;
            _data         = {};
            
            this.filename = filename;
        }
        
        public function get data():Object { return _data; }
        
        public function get ipaddress():String { return _ipaddress; }
        public function set ipaddress( value:String ):void { _ipaddress = value; }
        
        public function get created():Date { return _created; }
        
        public function get synchronised():Date { return _synchronised; }
        
        public function get size():Number
        {
            if( _locked ) { return 0; }
            
            return FileSystem.getFileSize( filename );
        }
        
        public function isValid():Boolean
        {
            if( FileSystem.exists( filename ) &&
                FileSystem.canAccess( filename ) &&
                FileSystem.canRead( filename ) &&
                FileSystem.canWrite( filename ) )
            {
                return true;
            }
            
            return false;
        }
        
        public function open():void
        {
            if( !FileSystem.exists( filename ) )
            {
                //create
                _created      = new Date();
                _synchronised = _created;
                flush();
                
                _locked = false;
            }
            else
            {
                _locked = false;
                
                //resume
                load();
            }
            
        }
        
        public function clear():void
        {
            if( _locked ) { return; }
            
            load();
            _data = {};
            flush();
        }
        
        public function load():void
        {
            if( _locked ) { return; }
            
            var str:String = FileSystem.read( filename );
            var obj:Object = JSON.parse( str );
            
            //metadata
            if( "_ipaddress" in obj )
            {
                _ipaddress = obj._ipaddress;
                delete obj._ipaddress;
            }
            
            if( "_created" in obj )
            {
                _created = new Date( obj._created );
                delete obj._created;
            }
            
            if( "_synchronised" in obj )
            {
                delete obj._synchronised;
            }
            
            _data = obj;
            _synchronised = new Date();
        }
                
        public function flush():void
        {
            _synchronised = new Date();
            
            var obj:Object = _data;
                //metadata
                obj._ipaddress    = _ipaddress;
                obj._created      = _created.valueOf();
                obj._synchronised = _synchronised.valueOf();
            var str:String = JSON.stringify( obj );
            
            FileSystem.write( filename, str );
        }
        
        public function destroy():void
        {
            if( _locked ) { return; }
            
            FileSystem.removeFile( filename );
        }
        
    }
}