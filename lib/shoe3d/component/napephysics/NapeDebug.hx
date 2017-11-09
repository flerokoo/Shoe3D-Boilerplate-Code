package shoe3d.component.napephysics;
import nape.shape.Circle;
import nape.shape.Polygon;
import shoe3d.core.game.Component;
import js.three.Geometry;
import js.three.LineBasicMaterial;
import js.three.LineSegments;
import js.three.Vector3;

/**
 * ...
 * @author as
 */
class NapeDebug extends Component
{
	public var space(default, null):NapeSpace;
	public var circleQuality:Int = 24;
	public var material(default, null):LineBasicMaterial;
	var _lines:LineSegments;
	var _verts:Array<Vector3>;
	var _geom:Geometry;

	var _firstComponentIndex = 0;
	var _secondComponentIndex = 1;
	
	
	public function new( space:NapeSpace, ?color:Int ) 
	{
		super();
		this.space = space;
		material = new LineBasicMaterial( { color: color==null ? 0x2B70FF : color  } );
		_verts = [for ( i in 0...10000) new Vector3()];
		_geom = new Geometry();
		_geom.vertices = _verts;		
		_lines = new LineSegments( _geom, material );
		_lines.frustumCulled = false;

	}
	
	override public function onAdded() 
	{
		
		super.onAdded();
		owner.transform.add( _lines );
	}
	
	override public function onUpdate() 
	{
		var vi = 0; // cur vertex id
		for ( body in space.space.bodies ) {
			
			for ( shape in body.shapes ) {
				
				if ( shape.isPolygon() ) {
					var poly:Polygon = shape.castPolygon;
					var verts = poly.worldVerts;
					var len = verts.length;
					var cur = 0;
					var prev = len - 1;
					while ( cur < len ) {
						var curVert = verts.at(cur);
						var prevVert = verts.at(prev);												
						_verts[vi].setComponent(_firstComponentIndex, prevVert.x );
						_verts[vi].setComponent(_secondComponentIndex, prevVert.y );					
						vi++;
						_verts[vi].setComponent( _firstComponentIndex, curVert.x );
						_verts[vi].setComponent(_secondComponentIndex, curVert.y );
						vi++;
						cur++;
						prev = cur - 1;
					}
				} // poly
				
				if ( shape.isCircle() ) {					
					var circle:Circle = shape.castCircle;
					var angle = body.rotation;
					var alpha = 2 * Math.PI / circleQuality;
					var radius = circle.radius;
					var cx = body.position.x;
					var cy = body.position.y;

					
					_verts[vi].setComponent(_firstComponentIndex, body.position.x);
					_verts[vi].setComponent(_secondComponentIndex, body.position.y);
					vi++;

					_verts[vi].setComponent(_firstComponentIndex, cx + radius * Math.cos(angle));
					_verts[vi].setComponent(_secondComponentIndex, cy + radius * Math.sin(angle));
					vi++;

					for ( i in 0...circleQuality ) {
						_verts[vi].setComponent(_firstComponentIndex, cx + radius * Math.cos( angle + (i - 1) * alpha ));
						_verts[vi].setComponent(_secondComponentIndex, cy + radius * Math.sin( angle + (i - 1) * alpha ));
						vi++;
						_verts[vi].setComponent(_firstComponentIndex, cx + radius * Math.cos( angle + (i) * alpha ));
						_verts[vi].setComponent(_secondComponentIndex, cy + radius * Math.sin( angle + (i) * alpha ));
						vi++;			
					}
				} // circle
				
			} // shapes drawn

		}
		_geom.verticesNeedUpdate = true;		
	}

	public function setCoordinatesMapping( x:Int, y:Int ) {
		_firstComponentIndex = x;
		_secondComponentIndex = y;
		return this;
	}
	
	override public function onRemoved() 
	{
		owner.transform.remove( _lines );
	}
	

}