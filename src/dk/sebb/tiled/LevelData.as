package dk.sebb.tiled
{
	import dk.sebb.tiled.layers.ImageLayer;
	import dk.sebb.tiled.layers.Layer;
	import dk.sebb.tiled.layers.ObjectLayer;
	import dk.sebb.tiled.layers.TMXObject;
	import dk.sebb.tiled.mobs.Mob;
	import dk.sebb.tiled.mobs.NPC;
	import dk.sebb.tiled.mobs.ObjMob;
	import dk.sebb.tiled.mobs.TileMob;
	import dk.sebb.util.JSONLoader;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import nape.geom.Vec2;
	import nape.phys.BodyType;
	import nape.space.Space;

	public dynamic class LevelData extends EventDispatcher
	{
		public var tmxLoader:TMXLoader;
		public var dataLoader:JSONLoader;
		
		public var parallaxLayers:Array = [];
		public var spawns:Array = [];
		public var mobs:Array = [];
		
		public var basePath:String;
		
		public function LevelData(basePath:String  = "../levels/demo_001_basic/") {
			this.basePath = basePath;
			
			tmxLoader = new TMXLoader(basePath + "level.tmx");
			tmxLoader.addEventListener(Event.COMPLETE, onTMXLoaded);
			
		}
		
		public function load():void {
			tmxLoader.load();
		}
		
		public function onTMXLoaded(evt:Event):void {
			//get object layers
			for each(var layer:Layer in tmxLoader.layers) {
				if(layer.parallax) {
					parallaxLayers.push(layer);
				}
				
				switch(getQualifiedClassName(layer)) {
					case 'dk.sebb.tiled.layers::ObjectLayer':
						setupObjectLayer(layer as ObjectLayer);
						break;
					case 'dk.sebb.tiled.layers::ImageLayer':
						setupImageLayer(layer as ImageLayer);
						break;
					case 'dk.sebb.tiled.layers::Layer':
						setupLayer(layer);
						break;
				}
			}
			
			if(tmxLoader.data) {
				dataLoader = new JSONLoader(basePath + tmxLoader.data);
				dataLoader.addEventListener(Event.COMPLETE, onDataLoaded);
				dataLoader.load();
			} else {
				dispatchEvent(evt);
			}
		}
		
		public function onDataLoaded(evt:Event):void {
			for(var attr:String in dataLoader.data) {
				this[attr] = dataLoader.data[attr];
			}
			
			dispatchEvent(evt);
		}
		
		/**
		 * Loop's through the obejct layers to set up spawn points, detectors etc
		 * */
		public function setupObjectLayer(layer:ObjectLayer):void {
			for each(var object:TMXObject in layer.objects) {
				if(object.type) {
					switch(object.type) {
						case 'playerspawn':
							spawns.push(new Vec2(object.x, object.y));
							break;
						case 'detector':
							var objDet:ObjMob = new ObjMob(object, true);
							objDet.body.position.x = object.x + (object.width/2);
							objDet.body.position.y = object.y + (object.height/2);
							objDet.body.space = Level.space;
							mobs.push(objDet);
							break;
						case 'npc':
							trace("NPC found! now create it!");
							var npc:NPC = new NPC();
							npc.body.position.x = object.x + (object.width/2);
							npc.body.position.y = object.y + (object.height/2);
							npc.body.space = Level.space;
							mobs.push(npc);
							break;
						default:
							trace("unknow  object type (" + object.type + ") found in level!");
							break;
					}
				}
			}
		}
		
		/**
		 * Loops through the image layers to set them up with parallax etc
		 * */
		public function setupImageLayer(layer:ImageLayer):void {}
		
		/**
		 * handles collision layers or other tiles with settings on them
		 * */
		public function setupLayer(layer:Layer):void {
			if(layer.display === "false") {
				layer.displayObject.visible = false;
			}
			
			if(layer.functional && layer.functional === "true") {
				for (var spriteForX:int = 0; spriteForX < tmxLoader.mapWidth; spriteForX++) {
					for (var spriteForY:int = 0; spriteForY < tmxLoader.mapHeight; spriteForY++) {
						var tileGid:int = int(layer.map[spriteForX][spriteForY]);
						if(TileSet.funcTiles[tileGid]) {
							var tileMob:Mob = new TileMob(BodyType.STATIC);
							tileMob.body.position.x = 32 * spriteForX + 16;
							tileMob.body.position.y = 32 * spriteForY + 16;
							
							mobs.push(tileMob);
							layer.displayObject.addChild(tileMob);
						}
					}
				}
			}
		}
		
	}
}