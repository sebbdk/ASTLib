package dk.sebb.tiled.mobs
{
	import flash.display.Shape;
	
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	
	public class NPC extends Mob
	{
		public function NPC(type:BodyType=null)
		{
			super(type);
			draw();
			
			body = new Body(BodyType.DYNAMIC, new Vec2(0, 0));
			poly = new Polygon(Polygon.box(16, 16));
			body.shapes.add(poly);
			body.allowRotation = false;
		}
		
		public function draw():void {
			trace("draw!");
			animator = new Humti();
			animator.scaleX = 2;
			animator.scaleY = 2;
			
			animator.x = (-animator.width/2);
			animator.y = (-animator.height) + 8;
			
			addChild(animator);
		}
	}
}