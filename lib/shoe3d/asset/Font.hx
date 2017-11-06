package shoe3d.asset;
import shoe3d.asset.AssetPack.TexDef;
import shoe3d.util.math.Rectangle;
import shoe3d.util.UVTools;
import shoe3d.util.UVTools.UV;

/**
 * ...
 * @author as
 */
using StringTools;
using shoe3d.util.StringHelp;

class Font
{
	public static var LINEBREAK = new Glyph('\n'.charCodeAt(0) );
	public var name(default, null):String;
	public var fontSize(default, null):Float;
	public var lineHeight(default, null):Float;
	var _pack:AssetPack;
	var _file:String;
    var _glyphs :Map<Int,Glyph>;	
	
	
	
	public function new( desciptorName:String, pack:AssetPack) {
		this._pack = pack;
		_file = pack.getFile(desciptorName).content;	
		name = desciptorName;
		parse();
	}
	
	public function parse() {
		_glyphs = new Map();
        _glyphs.set(LINEBREAK.charCode, LINEBREAK);

        var parser = new FntParser(_file.toString());
        var pages = new Map<Int,TexDef>();

        var idx = name.lastIndexOf("/");
        var basePath = (idx >= 0) ? name.substr(0, idx+1) : "";

        //http://www.angelcode.com/products/bmfont/doc/file_format.html
        for (keyword in parser.keywords()) {
            switch (keyword) {
            case "info":
                for (pair in parser.pairs()) {
                    switch (pair.key) {
                    case "size":
                        fontSize = pair.getInt();
                    }
                }

            case "common":
                for (pair in parser.pairs()) {
                    switch (pair.key) {
                    case "lineHeight":
                        lineHeight = pair.getInt();
                    }
                }

            case "page":
                var pageId :Int = 0;
                var file :String = null;
                for (pair in parser.pairs()) {
                    switch (pair.key) {
                    case "id":
                        pageId = pair.getInt();
                    case "file":
                        file = pair.getString();
                    }
                }
                pages.set(pageId, _pack.getTexDef(basePath + file.removeFileExtension()));

            case "char":
                var glyph = null;
                for (pair in parser.pairs()) {
                    switch (pair.key) {
                    case "id":
                        glyph = new Glyph(pair.getInt());
                    case "x":
                        glyph.x = pair.getInt();
                    case "y":
                        glyph.y = pair.getInt();
                    case "width":
                        glyph.width = pair.getInt();
                    case "height":
                        glyph.height = pair.getInt();
                    case "page":
                        glyph.page = pages.get(pair.getInt());
                    case "xoffset":
                        glyph.xOffset = pair.getInt();
                    case "yoffset":
                        glyph.yOffset = pair.getInt();
                    case "xadvance":
                        glyph.xAdvance = pair.getInt();
                    }
                }
                _glyphs.set(glyph.charCode, glyph);

            case "kerning":
                var first :Glyph = null;
                var second = 0, amount = 0;
                for (pair in parser.pairs()) {
                    switch (pair.key) {
                    case "first":
                        first = _glyphs.get(pair.getInt());
                    case "second":
                        second = pair.getInt();
                    case "amount":
                        amount = pair.getInt();
                    }
                }
                if (first != null && amount != 0) {
                    first.setKerning(second, amount);
                }
            }
        }
		
		for ( i in _glyphs )
			i.calcUV();
	}
	
	public function getGlyph( code:Int ):Glyph {
		return _glyphs[code];
	}
}

class Glyph
{
	public var charCode (default, null) :Int;
	public var char(default, null):String;

    // Location and dimensions of this glyph on the sprite sheet
    public var x :Int = 0;
    public var y :Int = 0;
    public var width :Int = 0;
    public var height :Int = 0;
	public var uv:UV = null;
    public var page:TexDef = null;
	
    public var xOffset :Int = 0;
    public var yOffset :Int = 0;
    public var xAdvance :Int = 0;
	private var _kernings :Map<Int,Int> = null;
	
    @:allow(shoe3d) function new (charCode :Int)    {
        this.charCode = charCode;
		this.char = String.fromCharCode( charCode );
    }

    public function getKerning (nextCharCode :Int) :Int    {
        return (_kernings != null) ? Std.int(_kernings.get(nextCharCode)) : 0;
    }
	
	
	public function calcUV() {
		if ( page == null ) return;
		uv = {
			umin: x / page.width,
			umax: (x + width) / page.width,
			vmin: y / page.height,
			vmax: (y + height) / page.height
		};
				
		uv = UVTools.UVfromRectangle( new Rectangle(x, y, width, height), page.width, page.height);
		// TODO ADD SUPPORT FOR TEXDEFS
	}
	
    @:allow(shoe3d) function setKerning (nextCharCode :Int, amount :Int)    {
        if (_kernings == null) {
            _kernings = new Map();
        }
        _kernings.set(nextCharCode, amount);
    }

}

class FntParser
{ 
	private var _configText :String;
    // строка щас в обработка
    private var _pairText :String;
    private var _keywordPattern :EReg;
    private var _pairPattern :EReg;
	
	public function new (config :String)    {
        _configText = config;
        _keywordPattern = ~/([A-Za-z]+)(.*)/;
        _pairPattern = ~/([A-Za-z]+)=("[^"]*"|[^\s]+)/;
    }

    public function keywords () :Iterator<String>    {
        var text = _configText;
        return {
            next: function () {
                text = advance(text, _keywordPattern);
                _pairText = _keywordPattern.matched(2);
                return _keywordPattern.matched(1);
            },
            hasNext: function () {
                return _keywordPattern.match(text);
            }
        };
    }

    public function pairs () :Iterator<ConfigPair>    {
        var text = _pairText;
        return {
            next: function () {
                text = advance(text, _pairPattern);
                return new ConfigPair(_pairPattern.matched(1), _pairPattern.matched(2));
            },
            hasNext: function () {
                return _pairPattern.match(text);
            }
        };
    }

    private static function advance (text :String, expr :EReg)    {
        var m = expr.matchedPos();
        return text.substr(m.pos + m.len, text.length);
    }
   
}

private class ConfigPair
{
    public var key (default, null) :String;
    private var _value :String;
    
	public function new (key :String, value :String)    {
        this.key = key;
        _value = value;
    }

    public function getInt () :Int    {
        return Std.parseInt(_value);
    }

    public function getString () :String    {
        if (_value.fastCodeAt(0) != "\"".code) {
            return null;
        }
        return _value.substr(1, _value.length-2);
    }

}

enum TextAlign 
{
	Left;
	Right;
	Center;
}