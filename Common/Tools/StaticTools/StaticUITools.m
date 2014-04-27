//
//  StaticUITools.m
//  Mlife
//
//  Created by xuliang on 12-12-27.
//
/*----------------------------------------------------------------
 // Copyright (C) 2002 深圳四方精创资讯股份有限公司
 // 版权所有。
 //
 // 文件名： StaticUITools.m
 // 文件功能描述：公共方法类
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/


#import "StaticUITools.h"
#import <QuartzCore/QuartzCore.h>
#import "StaticDataTools.h"


@implementation StaticTools(StaticUITools)
/*
 带tag的alert实现aLert代理的时候
 */
+ (void)showAlertWithTag:(int)tag
                   title:(NSString *)titleString
                 message:(NSString *)messageString
               AlertType:(CAlertStyle)AlertType
               SuperView:(id<UIAlertViewDelegate>)SuperViewController
{
//    UIWindow *mainWindow= [[UIApplication sharedApplication] keyWindow];
//    for(UIView *view in mainWindow.subviews){
//        if ([view isKindOfClass:[UIAlertView class]])
//        {
//            [view removeFromSuperview];
//        }
//    }
    
    UIAlertView *alert;
    
    switch (AlertType)
    {
        case CAlertTypeDefault:
            
            alert=[[UIAlertView alloc] initWithTitle:titleString message:messageString delegate:SuperViewController cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            if (SuperViewController)
            {
                alert.delegate=SuperViewController;
            }
            alert.tag = tag;
            [alert show];
            
            break;
        case CAlertTypeCacel:

            alert=[[UIAlertView alloc] initWithTitle:titleString message:messageString delegate:SuperViewController cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            if (SuperViewController)
            {
                alert.delegate=SuperViewController;
            }
            alert.tag = tag;
            [alert show];
            
            break;
        case CAlertTypeUpDate:
            
            alert=[[UIAlertView alloc] initWithTitle:titleString message:messageString delegate:SuperViewController cancelButtonTitle:@"暂不更新" otherButtonTitles:@"更新", nil];
            if (SuperViewController)
            {
                alert.delegate=SuperViewController;
            }
            alert.tag = tag;
            [alert show];
            
            break;
        case CAlertTypeRelogin:
            
            alert=[[UIAlertView alloc] initWithTitle:titleString message:messageString delegate:SuperViewController cancelButtonTitle:@"取消" otherButtonTitles:@"重新登录", nil];
            if (SuperViewController)
            {
                alert.delegate=SuperViewController;
            }
            alert.tag = tag;
            [alert show];
            break;
        case CalertTypeRedo:
            
            alert=[[UIAlertView alloc] initWithTitle:titleString message:messageString delegate:SuperViewController cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
            if (SuperViewController)
            {
                alert.delegate=SuperViewController;
            }
            alert.tag = tag;
            [alert show];
            break;
        default:
            break;
    }
}


/*
 @abstract 设置导航栏背景颜色
 */
+ (void)navigationBarSetBackgroundImage:(UINavigationBar *)navigationBar{
    if ([navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
		[navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_viewnav"] forBarMetrics:UIBarMetricsDefault];
        //navigationBar.tintColor=[UIColor redColor];
        
        //[UIColor colorWithRed:139.0/255 green:178.0/255 blue:38.0/255 alpha:1];
	}
}

/*
 @abstract 给View添加navigation
 */
+ (UINavigationController *)pushNavController:(UIViewController *)viewController
{
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self navigationBarSetBackgroundImage:navController.navigationBar];
    return navController;
}

/*
 @abstract 淡入淡出效果
 */
+ (void) FadeOut:(UIView *)view appear:(BOOL)appear
		   viewX:(float)viewX
		   viewY:(float)viewY
	   viewWidth:(float)viewWidth
	  viewHeigth:(float)viewHeigth
{
    view.alpha = appear?0:1;
    view.frame = appear?CGRectMake(viewX + viewWidth / 2, viewY+viewHeigth / 2, 0, 0):CGRectMake(viewX, viewY, viewWidth, viewHeigth);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationRepeatAutoreverses:NO];
	view.alpha = appear?1:0;
    view.frame = !appear?CGRectMake(viewX + viewWidth / 2, viewY + viewHeigth / 2, 0, 0):CGRectMake(viewX, viewY, viewWidth, viewHeigth);
	[UIView commitAnimations];
}

/*
 给图片加边框
 */
+ (void)addFrame:(UIView *)sender{
    sender.layer.masksToBounds=YES;
	sender.layer.cornerRadius=0.8;
	sender.layer.borderWidth=0.8;
    sender.layer.borderColor=[[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1]CGColor];
}

/*
 给图片加圆角
 */
+ (void)createRoundedRectImage:(UIImageView *)imageView{
    imageView.layer.masksToBounds = YES;
	imageView.layer.cornerRadius = 5.0;
}

/*
 *返回label的高度
 */
+ (float)getLabelHeight:(NSString *)textString
            defautWidth:(float)defautWidth
           defautHeight:(float)defautHeight
               fontSize:(int)fontSize
{
    CGSize size = CGSizeMake(defautWidth,defautHeight);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize = [textString sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    return labelsize.height;
}

/*
 *返回label的宽度
 */
+ (float)getLabelWidth:(NSString *)textString
           defautWidth:(float)defautWidth
          defautHeight:(float)defautHeight
              fontSize:(int)fontSize
{
    //textString = [textString stringByReplacingOccurrencesOfString:@"0" withString:@"*"];
    CGSize size = CGSizeMake(defautWidth,defautHeight);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize = [textString sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    return labelsize.width;
}

/*
 *image拼图 由左、中、右三张图片合并成一张图片
 *返回一个拼好的image
 */
+ (UIImage *)getImageFromImage:(UIImage *)imageLeftOrTop
                  centerImage:(UIImage *)imageCenter
                   finalImage:(UIImage *)imageRightOrBottom
                     withSize:(CGSize)resultSize
{
    //m_zhanggaofeng20130712 解决图片拼接后模糊问题
//    UIGraphicsBeginImageContext(resultSize);
    UIGraphicsBeginImageContextWithOptions(resultSize, NO, 0.0);
    
    // Draw image1
    [imageLeftOrTop drawInRect:CGRectMake(0, 0, imageLeftOrTop.size.width, imageLeftOrTop.size.height)];
    
    // Draw image2
    if (resultSize.height == imageLeftOrTop.size.height)
    {
        //如果高度相等 则从左到右画图
        [imageCenter drawInRect:CGRectMake(imageLeftOrTop.size.width, 0, resultSize.width -imageLeftOrTop.size.width - imageRightOrBottom.size.width, imageCenter.size.height)];
        // Draw image3
        [imageRightOrBottom drawInRect:CGRectMake(resultSize.width-imageRightOrBottom.size.width, 0, imageRightOrBottom.size.width, imageRightOrBottom.size.height)];
    }
    else if(resultSize.width == imageLeftOrTop.size.width)
    {
        //宽度相同 则从上到下画图
        [imageCenter drawInRect:CGRectMake(0, imageLeftOrTop.size.height, imageCenter.size.width, resultSize.height - imageLeftOrTop.size.height-imageRightOrBottom.size.height)];
        // Draw image3
        [imageRightOrBottom drawInRect:CGRectMake(0, resultSize.height - imageRightOrBottom.size.height, imageRightOrBottom.size.width, imageRightOrBottom.size.height)];
    }
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
//    [resultingImage release];
}

/**
 *  image拼图 由上、中、下三张图片合并成一张图片
 *
 *  @param upImage    上面的图片
 *  @param midImage   中间的图片
 *  @param downImage  底部的图片
 *  @param resultSize 需要返回的合并后的图片的大小 注意不要小于三张图片加起来的最小size
 *
 *  @return
 */
+ (UIImage*)getImageFromUpImage:(UIImage*)upImage
                       midImage:(UIImage*)midImage
                      downImage:(UIImage*)downImage
                       withSize:(CGSize)resultSize
{
    UIGraphicsBeginImageContextWithOptions(resultSize, NO, 0.0);
    
    [upImage drawInRect:CGRectMake(0, 0,resultSize.width, upImage.size.height)];
    [midImage drawInRect:CGRectMake(0, upImage.size.height,resultSize.width, resultSize.height - upImage.size.height-downImage.size.height)];
    [downImage drawInRect:CGRectMake(0, resultSize.height - downImage.size.height,resultSize.width, downImage.size.height)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}
/*
 *屏幕旋转
 */
+ (CGAffineTransform)transformForOrientation {
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (UIInterfaceOrientationLandscapeLeft == orientation) {
		return CGAffineTransformMakeRotation(M_PI*1.5);
	} else if (UIInterfaceOrientationLandscapeRight == orientation) {
		return CGAffineTransformMakeRotation(M_PI/2);
	} else if (UIInterfaceOrientationPortraitUpsideDown == orientation) {
		return CGAffineTransformMakeRotation(-M_PI);
	} else {
		return CGAffineTransformIdentity;
	}
}



/*
 *给tableview添headerview
 */
+ (void)setheaderView:(UITableView *)tableview{
    
    UIView *headview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    [headview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_list_all.png"]]];
    UIImageView *lineImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 320, 1)];
    [lineImage setBackgroundColor:[StaticTools colorWithHexString:@"#e1e1e1"]];
    [headview addSubview:lineImage];
    [tableview setTableHeaderView:headview];

}

/**
 *  给tableview添加点击加载更多的footview
 *
 *  @param tableview
 *  @param action    点击了加载更多后调用的方法
 */
+ (void)setTableViewAddMoreFootView:(UITableView*)tableview withAction:(SEL)action
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableview.frame.size.width, 30)];
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setFrame:CGRectMake(0, 0, footView.frame.size.width, footView.frame.size.height)];
    [moreBtn setTitle:@"点击查看更多" forState:UIControlStateNormal];
    [moreBtn setTitleColor:RGBCOLOR(52, 75, 138) forState:UIControlStateNormal];
    [moreBtn addTarget:tableview.delegate action:action forControlEvents:UIControlEventTouchUpInside];
    moreBtn.tag = Action_Tag_AddMore;
    [footView addSubview:moreBtn];
    
    UIActivityIndicatorView *actView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(80, 0, 30, 30)];
    actView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    actView.tag = View_Tag_MoreActivity;
    [footView addSubview:actView];
    actView.hidden = YES;

    tableview.tableFooterView = footView;

}

/*
 *将tableview 的tablefootview设为正在加载的状态
 */
+ (void)setTableFootViewIsAdding:(UITableView*)tableView
{
    UIActivityIndicatorView *actView = (UIActivityIndicatorView*)[tableView.tableFooterView viewWithTag:View_Tag_MoreActivity];
    actView.hidden = NO;
    [actView startAnimating];
    
    UIButton *moreBtn = (UIButton*)[tableView.tableFooterView viewWithTag:Action_Tag_AddMore];
    [moreBtn setTitle:@"正在加载..." forState:UIControlStateNormal];
}

/*
 *将tableview 的tablefootview设为加载失败的状态
 */
+ (void)setTableFootViewIsLoadingFail:(UITableView*)tableView
{
    UIActivityIndicatorView *actView = (UIActivityIndicatorView*)[tableView.tableFooterView viewWithTag:View_Tag_MoreActivity];
    [actView stopAnimating];
    actView.hidden = YES;
    
    
    UIButton *moreBtn = (UIButton*)[tableView.tableFooterView viewWithTag:Action_Tag_AddMore];
    [moreBtn setTitle:@"加载失败，点击重试！" forState:UIControlStateNormal];
}

/*
 给view加BadgeValue
 */
+ (UIView *)showBadgeValue:(NSString *)strBadgeValue
                 withImage:(UIImage *)backgroundImage
                    onView:(UIView *)parentView
{
    UIImageView *subview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];//M_lxl
    [subview setImage:backgroundImage];
    UILabel *badgeLable=[[UILabel alloc] initWithFrame:CGRectMake(0, -1, backgroundImage.size.width, backgroundImage.size.height)];
    [badgeLable setFont:[UIFont systemFontOfSize:13]];
    [badgeLable setBackgroundColor:[UIColor clearColor]];
    badgeLable.textAlignment = UITextAlignmentCenter;
    [badgeLable setTextColor:[UIColor whiteColor]];
    if ([strBadgeValue intValue] < 10)
    {
        [badgeLable setText:strBadgeValue];
    }
    else
    {
        [badgeLable setText:@"N"];
    }
    [subview addSubview:badgeLable];
    [parentView addSubview:subview];
    subview.frame = CGRectMake(parentView.frame.size.width-subview.frame.size.width, 0,
                               subview.frame.size.width, subview.frame.size.height);
    
    return subview;
}

/*
 给view移除badgevalue
 */
+ (void)removeBadgeValue:(UIView *)view
{
    //移除badgevalue
    for (UIView *subview in view.subviews) {
        NSString *strClassName = [NSString stringWithUTF8String:object_getClassName(subview)];
        if ([strClassName isEqualToString:@"UIImageView"] ||
            [strClassName isEqualToString:@"_UIBadgeView"]) {
            [subview removeFromSuperview];
            break;
        }
    }
}

/*
 tip提示
 */
+ (void)showFavoriteTip:(NSString *)tip img:(NSString *)img{
    UIWindow *mainWindow= [[UIApplication sharedApplication] keyWindow];
    for(UIView *view in mainWindow.subviews)
    {
        if ([view isKindOfClass:[UIImageView class]])
        {
            [view removeFromSuperview];
        }
    }
    
    UIImageView *starImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_toast.png"]];
    [starImageView setFrame:CGRectMake((mainWindow.frame.size.width - 170)/2, (mainWindow.frame.size.height - 60)/2, 170, 60)];
    
    UIImageView *iconImageview;
    if ([img isEqualToString:@""]) {
        iconImageview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_toast_right.png"]];
    }else{
        iconImageview=[[UIImageView alloc] initWithImage:[UIImage imageNamed:img]];
    }
    
    [iconImageview setFrame:CGRectMake(15, (starImageView.frame.size.height - 30)/2, 30, 30)];
    [starImageView addSubview:iconImageview];
    
    UILabel *lblText = [[UILabel alloc] initWithFrame:CGRectMake(35, (starImageView.frame.size.height-30)/2, starImageView.frame.size.width-40, 30)];
    lblText.textAlignment = UITextAlignmentCenter;
    lblText.text = tip;
    lblText.backgroundColor = [UIColor clearColor];
    [lblText setTextColor:[UIColor whiteColor]];
    [lblText setFont:[UIFont systemFontOfSize:15]];
    [starImageView addSubview:lblText];
    
    [mainWindow addSubview:starImageView];
    
    //消失的动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:3.0f];
    [UIView setAnimationDelay:2.0f];
    
    starImageView.alpha = 0.0f;
    
    [UIView commitAnimations];

}


#pragma mark -
#pragma mark 添加Notification
/*
 *注册通知
 *
 *@param context
 *  传入接收消息的上下文，即谁要接收消息，类型为UIViewController
 *
 *@param notificationName
 *  传入通知的名称
 *
 *@param notificationFunction
 *  传入接到通知后要调用的方法名
 *
 *@调用举例
 *   [StaticTools registerNotification:self notificationName:@"updata" notificationFunction:@selector(updata:)];
 */
+(void)registerNotification:(UIViewController *)context
           notificationName:(NSString * const)notificationName
       notificationFunction:(SEL)function
{
    if ([context respondsToSelector:function])
    {
        [[NSNotificationCenter defaultCenter] addObserver:context selector:function name:notificationName object:nil];
    }
}

#pragma mark -
#pragma mark 发送Notification
/*
 *发送通知
 *
 *@param notificationName
 *  传入通知的名称
 *
 *@param param
 *  传入通知需要携带的值，类型为id
 *
 *@调用举例
 *   NSArray* arr = [[NSArray alloc] initWithObjects:@"a",@"b", nil];
 [StaticTools postNotification:@"updata" param: arr];
 *
 *@取出消息中携带值方法
 *  在接到通知后要调用的方法中  NSArray* arr = (NSArray*)[n object];
 */
+ (void)postNotification:(NSString *)notificationName param:(id)param{
    NSNotification *notification = [NSNotification notificationWithName:notificationName object:param];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

#pragma mark -
#pragma mark 删除Notification
/*
 *删除接收通知
 *
 *@param context
 *  传入接收消息的上下文，即谁要接收消息，类型为UIViewController
 *
 *@param notificationName
 *  传入通知的名称，若在viewDidLoad 中调用注册通知，则在viewDidUnload中调用删除
 *
 *@调用举例
 *   [StaticTools removeNotification:self notificationName:@"updata"];
 */
+ (void)removeNotification:(UIViewController *)context  notificationName:(NSString *)notificationName{
    [[NSNotificationCenter defaultCenter] removeObserver:context name:notificationName object:nil];
}




#pragma mark - 去掉cell多余的分割线
+ (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];

}

@end

