//
//  MyTabBarController.h
//  ALCommon
//
//  Created by 文彬 on 13-1-24.
//
//

#import <UIKit/UIKit.h>


@interface MyTabBarController : UITabBarController
{
    
}
@property (nonatomic, retain) NSMutableArray *buttons;
@property (nonatomic, retain) UIView *tabbarview;

-(void)setImages:(NSArray*)imgs;
- (void)selectTabAtIndex:(NSInteger)index;
- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated;
@end
