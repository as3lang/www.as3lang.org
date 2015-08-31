
include "includes.as";

import net.http.web.WebConfig;

import org.as3lang.www.WebSite;

var config:WebConfig;
var website:WebSite;

try
{
    /* Note:
       This configuration is specific to the hosting of as3lang.org
       if you are in a different setup you will have to change/override it
       
       for ex: if you want to test locally
       config.sessionStorageFilepath = "";
       and the sessions file will be saved at the root of the current directory
    */
    config = new WebConfig();
    config.sessionStorageFilepath = "/home/vhosts/as3lang.org/www/data/sessions/";
    
    
    website = new WebSite( config );
    website.run();
}
catch( e:Error )
{
    trace( "Content-Type: text/plain; charset=utf-8" );
    trace( "" );
    trace( e.getStackTrace() );
}
