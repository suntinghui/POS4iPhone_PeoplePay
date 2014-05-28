//
//  PaintMaskViewController.h
//  PaintPenAPI
//
// 
//

#import <UIKit/UIKit.h>


@interface PaintMaskView : UIView {
	
	UIImageView *drawImage;
	CGPoint lastPoint;
	
	float redGgb;
	float greenRgb;
	float blueRgb;
	float paintLineWidth;   //画笔大小
	BOOL  erase;            // YES为橡皮擦模式  NO 为绘画模式
}

@property (nonatomic, retain) UIImageView* drawImage;
@property (nonatomic, assign) float redGgb;
@property (nonatomic, assign) float greenRgb;
@property (nonatomic, assign) float blueRgb;
@property (nonatomic, assign) float paintLineWidth;
@property (nonatomic, assign) BOOL  erase;

-(void) setColorWithRed:(float)rgbOfRed Green:(float)rgbOfGreen Blue:(float) rgbOfBlue;
-(void) setLineWidth:(float) lineWidth;
-(void) clearPaintMask;
-(void) makeEraseEnable:(BOOL)type;
-(void) makePaintMaskViewEnable:(BOOL) type;


@end
