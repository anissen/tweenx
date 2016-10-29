package component.basic;
import core.animation.Animation;
import core.animation.AnimationManager;
import core.focus.FocusManager;
import js.html.CanvasElement;
import tweenxcore.expr.ComplexEasingKind;
import tweenxcore.expr.ComplexEasingKindTools;

class PreviewAnimation implements Animation
{
	public static var WIDTH = 600;
	public static var HEIGHT = 5;
	public static var MARKER_WIDTH = 40;
	public static var MARGIN = 100;
	public static var TOTAL_FRAME = 60;
	
	private var canvas:CanvasElement;
	private var currentFrame:Int;
	private var totalFrame:Float;
	private var func:Float->Float;
	private var manager:AnimationManager;
	
	public function new(manager:AnimationManager, canvas:CanvasElement, easing:ComplexEasingKind) 
	{
		this.manager = manager;
		this.func = ComplexEasingKindTools.toFunction(easing);
		this.canvas = canvas;
		totalFrame = TOTAL_FRAME * manager.time;
		currentFrame = 0;
	}
	
	public function onFrame():Void
	{
		currentFrame++;
		init(canvas);
		
		var ctx = canvas.getContext2d();
		
		var left = MARGIN;
		var right = WIDTH - MARGIN - MARKER_WIDTH;
		
		ctx.fillStyle = "#ff64b1";
		
		var x = func(currentFrame / totalFrame).lerp(left, right);
		ctx.fillRect(x, 0, MARKER_WIDTH, HEIGHT);
	}
	
	public function isDead():Bool
	{
		return currentFrame >= totalFrame;
	}
	
	public static function init(canvas:CanvasElement):Void 
	{
		var ctx = canvas.getContext2d();
		ctx.clearRect(0, 0, WIDTH, HEIGHT);
		var left = MARGIN;
		var right = WIDTH - MARGIN - MARKER_WIDTH;
		
		ctx.fillStyle = "#F0F0F0";
		ctx.fillRect(0, 0, left - 2, HEIGHT);
		ctx.fillRect(WIDTH - MARGIN + 1, 0, MARGIN - 2, HEIGHT);
		
		ctx.fillStyle = "#E6E6E6";
		ctx.fillRect(left, 0, WIDTH - MARGIN * 2, HEIGHT);
	}
}