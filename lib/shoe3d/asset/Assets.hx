package shoe3d.asset;
import js.three.Object3D;
import shoe3d.util.Assert;
import shoe3d.asset.AssetPack.TexDef;
import shoe3d.util.Log;
import shoe3d.util.promise.Promise;
import haxe.ds.Either;
import shoe3d.util.signal.*;
/**
 * ...
 * @author as
 */

typedef LoadingTaskHandle = {
	onProgress:SingleSignal<Float>,
	onComplete:SingleSignal<AssetPack>
}

typedef LoadingTask = {
	pack:String,
	handle:LoadingTaskHandle
}

typedef NotifyTask = {
	packs:Array<String>,
	callback:Void->Void
}

class Assets
{
	static var _loading:LoadingTask = null;
	static var _notifyTasks:Array<NotifyTask>;
	static var _queue:Array<LoadingTask>;
	static var _packMap:Map<String,AssetPack>;
	

	// LOADING MANAGEMENT
	
	public static function registerPack( pack:AssetPack, ?name:String ) 
	{
		if ( _packMap == null ) _packMap = new Map();
		if ( name == null || StringTools.replace( name, ' ', '' ) == '' ) {
			var gen = getRandomName();
			Log.warn("No name for asset pack provided. Generated name: " + gen );
			_packMap.set( gen, pack );	
		} else {
			_packMap.set( name, pack );
		}		
	}
	
	public static function packsReady( names:Array<String> )
	{
		for(i in names) {
			if(_packMap[i] == null) {
				return false;
			}					
		}
		return true;		
	}

	static function loadPack( folder:String, ?onSuccess:AssetPack->Void, ?onProgress:Float->Void ):Promise<AssetPack>
	{
		var ldr = new AssetPackLoader();
		
		for ( i in AssetPackLoader.localPacks )
			if ( i.pack == folder ) {
				ldr.add( i.name, i.path, i.bytes, i.format, i.extra );
			}
		
		var promise = ldr.start( onSuccess, onProgress );

		return promise;		
	}

	public static function addToQueue(packName:String, prioritize:Bool = false):LoadingTaskHandle 
	{
		if ( _loading != null && _loading.pack.toLowerCase() == packName.toLowerCase() ) {
			return _loading.handle;
		}
			
		if(_queue != null ) {
			for (i in _queue) {
				if (i.pack.toLowerCase() == packName.toLowerCase()) return i.handle;
			}
		}
			
		var handle = {
			onProgress: new SingleSignal(),
			onComplete: new SingleSignal()
		};

		var task = {
			handle: handle,
			pack: packName
		};

		if(_queue == null) _queue = [];

		if(prioritize)
			_queue.unshift(task)
		else	
			_queue.push(task);
		
		processQueue();

		return handle;
	}

	public static function prioritize(packName:String) 
	{
		// TODO Implement
		for (i in 0..._queue.length) {
			if (_queue[i].pack.toLowerCase() == packName.toLowerCase()) break;
		}
		
		var t = _queue[i];
		_queue.splice(i, 1);
		_queue.unshift(t);
		
		return Assets;
	}

	public static function callWhenPacksReady(packNames:Array<String>, callback:Void->Void, shouldAddToQueue:Bool = false, prioritize:Bool = false)
	{
		if(packsReady(packNames)) {
			callback();
		} else {
			if( _notifyTasks == null ) _notifyTasks = [];
			_notifyTasks.push({
				packs: packNames,
				callback: callback
			});

			if( shouldAddToQueue ) {
				for(i in packNames) addToQueue(i, prioritize);
			}
		}
		return Assets;

	}

	static function processQueue() 
	{
		if(_loading != null) return;
		if(_queue.length > 0) {
			_loading = _queue.shift();
			loadPack(_loading.pack, onPackLoad, onPackProgress);
		}
	}

	static function onPackProgress(progress:Float) 
	{
		_loading.handle.onProgress.emit(progress);
	}

	static function onPackLoad(pack:AssetPack) 
	{	
		registerPack(pack, _loading.pack);
		_loading.handle.onProgress.emit(1);
		_loading.handle.onComplete.emit(pack);		
		_loading = null;		

		if(_notifyTasks != null) {
			var i = _notifyTasks.length-1;
			while(i>=0) {
				var task = _notifyTasks[i];
				if(packsReady(task.packs)){
					task.callback();
					_notifyTasks.splice(i, 1);
				}
				i--;
			}
		}

		processQueue();
	}

	static function getRandomName():String
	{
		var e = 'abcdefgh0123456789';
		var r = '';
		while ( r.length < 30 ) r += e.charAt( Math.floor( Math.random() * e.length ) );
		return r;
	}
	
	public static function getFile(name:String, ?fromPack:String):File
	{
		if ( _packMap == null ) throw 'No asset packs';

		if(fromPack != null) {
			Assert.that( getPack(fromPack) != null );
			return getPack(fromPack).getFile(name);
		}

		for ( i in _packMap )
		{
			var ret = i.getFile( name, false );
			if ( ret != null) return ret;
		}
		
		throw 'No file $name found';
		return null;	
	}

	public static function getAtlas(name:String, ?fromPack:String):Atlas
	{
		if ( _packMap == null ) throw 'No asset packs';

		if(fromPack != null) {
			Assert.that( getPack(fromPack) != null );
			return getPack(fromPack).getAtlas(name);
		}

		for ( i in _packMap )
		{
			var ret = i.getAtlas( name, false );
			if ( ret != null) return ret;
		}
		
		throw 'No atlas $name found';
		return null;	
	}

	public static function getObject3D(name:String, ?fromPack:String):Object3D
	{
		if ( _packMap == null ) throw 'No asset packs';

		if(fromPack != null) {
			Assert.that( getPack(fromPack) != null );
			return getPack(fromPack).getObject3D(name);
		}

		for ( i in _packMap )
		{
			var ret = i.getObject3D( name, false );
			if ( ret != null) return ret;
		}
		
		throw 'No getObject3D $name found';
		return null;	
	}

	public static function getTexDef(name:String, ?fromPack:String, lookInAtlases:Bool = true):TexDef
	{
		if ( _packMap == null ) throw 'No asset packs';

		if(fromPack != null) {
			Assert.that( getPack(fromPack) != null );
			return getPack(fromPack).getTexDef(name, true, lookInAtlases);
		}

		for ( i in _packMap )
		{
			var ret = i.getTexDef( name, false, lookInAtlases );
			if ( ret != null ) return ret;
		}
		
		throw 'No texDef $name found';
		return null;	
	}

	public static function getPack(name:String):AssetPack
	{
		Assert.that(_packMap.exists(name), 'Pack $name doesnt exist');
		return _packMap[name];
	}
	
}