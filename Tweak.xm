#include <stdio.h>
#include <math.h>

#import "UIKit/UIKit.h"

#import "Menu.h"
#import "Page.h"
#import "MenuItem.h"
#import "ToggleItem.h"
#import "PageItem.h"
#import "SliderItem.h"
#import "TextfieldItem.h"
#import "InvokeItem.h"

#import "Utils.h"

#define timer(sec) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec * NSEC_PER_SEC), dispatch_get_main_queue(), ^

static Menu *menu;

void TestFunction(){
   //Make sure we're able to detect if all kind of togglable items are on/off
   BOOL textfield1_isOn = [menu isItemOn:@"Textfield Hack 1"];
   BOOL slider1_isOn = [menu isItemOn:@"Slider Hack 1"];
   BOOL toggle1_isOn = [menu isItemOn:@"Toggle Hack 1"];

   showPopup(@"textfield1 isOn :", @(textfield1_isOn).stringValue);
   showPopup(@"slider1 isOn :", @(slider1_isOn).stringValue);
   showPopup(@"toggle1 isOn :", @(toggle1_isOn).stringValue);

   //Make sure we can read all kind of values from textfield and slider items
   NSString *textfield_text = [menu getTextfieldValue:@"Textfield Hack 1"];
   int textfield_int = [[menu getTextfieldValue:@"Textfield Hack 2"] intValue];
   float textfield_float = [[menu getTextfieldValue:@"Textfield Hack 3"] floatValue];
   int slider_int = (int)[menu getSliderValue:@"Slider Hack 1"];
   float slider_float = [menu getSliderValue:@"Slider Hack 2"];

   showPopup(@"textfield1 string value :", textfield_text);
   showPopup(@"textfield2 int value :", @(textfield_int).stringValue);
   showPopup(@"textfield3 float value :", @(textfield_float).stringValue);
   showPopup(@"slider1 int value :", @(slider_int).stringValue);
   showPopup(@"slider2 float value :", @(slider_float).stringValue);
}


void initMenu(){
	//Create the menu
	menu = [[Menu alloc] initMenu];

	//Items titles must be unique
	//initWithTitle could be used to instanciate the items instead of setting all properties manually, that way we won't forget to set any property

	//Page 1
	//Create items
	ToggleItem *myItem = [[ToggleItem alloc] init];
	myItem.Title = @"Toggle Hack 1";
	myItem.Description = @"This is a description 1";
	myItem.IsOn = NO;

	ToggleItem *myItem2 = [[ToggleItem alloc] init];
	myItem2.Title = @"Toggle Hack 2";
	myItem2.Description = @"This is a description 2";
	myItem2.IsOn = NO;

	PageItem *myItem3 = [[PageItem alloc] init];
	myItem3.Title = @"Submenu 1";
	myItem3.TargetPage = 2;

		///////////////
		//Submenu 1 (page 2)
		ToggleItem *myItem6 = [[ToggleItem alloc] init];
		myItem6.Title = @"Toggle Hack 5";
		myItem6.Description = @"This is a description 5";
		myItem6.IsOn = NO;

		ToggleItem *myItem7 = [[ToggleItem alloc] init];
		myItem7.Title = @"Toggle Hack 6";
		myItem7.Description = @"This is a description 6";
		myItem7.IsOn = NO;

		SliderItem *myItem12 = [[SliderItem alloc] init];
		myItem12.Title = @"Slider Hack 1";
		myItem12.Description = @"This is a description slider 1";
		myItem12.IsOn = NO;
		myItem12.IsFloating = NO;
		myItem12.DefaultValue = 0.0f;
		myItem12.MinValue = 0.0f;
		myItem12.MaxValue = 100.0f;

		SliderItem *myItem13 = [[SliderItem alloc] init];
		myItem13.Title = @"Slider Hack 2";
		myItem13.Description = @"This is a description slider 2";
		myItem13.IsOn = NO;
		myItem13.IsFloating = YES;
		myItem13.DefaultValue = 50.0f;
		myItem13.MinValue = 0.0f;
		myItem13.MaxValue = 100.0f;

		//Create the page & add items
		Page *page2 = [[Page alloc] initWithPageNumber: 2 parentPage: 1];
		[page2 addItem: myItem6];
		[page2 addItem: myItem7];
		[page2 addItem: myItem12];
		[page2 addItem: myItem13];

		//Add the page to the menu
		[menu addPage: page2];

	ToggleItem *myItem4 = [[ToggleItem alloc] init];
	myItem4.Title = @"Toggle Hack 3";
	myItem4.Description = @"This is a description 3";
	myItem4.IsOn = NO;

	ToggleItem *myItem5 = [[ToggleItem alloc] init];
	myItem5.Title = @"Toggle Hack 4";
	myItem5.Description = @"This is a description 4";
	myItem5.IsOn = NO;

	TextfieldItem *myItem15 = [[TextfieldItem alloc] init];
	myItem15.Title = @"Textfield Hack 1";
	myItem15.Description = @"This is a texfield 1";
	myItem15.IsOn = NO;
	myItem15.DefaultValue = @"hello";

	TextfieldItem *myItem16 = [[TextfieldItem alloc] init];
	myItem16.Title = @"Textfield Hack 2";
	myItem16.Description = @"This is a texfield 2";
	myItem16.IsOn = NO;
	myItem16.DefaultValue = @"2";

	TextfieldItem *myItem17 = [[TextfieldItem alloc] init];
	myItem17.Title = @"Textfield Hack 3";
	myItem17.Description = @"This is a texfield 3";
	myItem17.IsOn = NO;
	myItem17.DefaultValue = @"2.2734";

	InvokeItem *myItem18 = [[InvokeItem alloc] init];
	myItem18.Title = @"Invoke Hack 1";
	myItem18.Description = @"This is an invoke hack 1 to test all functions that get values";
	myItem18.FunctionPtr = &TestFunction;

	PageItem *myItem8 = [[PageItem alloc] init];
	myItem8.Title = @"Submenu 2";
	myItem8.TargetPage = 3;

		///////////////
		//Submenu 2 (page 3)
		//Create the page & add items
		Page *page3 = [[Page alloc] initWithPageNumber: 3 parentPage: 1];

		ToggleItem *myItem9 = [[ToggleItem alloc] init];
		myItem9.Title = @"Toggle Hack 7";
		myItem9.Description = @"This is a description 7";
		myItem9.IsOn = NO;

		PageItem *myItem10 = [[PageItem alloc] init];
		myItem10.Title = @"Submenu 3";
		myItem10.TargetPage = 4;

		SliderItem *myItem14 = [[SliderItem alloc] init];
		myItem14.Title = @"Slider Hack 3";
		myItem14.Description = @"This is a description slider 3";
		myItem14.IsOn = NO;
		myItem14.IsFloating = YES;
		myItem14.DefaultValue = 30.48f;
		myItem14.MinValue = 0.0f;
		myItem14.MaxValue = 100.0f;

			///////////////
			//Submenu 3 (page 4)
			ToggleItem *myItem11 = [[ToggleItem alloc] init];
			myItem11.Title = @"Toggle Hack 8";
			myItem11.Description = @"This is a description 8";
			myItem11.IsOn = NO;

			//Create the page & add items
			Page *page4 = [[Page alloc] initWithPageNumber: 4 parentPage: 3];
			[page4 addItem: myItem11];

			//Add the page to the menu
			[menu addPage: page4];

		[page3 addItem: myItem9];
		[page3 addItem: myItem10];
		[page3 addItem: myItem14];

		//Add the page to the menu
		[menu addPage: page3];

	//Create the page & add items
	Page *page1 = [[Page alloc] initWithPageNumber: 1 parentPage: 1];
	[page1 addItem: myItem];
	[page1 addItem: myItem2];
	[page1 addItem: myItem3];
	[page1 addItem: myItem4];
	[page1 addItem: myItem5];
	[page1 addItem: myItem8];
	[page1 addItem: myItem15];
	[page1 addItem: myItem16];
	[page1 addItem: myItem17];
	[page1 addItem: myItem18];

	//Add the page to the menu
	[menu addPage: page1];

	///////////////
	///////////////
	[menu setUserDefaultsAndDict]; //This sets the user's previously choosen values on the items objects. it also creates a dictionnary of items. we're gonna have to access alot so it prevent looping all of them
	[menu loadPage: 1]; //This isnt an index
}

static void didFinishLaunching(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef info) {
	timer(4) {
		initMenu();
	});
}

%ctor {
CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(), 
									NULL, 
									&didFinishLaunching, 
									(CFStringRef)UIApplicationDidFinishLaunchingNotification, 
									NULL, 
									CFNotificationSuspensionBehaviorDeliverImmediately);
}