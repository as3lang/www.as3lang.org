

include "includes.as";

import org.as3lang.www.WebSite;

var website:WebSite;

try
{
    website = new WebSite();
    website.run();
}
catch( e:Error )
{
    trace( "Content-Type: text/plain; charset=utf-8" );
    trace( "" );
    trace( e.getStackTrace() );
}
