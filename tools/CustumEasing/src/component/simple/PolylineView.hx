package component.simple;
import api.react.React;
import api.react.ReactComponent;
import api.react.ReactComponent.ReactComponentOfProps;
import component.basic.NumberInputView;
import component.complex.ComplexEasingId;
import core.GlobalContext;
import tweenxcore.expr.PolylineKind;
import tweenxcore.geom.Point;

class PolylineView extends ReactComponentOfProps<PolylineProps>
{
	public function new(props:PolylineProps) 
	{
		super(props);
	}
	
	override public function render():ReactComponent
	{
		return React.createElement(
			"div",
			{
				className: "param-group"
			}, 
			[
				for (i in 0...props.controls.length)
				{
					NumberInputView.createElement(
						{
							name: Std.string(i),
							value: props.controls[i],
							id: props.id.numberInputId(i),
							context: props.context
						}
					);
				}
			]
		);
	}
}

typedef PolylineProps = 
{
	polyline: PolylineKind,
	controls: Array<Float>,
	id: ComplexEasingId,
	context: GlobalContext
}
