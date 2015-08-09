package text.html
{
    import flash.utils.getTimer;
    
    import shell.FileSystem;
    import shell.Runtime;

    /**
     * A basic HTML Template Engine.
     * 
     * <p>
     * Based on 2 JS blog posts, inspired by PHP plain templates, and
     * ported to AS3.
     * </p>
     * 
     * <p>
     * JS can define a function from a string and we can not do that in AS3,
     * but with Redtamarin we have an eval() function which allow us to do
     * exactly the same.
     * </p>
     * 
     * @see http://ejohn.org/blog/javascript-micro-templating/ JavaScript Micro-Templating
     * @see http://krasimirtsonev.com/blog/article/Javascript-template-engine-in-just-20-line JavaScript template engine in just 20 lines
     * @see http://www.phptherightway.com/#plain_php_templates Plain PHP Templates
     */
    public class TemplateEngine
    {
        
        private var _re1:RegExp;
        private var _re2:RegExp;
        
        private var _template:String;
        private var _path:String;
        
        private var _error:Error;
        private var _errorName:String;
        private var _funName:String;
        
        private var _source:String;
        
        /**
         * 
         */
        public function TemplateEngine( template:String = "",
                                        path:String = "" )
        {
            super();
            
            /* The regexp for the tokens
               basicaly we want to interpret special variables
               and to reckonise those are special they need to be
               delimited with <% and %>
               for example: "hello <% keyword %>"
            */
            _re1 = /<%([^%>]+)?%>/g;
            
            /* The regexp for special language keywords
               so we can add some logic in the templates
               for example: "<% if( foobar ) { %> hello world <% } %>"
               
               Yes, all this does ressemble quite a lot the plain PHP templates.
            */
            _re2 = /(^()?(if|for|else|switch|case|break|{|}))(.*)?/g;
            
            _template = template;
            _path     = path;
            
            _error     = null;
            _errorName = _buildErrorName();
            _funName   = _buildFunctionName();
            _source    = "";
            
            _resetGlobalError();
        }
        
        private function _randomRange( min:Number = 0, max:Number = 9 ):Number
        {
            return ( Math.floor( Math.random() * (max - min - 1) ) + 1 );
        }
        
        private function _buildErrorName():String
        {
            return "err" + getTimer() + _randomRange();
        }
        
        private function _buildFunctionName():String
        {
            return "fun" + getTimer() + _randomRange() + _randomRange() + _randomRange();
        }
        
        private function _resetGlobalError():void
        {
            _global[ _errorName ] = null;
        }
        
        /**
         * If an error occured while evaluating the script it will be stored
         * there, otherwise returns null.
         */
        public function get error():Error { return _error; }
        
        /**
         * The error name used by this template to store Error object in global.
         */
        public function get errorName():String { return _errorName; }
        
        /**
         * Allows to retrieve the sources of the code before it got evaluated.
         */
        public function get source():String { return _source; }
        
        /**
         * 
         */
        public function get template():String { return _template; }
        /** @private */
        public function set template( value:String ):void { _template = value; }
        
        /**
         * 
         */
        public function get path():String { return _path; }
        /** @private */
        public function set path( value:String ):void { _path = value; }
        
        
        /**
         * Load a filepath from the fiel system.
         */
        public function load( filepath:String ):Boolean
        {
            var file:String;
            
            try
            {
                file = FileSystem.read( filepath );
            }
            catch( e:Error )
            {
                return false;
            }
            
            _template = file;
            return true;
        }
        
        /**
         * Load a file name reusing the same path defined for this template.
         */
        public function loadFromPath( name:String ):Boolean
        {
            var path:String = "";
            
            if( _path != "" )
            {
                path = _path;
                path = FileSystem.ensureEndsWithSeparator( path );
            }
            
            path += name;
            
            return load( path );
        }
        
        /**
         * Apply a set of data to the template and returns the result.
         */
        public function apply( obj:Object = null ):String
        {
            /* Note:
               what do we do ?
               1. we take the datas of an object
                  and generate lines of variables
                  eg.
                  var toto = "hello world"
               2. then we define a function
                  inside we define an array
                  each index of this array is one line
                  of our "source code"
                  eg.
                  fun123() {
                      var lines:Array = [];
                      //...
                  }
               3. based on our regexes we scan the string of the template
                  if we encoutner strigns we just add a line of strings
                  but if we encounter tokens
                  we add the token as if it was source code
                  eg. for the template "hello <% keyword %> world"
                  we end up with 3 lines
                  1. "hello "
                  2. keyword
                  3. " world"
                  eg.
                  fun123() {
                      var lines:Array = [];
                      lines.push( "hello " );
                      lines.push( keyword ); //it will evaluate here
                      lines.push( " world" );
                      //...
                  }
               4. at the end of the function we join all the indexes
                  of the array, which allow to evaluate the tokens
                  which then write source code
                  eg.
                  fun123() {
                      //...
                      return lines.join();
                  }
               5. we use the eval() function to evaluate this source code
                  which in turns generate a string
                  eg.
                  var result:String = eval( "fun123();" );
            */
            
            // will contain the evaluated string
            var test:String;
            
            // contains our data structure, a litteral object
            var data:* = obj;
            
            /* When you eval() code, sometimes it can generate errors
               and we use those vars to be bale to store those errors
               
               The global error is a very special case
               when you execute yoru AS3 code you are in context or scope
               which give you access to varialbes, functions, etc.
            
               and when you eval() code, you find yourself in another context
               
               but worst you may want to share data between those 2 context
               and it can be quite a problem.
            
               One way to solve that, is to create a global object defined
               in the unamed namespace
               eg.
               package
               {
                   public var _global:Object = {};
               }
            
               because it is the unamed package, this one will always be
               accessible (eg. you don't need to import it)
            
               and so we can use a public global variable named "_global"
               as an anchor point to share global variables
            
               yes, good old memories from AS1 times ;)
            */
            _error = null;
            _resetGlobalError();
            
            // the template string
            var tpl:String  = _template;
            
            // the source code we generate
            var code:String = "";
            
            var cursor:int  = 0;
            
            /* Note:
               this internal function is here to define variables
               at the top of our source code
               depending on the type of the variable (Object, String, etc.)
               the var can be defined differently
            */
            var decl:* = function( name:String, value:* ):void
            {
                if( value is Object )
                {
                    code += "var " + name + " = " + JSON.stringify( value ) + ";\n";
                }
                else if( value is String )
                {
                    code += "var " + name + " = \"" + value + "\";\n";
                }
                else
                {
                    code += "var " + name + " = " + value + ";\n";
                }
            };
            
            /* we go trough all our data and generates
               variables definitions in our source code string
            */
            var m:String;
            for( m in data )
            {
                decl( m, data[m] );
            }
            
            code += "\n";
            
            // from here we define our function
            code += "function " + _funName + "() {\n";
            code += "var r=[];\n";
            
            /* the add() internal function is a little helper
               to know which kind of lines we add inside our function
               sometimes we just want to add a lien of raw string
               some other times we want to add a token
               etc.
            */
            var add:* = function( line:String, keyword:Boolean = false ):void
            {
                var result:*;
                var str:String;
                
                if( keyword )
                {
                    result = line.match( _re2 );
                    if( (result != null) && (result != "")  )
                    {
                        code += line + "\n";
                    }
                    else
                    {
                        code += "r.push( " + line + " );\n";
                    }
                }
                else
                {
                    str = line;
                    str = str.replace( /"/g,    "\\\"" );
                    str = str.replace( /'/g,    "\\\'" );
                    str = str.replace( /[\t]/g, "\\t"  );
                    str = str.replace( /[\r]/g, "\\r"  );
                    str = str.replace( /[\n]/g, "\\n"  );
                    
                    if( str != "" )
                    {
                        code += "r.push( \"" + str + "\" );\n";
                    }
                }
            };
            
            var match:*;
            while( match = _re1.exec( tpl ) )
            {
                add( tpl.slice( cursor, match.index ) );
                add( match[1], true );
                cursor = match.index + match[0].length;
            }
            
            // add the rest of the template string
            add( tpl.substr( cursor, tpl.length - cursor) );
            
            // finnish the function
            code += "return r.join( \"\" );\n";
            code += "}\n";
            code += "\n";
            
            // build a try/catch
            code += "try {\n";
            // execute the function here
            code += _funName + "();\n";
            code += "} catch( e:Error ) {\n";
            // if we catch an error save it in the global error associated
            code += "_global." + _errorName + " = e\n";
            code += "}\n";
            code += "\n";
            
            // save the source code we generated
            _source = code;
            
            /* Here where things can get complex :)
               yes we use 2 try/catch
               1. here in our AS3 execution context
               and
               2. inside the evaluated code
            */
            try
            {
                test = Runtime.returnEval( code );
            }
            catch ( e:Error )
            {
                // if an error occurs here, we save it in our error property
                _error = e;
            }
            
            // if an error occured during the evaluation
            // we can detect it by checking out the global error property
            if( _global[ _errorName ] )
            {
                _error = _global[ _errorName ];
            }
            
            // finally we return the evaluated string
            return test;
        }
        
    }
}