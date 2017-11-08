package shoe3d.component.view2d;
import js.Three;
import js.three.Color;

/**
 * ...
 * @author as
 */

enum GradientType {
	Vertical( top:Int, bottom:Int ) ;
	Horizontal( left:Int, right:Int );
	//Quadriple( leftTop:Int, rightTop:Int, rightBottom:Int, leftBottom:Int )
}
 
class SimpleGradientSprite extends FillSprite
{
	public var type(default, null):GradientType;
	
	public function new( width:Float, height:Float, ?type:GradientType ) {
		super( width, height, 0xffffff );
		this.type = type == null ? Vertical(0xffffff, 0x000000) : type;
		
		material.vertexColors = Three.VertexColors;
		material.needsUpdate = true;
		for ( face in geom.faces ) face.vertexColors = [ for( t in 0...3 ) new Color(0xff0000) ];
		redefineSprite();
		
	}
	

	override function redefineSprite() 	{
		super.redefineSprite();
		
		if( type != null )
			switch( type ) {
				case Vertical(top, bottom):
					geom.faces[0].vertexColors[0].setHex( top ); //top left
					geom.faces[0].vertexColors[1].setHex( bottom ); //bottom left
					geom.faces[0].vertexColors[2].setHex( top ); //top right
					geom.faces[1].vertexColors[0].setHex( bottom ); //bottom left
					geom.faces[1].vertexColors[1].setHex( bottom ); //bottom right
					geom.faces[1].vertexColors[2].setHex( top ); //top right
				case Horizontal(left, right ):
					geom.faces[0].vertexColors[0].setHex( left ); //top left
					geom.faces[0].vertexColors[1].setHex( left ); //bottom left
					geom.faces[0].vertexColors[2].setHex( right ); //top right
					geom.faces[1].vertexColors[0].setHex( left ); //bottom left
					geom.faces[1].vertexColors[1].setHex( right ); //bottom right
					geom.faces[1].vertexColors[2].setHex( right ); //top right
			}
		
		geom.colorsNeedUpdate = true;
	}
	
	public function set( gt:GradientType ) {
		type = gt;
		redefineSprite();
		return this;
	}
	
	public function flip() {
		if ( type != null ) {
			switch(type) {
				case Vertical(top, bottom):
					type = Vertical(bottom, top);
				case Horizontal(l, r):
					type = Horizontal( r, l );
			}
			redefineSprite();
		}
		
		return this;
	}
	
}