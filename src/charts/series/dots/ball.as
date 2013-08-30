package charts.series.dots {
	
	import charts.series.dots.PointDotBase;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import string.Utils;
	
	public class ball extends PointDotBase {
		
		public function ball( index:Number, style:Properties ) {
			
			super( index, style );
			
			var colour:Number = string.Utils.get_colour( style.get('colour') );
			
			this.graphics.lineStyle( 0, 0, 0 );
			this.graphics.beginFill( colour, 1 );
			this.graphics.drawCircle( 0, 0, style.get('dot-size') );
			this.graphics.endFill();

					
			var s:Sprite = new Sprite();
			s.graphics.lineStyle( 0, 0, 0 );
			s.graphics.beginFill( 0, 1 );
//			trace(style.get('dot-size')+style.get('halo-size'));
//			s.graphics.drawCircle( 0, 0, style.get('dot-size')+style.get('halo-size') );
//			s.graphics.drawCircle( 0, 0, 4 );
			s.blendMode = BlendMode.ERASE;
			
			this.line_mask = s;
			
			this.attach_events();
		}
	}
}

