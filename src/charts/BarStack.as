package charts {
	import charts.series.Element;
	import charts.series.bars.StackCollection;
	import string.Utils;
	import com.serialization.json.JSON;
	import flash.geom.Point;
	
	
	public class BarStack extends BarBase {
		
		public function BarStack( json:Object, num:Number, group:Number ) {
	
			// don't let the parent do anything, we just want to
			// use some of the more useful methods
			super( { }, 0);
			this.key_on_click = json['key-on-click'];
			this.visibilityID = json['id'];
			
			// now do all the setup
			var root:Properties = new Properties( {
				values:				[],
				keys:				[],
				colours:			['#FF0000','#00FF00'],	// <-- ugly default colours
				text:				'',		// <-- default not display a key
				'font-size':		12,
				tip:				'#x_label# : #val#<br>Total: #total#',
				alpha:				0.6,
				'on-click':			false,
				'axis':				'left'
			} );
			
			object_helper.merge_2( json, style );
			
//			this.props = new Properties(json, root);
//			
//			this.on_show = this.get_on_show(json['on-show']);
			//
			// bars are grouped, so 3 bar sets on one chart
			// will arrange them selves next to each other
			// at each value of X, this.group tell the bar
			// where it is in that grouping
			//
			this.group = group;
		
			this.values = json.values;

			for each( var o:Object in this.style.keys ) {
				if ( o.colour ) {
					o.colour = string.Utils.get_colour( o.colour );
				}
				if ( o.text == null ) {
					o.text = "";
				}
			}

			this.add_values();
		}
		
		//
		// return an array of key info objects:
		//
		public override function get_keys(): Object {
			
			var tmp:Array = [];
			
			for each( var o:Object in this.style.keys ) {
				// some lines may not have a key
				if ( o.text && !isNaN(o.colour) ) {
					if ( o['font-size'] == null) {
						o['font-size'] = this.style['font-size'];
					}
					o['on-click'] = this.key_on_click;
					o.series = this;
					o['visibility-id'] = this.visibilityID;
					tmp.push( o );
				}
			}
			
			return tmp;
		}
		
		//
		// value is an array (a stack) of bar stacks
		//
		protected override function get_element( index:Number, value:Object ): Element {
			
			//
			// this is the style for a stack:
			//
			var default_style:Object = {
				tip:		this.style.tip,
				values:		value,
				colours:	this.style.colours,
				alpha:		this.style.alpha,
				'on-click': this.style['on-click'],
				'on-click-text': this.style['on-click-text'],
				'on-click-window': this.style['on-click-window']
			};
			
			return new StackCollection( index, default_style, this.group, this.style.keys );
		}
		
		
		//
		// get all the Elements at this X position
		//
		protected override function get_all_at_this_x_pos( x:Number ):Array {
			
			var tmp:Array = new Array();
			var p:flash.geom.Point;
			var e:StackCollection;
			
			for ( var i:Number = 0; i < this.numChildren; i++ ) {
			
				// some of the children will will mask
				// Sprites, so filter those out:
				//
				if( this.getChildAt(i) is Element ) {
		
					e = this.getChildAt(i) as StackCollection;
				
					p = e.get_mid_point();
					if ( p.x == x ) {
						var children:Array = e.get_children();
						for each( var child:Element in children )
							tmp.push( child );
					}
				}
			}
			
			return tmp;
		}
	}
}