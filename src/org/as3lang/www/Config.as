package org.as3lang.www
{
    import net.http.web.WebConfig;
    
    public class Config extends WebConfig
    {
        
        public var test:Boolean = false;
        
        public var hello:String = "world";
        
        public var yeah:int = 123;
        
        public function Config()
        {
            super();
        }
    }
}