#import <Foundation/Foundation.h>
#import "Menu.h"
#import "Page.h"
#import "ToggleItem.h"
#import "PageItem.h"
#import "SliderItem.h"
#import "TextfieldItem.h"
#import "InvokeItem.h"
#import "Utils.h"

//Create a subclass of UITapGestureRecognizer to be able to pass an argument when trying to change page
@interface InheritGesture : UITapGestureRecognizer

@property (nonatomic) int number;
@property (nonatomic) NSString *text;
@property (nonatomic) void (*ptr)();

@end

@implementation InheritGesture: UITapGestureRecognizer
@end

//Create a subclass of UISlider to be able to pass info when the value is changed
@interface MyUISlider : UISlider

@property (nonatomic) int number;
@property (nonatomic) NSString *customText;

@end

@implementation MyUISlider: UISlider
@end

@implementation Menu {
   UIWindow *mainWindow;
   NSUserDefaults *userDefaults;
   UIButton *menuButton;
   CGPoint latestMenuButtonPosition;
   CGPoint latestMenuPosition;
   UIButton *menuHeader;
   UIView *menuHeaderBar;
   CAShapeLayer *menuHeaderBarLayer;
   UILabel *menuTitle;
   UIButton *menuBackButton;
   UIButton *menuCloseButton;
   UIScrollView *menuScrollView;
   CGFloat menuScrollViewHeight;
   UIView *menuTopBorder;
   UIView *menuBottomBorder;
   UIView *menuLeftBorder;
   UIView *menuRightBorder;
   UIView *menuHeaderBottomBorder;
}

@synthesize Pages = _Pages;
@synthesize CurrentPage = _CurrentPage;
@synthesize MenuItems = _MenuItems; //That's a dictionnary that stores a key/value pair of all MenuItems. That way I can find a specific item by name without looping all of them.
@synthesize ScrollViewRef = _ScrollViewRef; //That's a property of the menu that will have a getter to access the menu's scrollView at anytime so I can retrieve UI elements easily from outside this class.

- (void) setPages:(NSMutableArray<Page *> *)pPages {
   _Pages = pPages;
}

- (NSMutableArray<Page *> *) Pages {
   return _Pages;
}

- (void) setCurrentPage:(int)pCurrentPage {
   _CurrentPage = pCurrentPage;
}

- (int) CurrentPage {
   return _CurrentPage;
}

- (void) setMenuItems:(NSMutableDictionary *)pMenuItems {
   _MenuItems = pMenuItems;
}

- (NSMutableDictionary *) MenuItems {
   return _MenuItems;
}

- (UIScrollView *) ScrollViewRef {
   return _ScrollViewRef;
}

- (void) showDescription:(InheritGesture *)tap
{
   showPopup(@"Description :", tap.text);
}

- (id)itemWithName:(NSString *)itemName 
{
   for (Page *currentPage in self.Pages)
   {
      for (MenuItem *currentItem in currentPage.Items)
      {
         if([currentItem.Title isEqualToString:itemName])
            return currentItem;
      }
   }
   
   return NULL;
}

- (BOOL)isItemOn:(NSString *)itemName 
{
	//Lagging?
   /*for (Page *currentPage in self.Pages)
   {
      int count = [currentPage.Items count];
      for (int i=0; i<count; i++)
      {
         id currentItem = [currentPage.Items objectAtIndex:i];*/
		 id currentItem = [self.MenuItems objectForKey:itemName];
		 
         if([currentItem isKindOfClass:[ToggleItem class]])
         {
            ToggleItem *myItem = currentItem;
            if([myItem.Title isEqualToString:itemName]){
               if(myItem.IsOn)
                  return YES;
               else
                  return NO;
            }
         }
         else if([currentItem isKindOfClass:[SliderItem class]])
         {
            SliderItem *myItem = currentItem;
            if([myItem.Title isEqualToString:itemName]){
               if(myItem.IsOn)
                  return YES;
               else
                  return NO;
            }
         }
         else if([currentItem isKindOfClass:[TextfieldItem class]])
         {
            TextfieldItem *myItem = currentItem;
            if([myItem.Title isEqualToString:itemName]){
               if(myItem.IsOn)
                  return YES;
               else
                  return NO;
            }
         }
      /*}
   }*/
   
   return NO;
}

- (float)getSliderValue:(NSString *)itemName
{
   //Lagging?
   /*for (Page *currentPage in self.Pages)
   {
      int count = [currentPage.Items count];
      for (int i=0; i<count; i++)
      {
         id currentItem = [currentPage.Items objectAtIndex:i];*/
		 id currentItem = [self.MenuItems objectForKey:itemName];
		 
         if([currentItem isKindOfClass:[SliderItem class]])
         {
            SliderItem *myItem = currentItem;
            if([myItem.Title isEqualToString:itemName]){
               return myItem.DefaultValue;
            }
         }
      /*}
   }*/
   
   return 0.0f;
}

- (NSString *)getTextfieldValue:(NSString *)itemName
{
   //Lagging?
   /*for (Page *currentPage in self.Pages)
   {
      int count = [currentPage.Items count];
      for (int i=0; i<count; i++)
      {
         id currentItem = [currentPage.Items objectAtIndex:i];*/
		 id currentItem = [self.MenuItems objectForKey:itemName];
		 
         if([currentItem isKindOfClass:[TextfieldItem class]])
         {
            TextfieldItem *myItem = currentItem;
            if([myItem.Title isEqualToString:itemName]){
               return myItem.DefaultValue;
            }
         }
      /*}
   }*/
   
   return @"";
}

- (void) toggleItemOnOff:(InheritGesture *)tap
{
   int itemIndexInScrollView = tap.number;
   UIButton *itemViewRef = [menuScrollView.subviews objectAtIndex: itemIndexInScrollView];
   NSString *itemTitle = tap.text;

   id menuItem = [self itemWithName:itemTitle];

   //If the item is a ToggleItem
   if([menuItem isKindOfClass:[ToggleItem class]])
   {
      ToggleItem *myToggleItem = menuItem;
      
	  //Set/replace the userDefaults on/off value for that item
      NSString *keyIO = [itemTitle stringByAppendingString:@"_IsOn"]; //.Title + "_IsOn"
      [userDefaults setObject:[NSNumber numberWithBool:!myToggleItem.IsOn] forKey:keyIO];

      //Change the background color
      if(!myToggleItem.IsOn){
         [UIView animateWithDuration:0.25 animations:^ {
            itemViewRef.backgroundColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:0.75];
         }];
      }
      else{
         [UIView animateWithDuration:0.25 animations:^ {
            itemViewRef.backgroundColor = [UIColor clearColor];
         }];
      }

      //Change the actual bool
      myToggleItem.IsOn = !myToggleItem.IsOn;
   }
   else if([menuItem isKindOfClass:[SliderItem class]])
   {
      //Prevent toggling on/off when the tapped region is also where the slider is
      CGPoint p = [tap locationInView:itemViewRef];
      
      if(p.y > 30 && p.x < itemViewRef.bounds.size.width / 3 * 2)
         return;

      SliderItem *mySliderItem = menuItem;
	  
	  //Set/replace the userDefaults on/off value for that item
      NSString *keyIO = [itemTitle stringByAppendingString:@"_IsOn"]; //.Title + "_IsOn"
      [userDefaults setObject:[NSNumber numberWithBool:!mySliderItem.IsOn] forKey:keyIO];
      
      //Change the background color
      if(! mySliderItem.IsOn){
         [UIView animateWithDuration:0.25 animations:^ {
            itemViewRef.backgroundColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:0.75];
         }];
      }
      else{
         [UIView animateWithDuration:0.25 animations:^ {
            itemViewRef.backgroundColor = [UIColor clearColor];
         }];
      }

      //Change the actual bool
      mySliderItem.IsOn = ! mySliderItem.IsOn;
   }
   else if([menuItem isKindOfClass:[TextfieldItem class]])
   {
      TextfieldItem *myTextfieldItem = menuItem;
      
	  //Set/replace the userDefaults on/off value for that item
      NSString *keyIO = [itemTitle stringByAppendingString:@"_IsOn"]; //.Title + "_IsOn"
      [userDefaults setObject:[NSNumber numberWithBool:!myTextfieldItem.IsOn] forKey:keyIO];
	  
      //Change the background color
      if(!myTextfieldItem.IsOn){
         [UIView animateWithDuration:0.25 animations:^ {
            itemViewRef.backgroundColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:0.75];
         }];
      }
      else{
         [UIView animateWithDuration:0.25 animations:^ {
            itemViewRef.backgroundColor = [UIColor clearColor];
         }];
      }

      //Change the actual bool
      myTextfieldItem.IsOn = ! myTextfieldItem.IsOn;
   }
}

- (void)addToggleItem:(NSString *)title_ 
		description:(NSString *)description_ isOn:(BOOL)isOn_
{
   float toggleItemHeight = 40;

   //Create item UI
   UIButton *myItem = [[UIButton alloc] initWithFrame:CGRectMake(0, menuScrollViewHeight, 200, toggleItemHeight)];
   if(!isOn_)
      myItem.backgroundColor = [UIColor clearColor];
   else
      myItem.backgroundColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:0.75];
   myItem.layer.borderWidth = 0.5f;
   myItem.layer.borderColor = [UIColor whiteColor].CGColor;
    
   UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, myItem.bounds.size.width - 35, toggleItemHeight)];
   myLabel.text = title_;
   myLabel.textColor = [UIColor whiteColor];
   myLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:15];
   myLabel.textAlignment = NSTextAlignmentLeft;
   //[myLabel sizeToFit]; //make container the same size as the resulting text
   //myLabel.center = CGPointMake(CGRectGetMidX(myItem.bounds), CGRectGetMidY(myItem.bounds));
   //myLabel.adjustsFontSizeToFitWidth = true;
   [myItem addSubview: myLabel];
   
   //Add description button 
   UIButton *descriptionButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
   descriptionButton.frame = CGRectMake(myItem.bounds.size.width - 30, 12.5, 15, 15);
   descriptionButton.tintColor = [UIColor whiteColor];
   [myItem addSubview: descriptionButton];

   //Add description touch event listener
   InheritGesture *tapGestureRecognizer = [[InheritGesture alloc]initWithTarget:self action:@selector(showDescription:)];
   tapGestureRecognizer.text = description_;
   [descriptionButton addGestureRecognizer: tapGestureRecognizer];

   [menuScrollView addSubview: myItem];

   menuScrollViewHeight += toggleItemHeight;
   menuScrollView.contentSize = CGSizeMake(200, menuScrollViewHeight);

   //Add touch event listener
   InheritGesture *tapGestureRecognizer2 = [[InheritGesture alloc]initWithTarget:self action:@selector(toggleItemOnOff:)];
   tapGestureRecognizer2.text = title_;
   tapGestureRecognizer2.number = [menuScrollView.subviews indexOfObject: myItem];
   [myItem addGestureRecognizer: tapGestureRecognizer2];
}

- (void)InvokeFunction:(InheritGesture *)tap
{
   //Do an animation on the item
   int itemIndexInScrollView = tap.number;
   UIButton *itemViewRef = [menuScrollView.subviews objectAtIndex: itemIndexInScrollView];

   [UIView animateWithDuration:0.125 animations:^ {
      itemViewRef.backgroundColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:0.75];
   }];
   [UIView animateWithDuration:0.125 animations:^ {
      itemViewRef.backgroundColor = [UIColor clearColor];
   }];

   //Invoke the function
   tap.ptr();
}

- (void)addInvokeItem:(NSString *)title_ 
		description:(NSString *)description_ functionPtr:(void (*)())functionPtr_
{
   float invokeItemHeight = 40;

   //Create item UI
   UIButton *myItem = [[UIButton alloc] initWithFrame:CGRectMake(0, menuScrollViewHeight, 200, invokeItemHeight)];
   myItem.backgroundColor = [UIColor clearColor];
   myItem.layer.borderWidth = 0.5f;
   myItem.layer.borderColor = [UIColor whiteColor].CGColor;
    
   UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, myItem.bounds.size.width - 35, invokeItemHeight)];
   myLabel.text = title_;
   myLabel.textColor = [UIColor whiteColor];
   myLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:15];
   myLabel.textAlignment = NSTextAlignmentLeft;
   //[myLabel sizeToFit]; //make container the same size as the resulting text
   //myLabel.center = CGPointMake(CGRectGetMidX(myItem.bounds), CGRectGetMidY(myItem.bounds));
   //myLabel.adjustsFontSizeToFitWidth = true;
   [myItem addSubview: myLabel];
   
   //Add description button 
   UIButton *descriptionButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
   descriptionButton.frame = CGRectMake(myItem.bounds.size.width - 30, 12.5, 15, 15);
   descriptionButton.tintColor = [UIColor whiteColor];
   [myItem addSubview: descriptionButton];

   //Add description touch event listener
   InheritGesture *tapGestureRecognizer = [[InheritGesture alloc]initWithTarget:self action:@selector(showDescription:)];
   tapGestureRecognizer.text = description_;
   [descriptionButton addGestureRecognizer: tapGestureRecognizer];

   [menuScrollView addSubview: myItem];

   menuScrollViewHeight += invokeItemHeight;
   menuScrollView.contentSize = CGSizeMake(200, menuScrollViewHeight);

   //Add touch event listener
   InheritGesture
*tapGestureRecognizer2 = [[InheritGesture alloc]initWithTarget:self action:@selector(InvokeFunction:)];
   tapGestureRecognizer2.ptr = functionPtr_;
   tapGestureRecognizer2.number = [menuScrollView.subviews indexOfObject: myItem];
   [myItem addGestureRecognizer: tapGestureRecognizer2];
}

- (void)pageClicked:(InheritGesture *)tap
{
   [self loadPage: tap.number];
}

- (void)addPageItem:(NSString *)title_ targetPage:(NSUInteger)targetPage_
{
   float pageItemHeight = 40;

   //Create item UI
   UIButton *myItem = [[UIButton alloc] initWithFrame:CGRectMake(0, menuScrollViewHeight, 200, pageItemHeight)];
   myItem.backgroundColor = [UIColor clearColor];
   myItem.layer.borderWidth = 0.5f;
   myItem.layer.borderColor = [UIColor whiteColor].CGColor;
   
   //Title
   UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, myItem.bounds.size.width - 35, pageItemHeight)];
   myLabel.text = title_;
   myLabel.textColor = [UIColor whiteColor];
   myLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:15];
   myLabel.textAlignment = NSTextAlignmentLeft;
   //[myLabel sizeToFit]; //make container the same size as the resulting text
   //myLabel.center = CGPointMake(CGRectGetMidX(myItem.bounds), CGRectGetMidY(myItem.bounds));
   //myLabel.adjustsFontSizeToFitWidth = true;
   [myItem addSubview: myLabel];

   //Arrow image
   NSString *desiredImgPath = @"/var/mobile/Documents/com.xelahot.xelahotagario/images/in.png";
   UIImage* pageImage = [UIImage imageWithContentsOfFile:desiredImgPath];
   //UIImage* pageImage = [UIImage imageWithContentsOfFile:@"/var/mobile/Documents/com.xelahot.libxelahot/images/in.png"];
   UIImageView *imageView = [[UIImageView alloc] initWithImage:pageImage];      
   imageView.frame = CGRectMake(myItem.bounds.size.width - 30, 10, 20, 20);
   imageView.backgroundColor = [UIColor clearColor];

   [myItem addSubview: imageView];

   [menuScrollView addSubview: myItem];

   menuScrollViewHeight += pageItemHeight;
   menuScrollView.contentSize = CGSizeMake(200, menuScrollViewHeight);

   //Add touch event listener
   InheritGesture *tapGestureRecognizer = [[InheritGesture alloc]initWithTarget:self action:@selector(pageClicked:)];
   tapGestureRecognizer.number = targetPage_;
   [myItem addGestureRecognizer: tapGestureRecognizer];
}

-(void)menuSliderValueChanged:(MyUISlider *)slider_ 
{
   NSString *title = slider_.customText;
   int itemViewIndex = slider_.number;

   //Get the menu item views references
   UIButton *itemViewRef = [menuScrollView.subviews objectAtIndex: itemViewIndex];
   MyUISlider *sliderViewRef = [itemViewRef.subviews objectAtIndex: 2];
   UILabel *sliderLabel = [itemViewRef.subviews objectAtIndex: 3];

   //Get the SliderItem ref. from title
   SliderItem *sliderItem = [self itemWithName:title];
   
   //Assign the new UI value on the instance property
   sliderItem.DefaultValue = sliderViewRef.value;
   
   //Set/replace the userDefaults DefaultValue for that item
   NSString *keyDF = [title stringByAppendingString:@"_DefaultValue"]; //.Title + "_DefaultValue"
   [userDefaults setObject:[NSNumber numberWithFloat:sliderItem.DefaultValue] forKey:keyDF];
   
   //Update the value on the UI elements
   dispatch_async(dispatch_get_main_queue(), ^{
      //Update the label text with that new value depending on the .IsFloating proprety
      if(sliderItem.IsFloating)
         sliderLabel.text = [NSString stringWithFormat:@"%.2f", sliderViewRef.value];
      else{
         sliderLabel.text = [NSString stringWithFormat:@"%.0f", sliderViewRef.value];
      }
      
      //Update the actual slider value
      sliderViewRef.value = sliderItem.DefaultValue;
   });
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return destImage;
}

- (void)addSliderItem:(NSString *)title_ 
		description:(NSString *)description_ isOn:(BOOL)isOn_ isFloating:(BOOL)isFloating_ defaultValue:(float)defaultValue_ minValue:(float)minValue_ maxValue:(float)maxValue_
{
   float sliderItemHeight = 60;

   //Create item UI
   UIButton *myItem = [[UIButton alloc] initWithFrame:CGRectMake(0, menuScrollViewHeight, 200, sliderItemHeight)];
   if(!isOn_)
      myItem.backgroundColor = [UIColor clearColor];
   else
      myItem.backgroundColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:0.75];
   myItem.layer.borderWidth = 0.5f;
   myItem.layer.borderColor = [UIColor whiteColor].CGColor;
    
   UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, myItem.bounds.size.width - 35, 35)];
   myLabel.text = title_;
   myLabel.textColor = [UIColor whiteColor];
   myLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:15];
   myLabel.textAlignment = NSTextAlignmentLeft;
   //[myLabel sizeToFit]; //make container the same size as the resulting text
   //myLabel.center = CGPointMake(CGRectGetMidX(myItem.bounds), CGRectGetMidY(myItem.bounds));
   //myLabel.adjustsFontSizeToFitWidth = true;
   [myItem addSubview: myLabel];
   
   //Add description button 
   UIButton *descriptionButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
   descriptionButton.frame = CGRectMake(myItem.bounds.size.width - 30, 7.5, 15, 15);
   descriptionButton.tintColor = [UIColor whiteColor];
   [myItem addSubview: descriptionButton];

   //Add description touch event listener
   InheritGesture *tapGestureRecognizer = [[InheritGesture alloc]initWithTarget:self action:@selector(showDescription:)];
   tapGestureRecognizer.text = description_;
   [descriptionButton addGestureRecognizer: tapGestureRecognizer];

   MyUISlider *menuSlider = [[MyUISlider alloc]initWithFrame:CGRectMake(10, 30, self.bounds.size.width / 2 + 10, 20)];
   menuSlider.minimumTrackTintColor = [UIColor whiteColor];
   menuSlider.maximumTrackTintColor = [UIColor whiteColor];
   
   NSString *desiredImgPath = @"/var/mobile/Documents/com.xelahot.xelahotagario/images/sliderIcon.png";
   UIImage* sliderImage = [UIImage imageWithContentsOfFile:desiredImgPath];
   //UIImage* sliderImage = [UIImage imageWithContentsOfFile:@"/var/mobile/Documents/com.xelahot.libxelahot/images/sliderIcon.png"];
   UIImage* sliderImageResized = [self imageWithImage:sliderImage convertToSize:CGSizeMake(20, 20)];
   [menuSlider setThumbImage: sliderImageResized forState:UIControlStateNormal];
   [menuSlider setThumbImage: sliderImageResized forState: UIControlStateSelected];
   [menuSlider setThumbImage: sliderImageResized forState: UIControlStateHighlighted];

   dispatch_async(dispatch_get_main_queue(), ^{
      menuSlider.value = defaultValue_;
   });
   menuSlider.minimumValue = minValue_;
   menuSlider.maximumValue = maxValue_;
   menuSlider.continuous = true;
   
   [myItem addSubview: menuSlider];

   //Slider text value
   UILabel *menuSliderValue = [[UILabel alloc]initWithFrame:CGRectMake(10 + menuSlider.bounds.size.width + 10, 30, self.bounds.size.width - menuSlider.bounds.size.width - 20, 20)];

   dispatch_async(dispatch_get_main_queue(), ^{
      if(isFloating_)
         menuSliderValue.text = [NSString stringWithFormat:@"%.2f", menuSlider.value];
      else{
         menuSliderValue.text = [NSString stringWithFormat:@"%.0f", menuSlider.value];
      }
   });

   menuSliderValue.textColor = [UIColor whiteColor];
   menuSliderValue.font = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:15];
   menuSliderValue.textAlignment = NSTextAlignmentLeft;

   [myItem addSubview: menuSliderValue];

   [menuScrollView addSubview: myItem];

   menuScrollViewHeight += sliderItemHeight;
   menuScrollView.contentSize = CGSizeMake(200, menuScrollViewHeight);

   //Add on/off event listener
   InheritGesture *tapGestureRecognizer2 = [[InheritGesture alloc]initWithTarget:self action:@selector(toggleItemOnOff:)];
   tapGestureRecognizer2.text = title_;
   tapGestureRecognizer2.number = [menuScrollView.subviews indexOfObject: myItem];
   [myItem addGestureRecognizer: tapGestureRecognizer2];

   //Add slider value changed event
   menuSlider.number = [menuScrollView.subviews indexOfObject: myItem];
   menuSlider.customText = title_;
   [menuSlider addTarget:self action:@selector(menuSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)addTextfieldItem:(NSString *)title_ 
		description:(NSString *)description_ isOn:(BOOL)isOn_ defaultValue:(NSString *)defaultValue_
{   
   float textfieldItemHeight = 60;

   //Create item UI
   UIButton *myItem = [[UIButton alloc] initWithFrame:CGRectMake(0, menuScrollViewHeight, 200, textfieldItemHeight)];
   if(!isOn_)
      myItem.backgroundColor = [UIColor clearColor];
   else
      myItem.backgroundColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:0.75];
   myItem.layer.borderWidth = 0.5f;
   myItem.layer.borderColor = [UIColor whiteColor].CGColor;
    
   UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, myItem.bounds.size.width - 35, 35)];
   myLabel.text = title_;
   myLabel.textColor = [UIColor whiteColor];
   myLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:15];
   myLabel.textAlignment = NSTextAlignmentLeft;
   //[myLabel sizeToFit]; //make container the same size as the resulting text
   //myLabel.center = CGPointMake(CGRectGetMidX(myItem.bounds), CGRectGetMidY(myItem.bounds));
   //myLabel.adjustsFontSizeToFitWidth = true;
   [myItem addSubview: myLabel];
   
   //Add description button 
   UIButton *descriptionButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
   descriptionButton.frame = CGRectMake(myItem.bounds.size.width - 30, 7.5, 15, 15);
   descriptionButton.tintColor = [UIColor whiteColor];
   [myItem addSubview: descriptionButton];

   //Add description touch event listener
   InheritGesture *tapGestureRecognizer = [[InheritGesture alloc]initWithTarget:self action:@selector(showDescription:)];
   tapGestureRecognizer.text = description_;
   [descriptionButton addGestureRecognizer: tapGestureRecognizer];
   
   //Container to add padding to the textfield
   UIView *textfieldContainer = [[UIView alloc] initWithFrame:CGRectMake(10, 30, self.bounds.size.width - 50, 20)];
   //textfieldContainer.layer.borderWidth = 0.5f;
   //textfieldContainer.layer.borderColor = [UIColor whiteColor].CGColor;
   //textfieldContainer.layer.cornerRadius = 2.0f;
   textfieldContainer.backgroundColor = [UIColor clearColor];
   [myItem addSubview: textfieldContainer];

   //Add borders to the container
   UIView *containerBotBorder = [[UIView alloc] initWithFrame:CGRectMake(10, 50, self.bounds.size.width - 50, 0.5)];
   containerBotBorder.backgroundColor = [UIColor whiteColor];
   [myItem addSubview: containerBotBorder];
   UIView *containerLeftBorder = [[UIView alloc] initWithFrame:CGRectMake(9.5, 30, 0.5, 20)];
   containerLeftBorder.backgroundColor = [UIColor whiteColor];
   [myItem addSubview: containerLeftBorder];

   //The actual textfield
   UITextField * myTextfield = [[UITextField alloc]initWithFrame:CGRectMake(5, 5, self.bounds.size.width - 50 - 5, 20 - 5)];
   myTextfield.delegate = self; //needed to close the keyboard
   //myTextfield.layer.borderWidth = 0.5f;
   //myTextfield.layer.borderColor = [UIColor whiteColor].CGColor;
   //myTextfield.layer.cornerRadius = 2.0f;
   myTextfield.textColor = [UIColor whiteColor];
   myTextfield.textAlignment = NSTextAlignmentLeft;
   myTextfield.font = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:14];
   myTextfield.backgroundColor = [UIColor clearColor];
   myTextfield.text = defaultValue_;
   
   //Add padding to the textfield text
   /*UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
   myTextfield.leftView = paddingView;
   myTextfield.leftViewMode = UITextFieldViewModeAlways;*/

   [textfieldContainer addSubview: myTextfield];

   [menuScrollView addSubview: myItem];
   myTextfield.tag = [menuScrollView.subviews indexOfObject: myItem];

   menuScrollViewHeight += textfieldItemHeight;
   menuScrollView.contentSize = CGSizeMake(200, menuScrollViewHeight);

   //Add on/off event listener
   InheritGesture *tapGestureRecognizer2 = [[InheritGesture alloc]initWithTarget:self action:@selector(toggleItemOnOff:)];
   tapGestureRecognizer2.text = title_;
   tapGestureRecognizer2.number = [menuScrollView.subviews indexOfObject: myItem];
   [myItem addGestureRecognizer: tapGestureRecognizer2];
}

// Native method that happens when we clicked the "return" key on the keyboard and the keyboard goes away. ***The arg1 must end with a '_' for the keyboard to close with resignFirstResponder
-(BOOL)textFieldShouldReturn:(UITextField*)textfieldRef_ {
   int itemIndexInScrollView = textfieldRef_.tag; //Get the item index in the scrollView (might be problematic if it does that on every keyboard in the game because there won't be any TextfieldItem or .tag)

   //Get the item title
   UIButton *itemViewRef = [menuScrollView.subviews objectAtIndex: itemIndexInScrollView];
   UILabel *itemLabelRef = [itemViewRef.subviews objectAtIndex: 0];
   NSString *itemTitle = itemLabelRef.text;

   //Get the TextfieldItem ref. to set the .DefaultValue
   TextfieldItem *textfieldItem = [self itemWithName:itemTitle];
   textfieldItem.DefaultValue = textfieldRef_.text;
   
   //Set/replace the userDefaults DefaultValue for that item
   NSString *keyDF = [itemTitle stringByAppendingString:@"_DefaultValue"]; //.Title + "_DefaultValue"
   [userDefaults setObject:textfieldItem.DefaultValue forKey:keyDF];

   //Returns true by default in the default implementation
   //[textfieldRef_ resignFirstResponder];
   [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];

   return true;
}

- (void)addPage:(Page *)page {
   [self.Pages addObject:page];
}

- (void)backPage
{
   Page *currentPage = [Page pageWithNum:_CurrentPage menuRef:(Menu *)self];
   [self loadPage: currentPage.ParentPage];
}

- (void)closeMenu:(UITapGestureRecognizer *)tap {
    if(tap.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.5 animations:^ {
            self.alpha = 0.0f;
        }];
    }
}

- (void)openMenu:(UITapGestureRecognizer *)tap {
    if(tap.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.5 animations:^ {
            self.alpha = 1.0f;
        }];
    }
}

- (void)loadPage:(int)pageNumber
{
   if(_CurrentPage == 1){
      //Show the back button
      [UIView animateWithDuration:0.5 animations:^ {
         menuBackButton.alpha = 1.0f;
      }];
   }

   _CurrentPage = pageNumber;

   if(pageNumber == 1){
      //Hide the back button
      menuBackButton.alpha = 0.0f;
   }
   
   Page * myPage = [Page pageWithNum:pageNumber menuRef:(Menu *)self];
   //Page *myPage = [self.Pages objectAtIndex:pageNumber - 1]; //This way is bad because it relies on the order addPage was used in Tweak.xm
   NSMutableArray *pageItems = myPage.Items;

   //Hide the scrollView
   [UIView animateWithDuration:0.25 animations:^ {
      menuScrollView.alpha = 0.0f;
    }];

   //Before loading the page, clear the scrollView items
   [menuScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
   menuScrollView.contentSize = CGSizeMake(200, 0);
   menuScrollViewHeight = 0;

   for (id currentItem in pageItems)
   {
      if([currentItem isKindOfClass:[ToggleItem class]])
      {
         ToggleItem *myToggleItem = currentItem;
         [self addToggleItem:(NSString *) myToggleItem.Title 
		description:(NSString *) myToggleItem.Description isOn:(BOOL) myToggleItem.IsOn];
      }
      else if([currentItem isKindOfClass:[PageItem class]])
      {
         PageItem *myPageItem = currentItem;
         [self addPageItem:(NSString *) myPageItem.Title 
		targetPage:(NSUInteger) myPageItem.TargetPage];
      }
      else if([currentItem isKindOfClass:[SliderItem class]])
      {
         SliderItem *mySliderItem = currentItem;
         [self addSliderItem:(NSString *) mySliderItem.Title description:(NSString *) mySliderItem.Description isOn:(BOOL) mySliderItem.IsOn isFloating:(BOOL)mySliderItem.IsFloating defaultValue:(float)mySliderItem.DefaultValue minValue:(float)mySliderItem.MinValue maxValue:(float)mySliderItem.MaxValue];
      }
      else if([currentItem isKindOfClass:[TextfieldItem class]])
      {
         TextfieldItem *myTextfieldItem = currentItem;
         [self addTextfieldItem:(NSString *) myTextfieldItem.Title description:(NSString *) myTextfieldItem.Description isOn:(BOOL) myTextfieldItem.IsOn defaultValue:(NSString *) myTextfieldItem.DefaultValue];
      }
      if([currentItem isKindOfClass:[InvokeItem class]])
      {
         InvokeItem *myInvokeItem = currentItem;
         [self addInvokeItem:(NSString *) myInvokeItem.Title 
		description:(NSString *) myInvokeItem.Description functionPtr:(void (*)()) myInvokeItem.FunctionPtr];
      }
   }

   //Show the scrollView again
   [UIView animateWithDuration:0.25 animations:^ {
      menuScrollView.alpha = 1.0f;
    }];
}

- (void)moveMenu:(UIPanGestureRecognizer *)gesture {
   CGPoint newPosition = [gesture translationInView:self.superview];

   self.frame = CGRectMake(latestMenuPosition.x + newPosition.x, latestMenuPosition.y + newPosition.y, self.frame.size.width, self.frame.size.height);
   
   if(gesture.state == UIGestureRecognizerStateEnded)
   {
      //All fingers are lifted. Save position
      latestMenuPosition.x = latestMenuPosition.x + newPosition.x;
      latestMenuPosition.y = latestMenuPosition.y + newPosition.y;
   }
}

- (void)moveMenuButton:(UIPanGestureRecognizer *)gesture {
   CGPoint newPosition = [gesture translationInView:menuButton.superview];

   menuButton.frame = CGRectMake(latestMenuButtonPosition.x + newPosition.x, latestMenuButtonPosition.y + newPosition.y, menuButton.frame.size.width, menuButton.frame.size.height);
   
   if(gesture.state == UIGestureRecognizerStateEnded)
   {
      //All fingers are lifted. Save position
      latestMenuButtonPosition.x = latestMenuButtonPosition.x + newPosition.x;
      latestMenuButtonPosition.y = latestMenuButtonPosition.y + newPosition.y;
   }
}

//This is a native method that gets called whenever I touch a UIView
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
   latestMenuPosition = CGPointMake(self.frame.origin.x, self.frame.origin.y);

   latestMenuButtonPosition = CGPointMake(menuButton.frame.origin.x, menuButton.frame.origin.y);
   
   //Invoke the original implementation
   [super touchesBegan:touches withEvent:event];
}

- (void)setUserDefaultsAndDict
{
   for (Page *currentPage in self.Pages)
   {
      int count = [currentPage.Items count];
	  
      for (int i=0; i<count; i++)
      {
         id currentItem = [currentPage.Items objectAtIndex:i];
		 
		 //Only these 3 types of items have values that can be saved by the users
         if([currentItem isKindOfClass:[ToggleItem class]])
         {
            ToggleItem *myItem = currentItem;
			
			//Add item reference and title to the dictionary
			[self.MenuItems setObject:myItem forKey:myItem.Title];
			
			//Find out if we the user had a value saved for the .IsOn property
			NSString *keyIO = [myItem.Title stringByAppendingString:@"_IsOn"]; //.Title + "_IsOn"
			id objectForKeyIO = [userDefaults objectForKey:keyIO];
			if(objectForKeyIO != nil)
				myItem.IsOn = [(NSNumber *)objectForKeyIO boolValue];
         }
         else if([currentItem isKindOfClass:[SliderItem class]])
         {
            SliderItem *myItem = currentItem;
			
			//Add item reference and title to the dictionary
			[self.MenuItems setObject:myItem forKey:myItem.Title];
			
            //Find out if we the user had a value saved for the .IsOn property
			NSString *keyIO = [myItem.Title stringByAppendingString:@"_IsOn"]; //.Title + "_IsOn"
			id objectForKeyIO = [userDefaults objectForKey:keyIO];
			if(objectForKeyIO != nil)
				myItem.IsOn = [(NSNumber *)objectForKeyIO boolValue];
			
			//Find out if we the user had a value saved for the .DefaultValue property
			NSString *keyDF = [myItem.Title stringByAppendingString:@"_DefaultValue"]; //.Title + "_DefaultValue"
			id objectForKeyDF = [userDefaults objectForKey:keyDF];
			if(objectForKeyDF != nil)
				myItem.DefaultValue = [(NSNumber *)objectForKeyDF floatValue];
			
			//Find out if we the user had a value saved for the .MaxValue property
			NSString *keyMV = [myItem.Title stringByAppendingString:@"_MaxValue"]; //.Title + "_MaxValue"
			id objectForKeyMV = [userDefaults objectForKey:keyMV];
			if(objectForKeyMV != nil)
				myItem.MaxValue = [(NSNumber *)objectForKeyMV floatValue]; //Might need to check if IsFloating is a int or float here.
         }
         else if([currentItem isKindOfClass:[TextfieldItem class]])
         {
            TextfieldItem *myItem = currentItem;
			
			//Add item reference and title to the dictionary
			[self.MenuItems setObject:myItem forKey:myItem.Title];
			
		    //Find out if we the user had a value saved for the .IsOn property
			NSString *keyIO = [myItem.Title stringByAppendingString:@"_IsOn"]; //.Title + "_IsOn"
			id objectForKeyIO = [userDefaults objectForKey:keyIO];
			if(objectForKeyIO != nil)
				myItem.IsOn = [(NSNumber *)objectForKeyIO boolValue];
			
			//Find out if we the user had a value saved for the .DefaultValue property
			NSString *keyDF = [myItem.Title stringByAppendingString:@"_DefaultValue"]; //.Title + "_DefaultValue"
			id objectForKeyDF = [userDefaults objectForKey:keyDF];
			if(objectForKeyDF != nil)
				myItem.DefaultValue = (NSString *)objectForKeyDF;
         }
      }
   }
}

-(UIButton *)getMenuButtRef {
	return menuButton;
}
			
- (id)initMenu{
   //Application's window we'll add the menu view to
   mainWindow = [UIApplication sharedApplication].keyWindow;
   
   //Allocate the dictionnary for the items titles and references
   self.MenuItems = [[NSMutableDictionary alloc] init];
   
   //Get the app's saved informations
   userDefaults = [NSUserDefaults standardUserDefaults];
   
   BOOL appIsPortrait = YES;
   if([[UIDevice currentDevice] orientation] != UIDeviceOrientationPortrait)
      appIsPortrait = NO;

   //Menu button
   NSString *desiredImgPath = @"/var/mobile/Documents/com.xelahot.xelahotmodmenubase/images/menuIcon.png";
   UIImage* menuButtonImage = [UIImage imageWithContentsOfFile:desiredImgPath];   
   menuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];

   float menuButtonX = mainWindow.frame.size.width - 50 - 30;
   float menuButtonY = 30;
   if(!appIsPortrait){
	   menuButtonX = mainWindow.frame.size.width - 50 - 5;
	   menuButtonY = 5;
   }
   
   latestMenuButtonPosition.x = menuButtonX;
   latestMenuButtonPosition.y = menuButtonY;
   menuButton.frame = CGRectMake(menuButtonX, menuButtonY, 50, 50);
   menuButton.backgroundColor = [UIColor clearColor];
   [menuButton setBackgroundImage:menuButtonImage forState:UIControlStateNormal];

   //Add touch events listeners
   UITapGestureRecognizer *tapGestureRecognizerMenuBtn = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openMenu:)];
   [menuButton addGestureRecognizer: tapGestureRecognizerMenuBtn];

   UIPanGestureRecognizer *moveMenuButtonRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveMenuButton:)];
   [menuButton addGestureRecognizer: moveMenuButtonRecognizer];
    
   [mainWindow addSubview:menuButton];

   //Menu UIView container
   self = [super initWithFrame:CGRectMake(0,0,200,250)];
   self.center = mainWindow.center;
   float menuX = mainWindow.frame.size.width - 30 - self.frame.size.width;
   float menuY = 30 + 50 + 15;
   if(!appIsPortrait){
	   menuX = mainWindow.frame.size.width - 5 - self.frame.size.width;
	   menuY = 5 + 50 + 10;
   }
   self.frame = CGRectMake(menuX, menuY, self.frame.size.width, self.frame.size.height);
   latestMenuPosition.x = menuX;
   latestMenuPosition.y = menuY;
   self.layer.zPosition = 1;

   self.layer.opacity = 1.0f;
   self.alpha = 0.0f; //Hidden by default
   self.backgroundColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:0.75];

   [mainWindow addSubview:self];

   //Menu header
   //menuHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 50)];
   menuHeader = [UIButton buttonWithType:UIButtonTypeCustom];
   menuHeader.frame = CGRectMake(0, 0, self.bounds.size.width, 50);
   menuHeader.backgroundColor = [UIColor clearColor];

   //Add touch event listener to close menu on double tap
   UITapGestureRecognizer *tapGestureRecognizerMenuH = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeMenu:)];
   tapGestureRecognizerMenuH.numberOfTapsRequired = 2;
   [menuHeader addGestureRecognizer: tapGestureRecognizerMenuH];

   //Add touch event listener to move the menu
   UIPanGestureRecognizer *moveMenuRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveMenu:)];
   [menuHeader addGestureRecognizer: moveMenuRecognizer];

   [self addSubview:menuHeader];

   //Menu header grabber bar
   menuHeaderBar = [[UIView alloc]initWithFrame:CGRectMake(50, 4, self.bounds.size.width - 50*2, 2)];

   menuHeaderBar.backgroundColor = [UIColor whiteColor];

   //Layer to make the grabber bar rounded
   menuHeaderBarLayer = [CAShapeLayer layer];
   menuHeaderBarLayer.path = [UIBezierPath bezierPathWithRoundedRect: menuHeaderBar.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: (CGSize){10.0, 10.0}].CGPath;
   menuHeaderBar.layer.mask = menuHeaderBarLayer;

   [menuHeader addSubview:menuHeaderBar];

   //Menu title
   menuTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 40*2, 50)];
   menuTitle.text = @"Xelahot";
   menuTitle.textColor = [UIColor whiteColor];
   menuTitle.font = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:17.0f];
   menuTitle.textAlignment = NSTextAlignmentCenter;
   [menuTitle sizeToFit]; //make container the same size as the resulting text
   menuTitle.center = CGPointMake(CGRectGetMidX(menuHeader.bounds), CGRectGetMidY(menuHeader.bounds));
   menuTitle.adjustsFontSizeToFitWidth = true;

   [menuHeader addSubview: menuTitle];

   //Menu pages back button
   NSString *desiredImgPathBack = @"/var/mobile/Documents/com.xelahot.xelahotmodmenubase/images/back.png";
   UIImage* menuBackImage = [UIImage imageWithContentsOfFile:desiredImgPathBack];    
    
   menuBackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
   menuBackButton.frame = CGRectMake(10, 15, 20, 20);
   menuBackButton.backgroundColor = [UIColor clearColor];
   menuBackButton.alpha = 0.0f; //Hidden by default
   [menuBackButton setBackgroundImage: menuBackImage forState:UIControlStateNormal];
   [menuBackButton setTintColor:[UIColor whiteColor]];
    
   UITapGestureRecognizer *tapGestureRecognizerCloseBtn = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backPage)];
   [menuBackButton addGestureRecognizer: tapGestureRecognizerCloseBtn];

   [menuHeader addSubview: menuBackButton];

   //Menu close button
   NSString *desiredImgPathClose = @"/var/mobile/Documents/com.xelahot.xelahotmodmenubase/images/close.png";
   UIImage* menuButtonCloseImage = [UIImage imageWithContentsOfFile:desiredImgPathClose];     
    
   menuCloseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
   menuCloseButton.frame = CGRectMake(menuHeader.bounds.size.width - 30, 15, 20, 20);
   menuCloseButton.backgroundColor = [UIColor clearColor];
   [menuCloseButton setBackgroundImage: menuButtonCloseImage forState:UIControlStateNormal];
   [menuCloseButton setTintColor:[UIColor whiteColor]];
    
   UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeMenu:)];
   [menuCloseButton addGestureRecognizer:tapGestureRecognizer];

   [menuHeader addSubview: menuCloseButton];
    
   //Menu scrollView
   menuScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, menuHeader.self.bounds.size.height, self.bounds.size.width, self.bounds.size.height - menuHeader.self.bounds.size.height)];

   //menuScrollView.backgroundColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:0.75];

   [self addSubview:menuScrollView];
   [self setScrollViewRef:menuScrollView];

   //Menu borders
   menuTopBorder = [[UIView alloc]initWithFrame:CGRectMake(0, -2.5, self.bounds.size.width, 2.5)];
   menuTopBorder.backgroundColor = [UIColor greenColor];
   [self addSubview:menuTopBorder];

   menuLeftBorder = [[UIView alloc]initWithFrame:CGRectMake(-2.5, -2.5, 2.5, self.bounds.size.height + 5)];
   menuLeftBorder.backgroundColor = [UIColor greenColor];
   [self addSubview: menuLeftBorder];

   menuRightBorder = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.size.width, -2.5, 2.5, self.bounds.size.height + 5)];
   menuRightBorder.backgroundColor = [UIColor greenColor];
   [self addSubview: menuRightBorder];

   menuBottomBorder = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 2.5)];
   menuBottomBorder.backgroundColor = [UIColor greenColor];
   [self addSubview: menuBottomBorder];

   menuHeaderBottomBorder = [[UIView alloc]initWithFrame:CGRectMake(0, menuHeader.self.bounds.size.height - 0.625, self.bounds.size.width, 1.25)];
   menuHeaderBottomBorder.backgroundColor = [UIColor greenColor];
   [menuHeader addSubview: menuHeaderBottomBorder];

   //Create the pages list
   _Pages = [[NSMutableArray alloc] init];
   _CurrentPage = 1;
   return self;
}

@end