package encoding.ansi
{
    /**
     * The ANSI String class.
     * 
     * <p>
     * Allow to parse a string containing "ANSI notation"
     * to a string with ANSI escape codes.
     * </p>
     * 
     * <p>
     * The ANSI notation is a bit like the markdown of the ANSI strings.
     * </p>
     * 
     * <p>
     * ANSI colors are nice but they come with some problems
     * </p>
     * <ul>
     *   <li>it depends on a library, without it your AS3 code will break.</li>
     *   <li>it is daunting, not practical and repetitive to use <code>colorize()</code> in the middle of your regular strings.</li>
     *   <li>it will not work under Windows</li>
     * </ul>
     * 
     * <p>
     * To remedy all those little problems we came with an "ANSI notation"
     * which look like that <code>"Hello World「Y!&#42; 」"</code>.
     * 
     * The idea is to allow you to implement a <code>toANSIString()</code> method to your classes
     * without having a hard dependency on the <strong>ansilib</strong>.
     * </p>
     * 
     * <p>
     * It works like that, with <code>"Hello World「Y!&#42; 」"</code>,
     * is a notation that basically says <code>"(regular string)「ANSI code」"</code>,
     * or apply this "sequence of ANSI code" to the preceding "string sequence".
     * 
     * The ANSI code sequences are contained within <code>「</code> and <code>」</code>,
     * and inside those separators, one character is equivalent to an ANSI escape code:
     * <code>k</code> for <code>colors.black</code>, <code>!</code> for <code>controls.bold</code>, etc.
     * 
     * Here the mapping of those characters:
     * </p>
     * 
     * <table class="innertable">
     * <th><tr><td><b>character</b></td><td><b>ANSI escape code</b></td></tr></th>
     * <tr><td><b>!</b></td><td><code>controls.bold</code></td></tr>
     * <tr><td><b>_</b></td><td><code>controls.underline</code></td></tr>
     * <tr><td><b>&#42;</b></td><td><code>controls.flash</code></td></tr>
     * <tr><td><b>i</b></td><td><code>controls.invert</code></td></tr>
     * <tr><td><b>?</b></td><td><code>controls.conceal</code></td></tr>
     * <tr><td><b>" "</b></td><td><code>ignoreSpace = false</code></td></tr>
     * <tr><td><b>k</b></td><td><code>colors.black</code></td></tr>
     * <tr><td><b>r</b></td><td><code>colors.red</code></td></tr>
     * <tr><td><b>g</b></td><td><code>colors.green</code></td></tr>
     * <tr><td><b>y</b></td><td><code>colors.yellow</code></td></tr>
     * <tr><td><b>b</b></td><td><code>colors.blue</code></td></tr>
     * <tr><td><b>m</b></td><td><code>colors.magenta</code></td></tr>
     * <tr><td><b>c</b></td><td><code>colors.cyan</code></td></tr>
     * <tr><td><b>w</b></td><td><code>colors.white</code></td></tr>
     * <tr><td><b>K</b></td><td><code>colors.brightBlack</code></td></tr>
     * <tr><td><b>R</b></td><td><code>colors.brightRed</code></td></tr>
     * <tr><td><b>G</b></td><td><code>colors.brightGreen</code></td></tr>
     * <tr><td><b>Y</b></td><td><code>colors.brightYellow</code></td></tr>
     * <tr><td><b>B</b></td><td><code>colors.brightBlue</code></td></tr>
     * <tr><td><b>M</b></td><td><code>colors.brightMagenta</code></td></tr>
     * <tr><td><b>C</b></td><td><code>colors.brightCyan</code></td></tr>
     * <tr><td><b>W</b></td><td><code>colors.brightWhite</code></td></tr>
     * <tr><td><b>0</b></td><td><code>backgrounds.black</code></td></tr>
     * <tr><td><b>1</b></td><td><code>backgrounds.red</code></td></tr>
     * <tr><td><b>2</b></td><td><code>backgrounds.green</code></td></tr>
     * <tr><td><b>3</b></td><td><code>backgrounds.yellow</code></td></tr>
     * <tr><td><b>4</b></td><td><code>backgrounds.blue</code></td></tr>
     * <tr><td><b>5</b></td><td><code>backgrounds.magenta</code></td></tr>
     * <tr><td><b>6</b></td><td><code>backgrounds.cyan</code></td></tr>
     * <tr><td><b>7</b></td><td><code>backgrounds.white</code></td></tr>
     * </table>
     * 
     */ 
    public class AnsiString
    {
        
        public static var before:String = "「";
        public static var after:String  = "」";

        public static var map:Object = new Object();
                          map[ "!" ] = controls.bold;
                          map[ "_" ] = controls.underline;
                          map[ "*" ] = controls.flash;
                          map[ "i" ] = controls.invert;
                          map[ "?" ] = controls.conceal;
                          map[ "k" ] = colors.black;
                          map[ "r" ] = colors.red;
                          map[ "g" ] = colors.green;
                          map[ "y" ] = colors.yellow;
                          map[ "b" ] = colors.blue;
                          map[ "m" ] = colors.magenta;
                          map[ "c" ] = colors.cyan;
                          map[ "w" ] = colors.white;
                          map[ "K" ] = colors.brightBlack;
                          map[ "R" ] = colors.brightRed;
                          map[ "G" ] = colors.brightGreen;
                          map[ "Y" ] = colors.brightYellow;
                          map[ "B" ] = colors.brightBlue;
                          map[ "M" ] = colors.brightMagenta;
                          map[ "C" ] = colors.brightCyan;
                          map[ "W" ] = colors.brightWhite;
                          map[ "0" ] = backgrounds.black;
                          map[ "1" ] = backgrounds.red;
                          map[ "2" ] = backgrounds.green;
                          map[ "3" ] = backgrounds.yellow;
                          map[ "4" ] = backgrounds.blue;
                          map[ "5" ] = backgrounds.magenta;
                          map[ "6" ] = backgrounds.cyan;
                          map[ "7" ] = backgrounds.white;
                        //map[ " " ] = will set ignoreSpace = false 
        
        public var source:String;
        public var symbols:Object = AnsiString.map;

        public var ignoreColor:Boolean = false;
        public var ignoreSpace:Boolean = true;
        
        /**
         * Build an ANSI string based on the ANSI "notation".
         */ 
        public function AnsiString( source:String )
        {
            super();
            this.source = source;
        }
        
        private function _getSymbols( args:Array ):Array
        {
            var csymbols:Array = [];
            var i:uint;
            var len:uint = args.length;
            for( i = 0; i < len; i++ )
            {
                csymbols.push( this.symbols[ args[i] ] );
            }

            return csymbols;
        }
        
        private function _translateLine( raw:String ):String
        {
            raw += before + after;

            var str:String = "";
            var re:RegExp = new RegExp( "(?P<word>.*?)" + "\\" + before + "(?P<ansi>.*?)" + "\\" + after , "g" );
            var match:*;
            
            while( match = re.exec( raw ) )
            {
                if( !ignoreColor && (match.ansi != "") )
                {
                    var space:Boolean = this.ignoreSpace;
                    if( match.ansi.indexOf( " " ) > -1 )
                    {
                        space = false;
                        match.ansi = match.ansi.split( " " ).join( "" );
                    }
                    var params:Array = match.ansi.split( "" );
                    var pos:int = match.word.lastIndexOf( " " );

                    if( space && (pos > -1) )
                    {
                        str += match.word.substr( 0, pos+1 );
                        str += colorizeWith( match.word.substr( pos+1 ) , _getSymbols( params ) );
                    }
                    else
                    {
                        str += colorizeWith( match.word, _getSymbols( params ) );
                    }
                }
                else
                {
                    str += match.word;
                }
            }

            return str;
        }
        
        private function _translate( raw:String ):String
        {
            if( raw.indexOf( "\n" ) > -1 )
            {
                var lines:Array = raw.split( "\n" );
                var i:uint;
                var len:uint = lines.length;
                for( i = 0; i < len; i++ )
                {
                    lines[i] = _translateLine( lines[i] );
                }
                return lines.join( "\n" );
            }
            else
            {
                return _translateLine( raw );
            }
        }
        
        /**
         * Utility method to alternate the ANSI sequence per letter.
         */
        public function altLetter( seq1:String, seq2:String ):void
        {
            var s1:String = before + seq1 + after;
            var s2:String = before + seq2 + after;

            var newsrc:String = "";
            var i:uint;
            var len:uint = this.source.length;
            var seq:String = s1;
            var c:String;
            for( i = 0; i < len; i++ )
            {
                c = this.source.charAt(i);
                switch( c )
                {
                    case " ":
                    case "\n":
                    case "\r":
                    newsrc += c;
                    continue;
                    break;

                    default:
                    newsrc += c + seq;
                    seq = (seq == s1) ? s2: s1;
                }
            }

            this.source = newsrc;
        }
        
        /**
         * Utility method to alternate the ANSI sequence per word.
         */
        public function altWord( seq1:String, seq2:String ):void
        {
            var s1:String = before + seq1 + after;
            var s2:String = before + seq2 + after;

            var newsrc:String = "";
            var i:uint;
            var len:uint = this.source.length;
            var seq:String = s1;
            var c:String;
            var l:String;
            for( i = 0; i < len; i++ )
            {
                c = this.source.charAt(i);
                switch( c )
                {
                    case "\n":
                    case "\r":
                    newsrc += c;
                    //continue;
                    break;

                    case " ":
                    newsrc += c;
                    //continue;
                    break;

                    default:
                    if( l == " " )
                    {
                        seq = (seq == s1) ? s2: s1;    
                    }
                    newsrc += c + seq;
                }
                l = c;
            }

            this.source = newsrc;
        }
        
        /**
         * Utility method to alternate the ANSI sequence per line.
         */
        public function altLine( seq1:String, seq2:String ):void
        {
            if( seq1.indexOf( " " ) < 0 ) { seq1 += " "; }

            if( seq2.indexOf( " " ) < 0 ) { seq2 += " "; }

            var s1:String = before + seq1 + after;
            var s2:String = before + seq2 + after;

            var newsrc:String = "";
            var i:uint;
            var len:uint = this.source.length;
            var seq:String = s1;
            var c:String;
            var end:String = "";
            for( i = 0; i < len; i++ )
            {
                c = this.source.charAt(i);
                
                switch( c )
                {
                    case " ":
                    case "\r":
                    newsrc += c;
                    continue;
                    break;

                    case "\n":
                    seq = (seq == s1) ? s2: s1;
                    newsrc += seq + c;
                    continue;
                    break;

                    default:
                    newsrc += c;
                }

            }

            seq = (seq == s1) ? s2: s1;
            this.source = newsrc + seq;
        }
        
        /**
         * Returns a string with ANSI escape codes.
         */
        public function toString():String
        {
            var str:String = "";
                str += _translate( this.source );
            return str;
        }
        
        /**
         * Returns a string without the ANSI escape codes.
         */
        public function valueOf():String
        {
            var str:String = "";
            var original:Boolean = ignoreColor;
            ignoreColor = true;
                str += toString();
            ignoreColor = original;
            return str;
        }
        
    }
}