package dk.sebb.tiled
{
	import avmplus.getQualifiedClassName;
	
	import dk.sebb.tiled.layers.ImageLayer;
	import dk.sebb.tiled.layers.Layer;
	import dk.sebb.tiled.layers.ObjectLayer;
	import dk.sebb.tiled.layers.TMXObject;
	import dk.sebb.tiled.mobs.Mob;
	import dk.sebb.tiled.mobs.NPC;
	import dk.sebb.tiled.mobs.ObjMob;
	import dk.sebb.tiled.mobs.Player;
	import dk.sebb.tiled.mobs.TileMob;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import luaAlchemy.LuaAlchemy;
	
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.space.Space;
	import nape.util.ShapeDebug;
	
	public class Level extends MovieClip
	{
		public var debug:ShapeDebug;
		
		public static var data:LevelData;
		public static var space:Space = new Space(new Vec2(0, 0));
		public static var lua:LuaInterface = new LuaInterface();
		public static var infoBox:InfoBox = new InfoBox();
		public static var player:Player;
		
		public static var settings:Object = {
			debug:true,
			pause:false
		};
		
		public function Level() {
			data = new LevelData("../levels/demo_001_basic/");
			data.addEventListener(Event.COMPLETE, start);
			data.load();
			
			scaleX = 2;
			scaleY = 2;
		}
		
		public function start(evt:Event):void {
			//add layers!
			for each(var layer:Layer in data.tmxLoader.layers) {
				//layer.displayObject.alpha = 0.3; //HERE!
				addChild(layer.displayObject);
			}
			
			//setup player
			player = new Player();
			player.body.position = data.spawns[0];
			data.mobs.push(player);
			addMob(player);
			
			//setup mobs
			for each(var mob:Mob in data.mobs) {
				addMob(mob);
			}
			
			//setup info box
			parent.addChild(infoBox);
			
			//debug?
			if(settings.debug) {
				debug = new ShapeDebug(512, 512); //width/height not really important
				addChild(debug.display);
			}
			
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			//start the game!
			addEventListener(Event.ENTER_FRAME, run);
		}
		
		public function onKeyUp(evt:KeyboardEvent):void {
			if(evt.keyCode === Keyboard.SPACE) {
				for each(var mob:Mob in data.mobs) {
					if(mob is NPC && NPC(mob).playerInProximity && NPC(mob).object.onActivate) {
						Level.lua.doString(NPC(mob).object.onActivate);
						return;
					}
				}
				
				Level.unPause();
				infoBox.visible = false;
				infoBox.currentConvo = "";
			}
		}
		
		public static function pause():void {
			settings.pause = true;
			
			for each(var mob:Mob in data.mobs) {
				mob.stop();
				if(mob.animator) {
					mob.animator.stop();
				}
			}
		}
		
		public static function unPause():void {
			settings.pause = false;
		}
		
		public function run(evt:Event = null):void {
			if(settings.pause) {
				return;
			}

			space.step((1/30), 10, 10);
			
			for each(var mob:Mob in data.mobs) {
				mob.update();
			}
			
			if(debug) {
				debug.clear();
				debug.draw(space);
			}
			
			//move "camera" onto player
			x = -(player.body.position.x * scaleX) + stage.stageWidth/2
			y = -(player.body.position.y * scaleY) + stage.stageHeight/2
				
			//update parallax
			for each(var layer:Layer in data.parallaxLayers) {
				var playerRatioX:Number = (player.body.position.x * scaleX) / (layer.displayObject.width * scaleX);
				layer.displayObject.x = ((this.width/2) * playerRatioX) * layer.offsetX;
				
				var playerRatioY:Number = (player.body.position.y * scaleY) / (layer.displayObject.height * scaleY);
				layer.displayObject.y = ((this.height/2) * playerRatioY) * layer.offsetY;
			}
		}
		
		public function addMob(mob:Mob):void {
			mob.body.space = space;
			addChild(mob);
		}
	}
}