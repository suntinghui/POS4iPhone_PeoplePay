//
//  MyTabBarController.m
//  ALCommon
//
//  Created by 文彬 on 13-1-24.
//
//

#import "MyTabBarController.h"

@interface MyTabBarController ()

@end

@implementation MyTabBarController
@synthesize tabbarview;
@synthesize buttons;


//修复重新添加viewcontrollers时产生点击错误
-(void)updateTabView
{
    
    for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
            if ([view.subviews containsObject:self.tabbarview]) {
                
                 [view bringSubviewToFront:self.tabbarview];
            }
			break;
		}
 
	}

}
-(void)setImages:(NSArray*)imgs
{
    self.tabbarview = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
    self.tabbarview.backgroundColor = [UIColor blackColor];

   
    for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
			[view addSubview:self.tabbarview];
            [view bringSubviewToFront:self.tabbarview];
            
			break;
		}
      

	}

    self.buttons = [NSMutableArray arrayWithCapacity:[imgs count]];
    
    CGFloat width = 320.0f / [imgs count];
    for (int i = 0; i < [imgs count]; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.showsTouchWhenHighlighted = YES;
        btn.tag = i;
        btn.frame = CGRectMake(width * i, 0, width+1, self.tabbarview.frame.size.height);
        [btn setImage:[[imgs objectAtIndex:i] objectForKey:@"Default"] forState:UIControlStateNormal];
        [btn setImage:[[imgs objectAtIndex:i] objectForKey:@"Highlighted"] forState:UIControlStateHighlighted];
        [btn setImage:[[imgs objectAtIndex:i] objectForKey:@"Seleted"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttons addObject:btn];
        [self.tabbarview addSubview:btn];
    }
 [self selectTabAtIndex:0];
    
    
}

- (void)selectTabAtIndex:(NSInteger)index
{
	for (int i = 0; i < [self.buttons count]; i++)
	{
		UIButton *b = [self.buttons objectAtIndex:i];
		b.selected = NO;
		b.userInteractionEnabled = YES;
	}
	UIButton *btn = [self.buttons objectAtIndex:index];
	btn.selected = YES;
	btn.userInteractionEnabled = NO;
}
-(void) touchButton:(id)sender {

   // if ([self.delegate respondsToSelector:@selector(willDisappea)]) {
        
//        [self.delegate willDisappear:self Index:[NSNumber numberWithInt:self.selectedIndex]];
    
   // }
    
    UIButton *btn = sender;
    [self selectTabAtIndex:btn.tag];
    [self tabWasSelected:btn.tag];
  
}

-(void)tabWasSelected:(NSInteger)index {
    
    self.selectedIndex = index;
    
}

- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated
{
 
}
@end
