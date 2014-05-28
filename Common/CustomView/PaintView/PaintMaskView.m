    //
//  PaintMaskViewController.m
//  PaintPenAPI
//
//  提供类似画板的视图   
//  
//

#import "PaintMaskView.h"

@implementation PaintMaskView

@synthesize drawImage, redGgb, greenRgb, blueRgb, paintLineWidth, erase;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		
		self.drawImage = [[UIImageView alloc] initWithImage:nil];
		drawImage.frame = self.frame;
		[self addSubview:self.drawImage];
		
		self.redGgb = 255;
		self.greenRgb = 0;
		self.blueRgb = 0;
		self.paintLineWidth = 12;
		self.erase = NO;
		
    }
    return self;
}



#pragma mark -
#pragma mark 基本设置函数

//设置绘画的颜色
-(void) setColorWithRed:(float)rgbOfRed Green:(float)rgbOfGreen Blue:(float) rgbOfBlue;
{
	self.redGgb = rgbOfRed;
	self.greenRgb = rgbOfGreen;
	self.blueRgb = rgbOfBlue;
	
}

//设置线条的大小
-(void) setLineWidth:(float) lineWidth
{
	self.paintLineWidth = lineWidth;
	
}

//清除画布内容
-(void) clearPaintMask
{
	
	self.drawImage.image = nil;
	
}

//设置橡皮擦是否激活
-(void) makeEraseEnable:(BOOL)type
{
	
	self.erase = type;
	
}

// 设置画布是否激活 
-(void) makePaintMaskViewEnable:(BOOL) type
{
	
	self.userInteractionEnabled = type;
}

#pragma mark -
#pragma mark 触摸事件处理函数

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

	UITouch *touch = [touches anyObject];
	lastPoint = [touch locationInView:self];
		
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];	
	CGPoint currentPoint = [touch locationInView:self];

	
	if (erase) //橡皮擦模式
	{

	    UIGraphicsBeginImageContext(self.drawImage.frame.size);
	    [drawImage.image drawInRect:drawImage.bounds];
		CGRect eraseRect = CGRectMake(currentPoint.x-5, currentPoint.y-5, 10, 10);
		CGContextClearRect (UIGraphicsGetCurrentContext(), eraseRect);//CGRectMake(currentPoint.x, currentPoint.y, 30, 30)); 
		drawImage.image = UIGraphicsGetImageFromCurrentImageContext(); 
		UIGraphicsEndImageContext();		
		
	}
  else      //绘画模式
	{
		
	  UIGraphicsBeginImageContext(self.frame.size);
	  [drawImage.image drawInRect:CGRectMake(0, 0, drawImage.frame.size.width, drawImage.frame.size.height)];
	   CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound); 
	  CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.paintLineWidth);
	  CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.redGgb, self.greenRgb, self.blueRgb, 1.0);
	  CGContextBeginPath(UIGraphicsGetCurrentContext());
	  CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
	  CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
	  CGContextStrokePath(UIGraphicsGetCurrentContext());
	  drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
	   UIGraphicsEndImageContext();
	
	  lastPoint = currentPoint;
	
		
	}
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

	UITouch *touch = [touches anyObject];
	CGPoint currentPoint = [touch locationInView:self];
	
	if (erase)  //橡皮擦模式
	{
		
	    UIGraphicsBeginImageContext(self.drawImage.frame.size);
	    [drawImage.image drawInRect:drawImage.bounds];
		CGRect eraseRect = CGRectMake(currentPoint.x-5, currentPoint.y-5, 10, 10);
		CGContextClearRect (UIGraphicsGetCurrentContext(), eraseRect);//CGRectMake(currentPoint.x, currentPoint.y, 30, 30)); 
		drawImage.image = UIGraphicsGetImageFromCurrentImageContext(); 
		UIGraphicsEndImageContext();		
		
	}
	else     //绘画模式
	{

	
		UIGraphicsBeginImageContext(self.frame.size);
		[drawImage.image drawInRect:CGRectMake(0, 0, drawImage.frame.size.width, drawImage.frame.size.height)]; 
		CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound); 
		CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.paintLineWidth);
		CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.redGgb, self.greenRgb, self.blueRgb, 1.0);
		CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
		CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
		CGContextStrokePath(UIGraphicsGetCurrentContext());
		CGContextFlush(UIGraphicsGetCurrentContext());
		drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	   
	}
	
}

@end
