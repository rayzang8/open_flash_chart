package charts.series.bars {
	
	import charts.series.bars.Base;
	import flash.display.Sprite;
	import flash.geom.Point;
	import string.DateUtils;
	
	public class HStack extends Base {
		protected var total:Number;
		protected var key:String;

		protected var right:Number;
		protected var left:Number;
		protected var mouseOutAlpha:Number
		
		public function HStack( index:Number, style:Object, group:Number ) {
			// we are not passed a string value, the value
			// is set by the parent collection later
			// HACK:
			var p:Properties = new Properties(style);
			super(index, p, group);

			this.total =  style.total;
			this.key = style.text;

			
			this.left = style.left;
			this.right = style.right;
			this.barWidthPercentage = (style.barwidth != null) ? style.barwidth : 0.8;

			if (style.alpha) this.alpha = style.alpha;
			this.mouseOutAlpha = this.alpha;
			
			if ( style['on-click'] ) {
				this.set_on_click( style['on-click'] );
			}
			this.on_click_text = style['on-click-text'];
			if( style['on-click-window'] )
				this.on_click_window = style['on-click-window'];
			
			this.tooltip = this.replace_magic_values( style.tip );
			this.on_click_text = this.replace_magic_values(this.on_click_text);
			
		}

		public function get_colour():Number {
			return this.colour;
		}
		
		public function get_key():String {
			return this.key;
		}
		
		public function set_key(text:String):void {
			this.key = text;
		}
		
		protected override function replace_magic_values( t:String ): String {
			if (t != null) {
				t = t.replace('#left#', NumberUtils.formatNumber( this.left ));
				t = t.replace('#right#', NumberUtils.formatNumber( this.right ));
				t = t.replace('#val#', NumberUtils.formatNumber( this.right - this.left ));

				var regex:RegExp = /#total#/g;
				t = t.replace(regex, NumberUtils.formatNumber( this.total ));
				regex = /#totalgmdate/g;
				t = t.replace(regex, '#gmdate');
				t = DateUtils.replace_magic_values(t, this.total);

				// The key may get set later so do not lose the 
				// #key# magic value if not defined yet
				if ((this.key != null) && (this.key != "")) {
					regex = /#key#/g;
					t = t.replace('#key#', this.key);
				}
			}
				return t;
		}
		
		public function update_tip_with_key( ): void {
			var regex:RegExp = /#key#/g;
			if (this.tooltip is String)
				this.tooltip = this.tooltip.replace('#key#', this.key);
			if (this.on_click_text is String) {
				this.on_click_text = this.on_click_text.replace('#key#', this.key);
			}
		}

		//
		// BUG: we assume that all are positive numbers:
		//
		public override function resize( sc:ScreenCoordsBase ):void {
			this.graphics.clear();
			
			// is it OK to cast up like this?
			var sc2:ScreenCoords = sc as ScreenCoords;
			var tmp:Object = sc2.get_horiz_bar_coords( this.index, this.group, this.barWidthPercentage);
			
			var left:Number  = sc.get_x_from_val( this.left );
			var right:Number = sc.get_x_from_val( this.right );
			var width:Number = right - left;
			
			this.graphics.clear();
			this.graphics.beginFill( this.colour, 1.0 );
			this.graphics.drawRect( 0, 0, width, tmp.width );
			this.graphics.endFill();
			
			this.x = left;
			this.y = tmp.y;
			this.tip_pos = new flash.geom.Point( this.x + (tmp.width / 2), this.y );
			
		}
	}
}