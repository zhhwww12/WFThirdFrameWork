//
//  GeneralSetting.h
//  ReadBook
//
//  Created by 吴付伟 on 14-8-21.
//  Copyright (c) 2014年 glodon. All rights reserved.
//

#ifndef ReadBook_GeneralSetting_h
#define ReadBook_GeneralSetting_h

//系统版本号
#define IOSVERSION [[[UIDevice currentDevice] systemVersion] floatValue]
//屏幕宽 高
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight  [UIScreen mainScreen].bounds.size.height

//屏幕宽度
#define Width_Screen ([UIScreen mainScreen].bounds.size.width)
#define Height_Screen ([UIScreen mainScreen].bounds.size.height)

//keywidow
#define kKeyWidow [UIApplication sharedApplication].keyWindow

//ios 系统版本
#define IOS_VERSION  [[UIDevice currentDevice]systemVersion].integerValue

//手机设备类型
#define DeVice_Model [UIDevice currentDevice].model

#define KcolorCoverRGB(x) x/255.0

//当前应用版本
#define INFO_CurrentVersionString [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]//build值
#define INFO_CurrentFullVersionString [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]//完整版本号


//颜色转换
#define OPERATION_ColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

///颜色转换RGB
#define OPERATION_RGBCOLOR(a,b,c)  [UIColor colorWithRed:(float)a/255.0 \
green:(float)b/255.0 \
blue:(float)c/255.0 alpha:1]

#define OPERATION_RGBCOLORALPHA(r,g,b,a) ([UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)])

//字体
//平方字体
#define PFSC_FONT(s)     [UIFont systemFontOfSize:s]
#define PFSC_MEDFONT(s)  [UIFont boldSystemFontOfSize:s]

//弱引用宏
#define WEAKSELF __weak typeof(self) weakSelf = self;

//放在屏幕中轴上的控件的水平坐标
#define DynamicOriginXByItemWidthValue(value) (([UIScreen mainScreen].bounds.size.width-value)/2.0)

#define IOS_Version   [[[UIDevice currentDevice] systemVersion] floatValue]


//x
#define VIEWBOTTOMRIGHTX(frame) (frame.origin.x+frame.size.width)
//y
#define VIEWBOTTOMRIGHTY(frame) (frame.origin.y+frame.size.height)


#define AppDidEnterBackground @"DidEnterBackground"
#define AppDidBecomeActive @"AppDidBecomeActive"

#define CFG_ParamDict_V @{@"v": @"1.0"}


#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define lineColor [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1]

#define bundlePath(name,type) [[NSBundle bundleForClass:self.class] pathForResource: [NSString stringWithFormat:@"FacilityImage.bundle/%@",name] ofType:type]
#define bundlepngImagePath(name) [[NSBundle bundleForClass:self.class] pathForResource:[NSString stringWithFormat:@"FacilityImage.bundle/%@",name] ofType:@"png"]

//更改勿扰模式设置通知
#define ChangeNodisturbStateNotification  @"changeNodisturbStateNotification"

//更改勿扰模式设置通知
#define haveNewwenzhendan  @"haveNewwenzhendan"

//更改勿扰模式设置通知
#define homePageDataChangeValue  @"homePageDataChangeValue"
#endif
