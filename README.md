*This project is a part of [The SOOMLA Project](http://project.soom.la) which is a series of open source initiatives with a joint goal to help mobile game developers get better stores and more in-app purchases.*

Didn't you ever wanted an in-app purchase one liner that looks like this ?!

```objective-c
    [[StoreController getInstance] buyCurrencyPackWithProcuctId:@"[Your product id here]"]
```

ios-store
---
The ios-store is our ios-falvored code initiative part of The SOOMLA Project. It is an iOS SDK that simplifies the App Store's in-app purchasing API and complements it with storage, security and event handling. The project also includes a sample app for reference. As an optional (and currently EXPERIMENTAL) part of our open-source projects you can also get the storefront's theme which you can customize with your own game's assets. To use our storefront, refer to [Get your own Storefront](https://github.com/soomla/ios-store/wiki/Get-your-own-Storefront-%5BEXPERIMENTAL%5D).


Check out our [Wiki] (https://github.com/soomla/ios-store/wiki) for more information about the project and how to use it better.

Getting Started (using source code)
---

#### **WE USE ARC !**


* Before doing anything, SOOMLA recommends that you go through [Selling with In-App Purchase](https://developer.apple.com/appstore/in-app-purchase/index.html).

1. Clone ios-store. Copy all files from ../ios-store/SoomlaiOSStore/SoomlaiOSStore into your iOS project:

 `git clone git@github.com:soomla/ios-store.git`

2. We use JSONKit but it doesn't use ARC. Go to your project's "Build Phases" and expand "Compile Sources". Add the flag "-fno-objc-arc" to the file JSONKit.m.

3. Make sure you have the following frameworks in your application's project: **Security, libsqlite3.0.dylib, StoreKit**.

4. Create your own implementation of _IStoreAssets_ in order to describe your specific game's assets. Initialize _StoreController_ with the class you just created:

      ```objective-c
       [[StoreController getInstance] initializeWithStoreAssets:[[MuffinRushAssets alloc] init]];
      ```

5. Now, that you have StoreController loaded, just decide when you want to show/hide your store's UI to the user and let StoreController know about it:

When you show the store call:

```objective-c
    [[StoreController getInstance] storeOpening];
```

When you hide the store call:

```objective-c
    [[StoreController getInstance] storeClosing];
```

And that's it ! You have Storage and in-app purchesing capabilities... ALL-IN-ONE.

Getting Started (using static library)
---

#### **WE USE ARC !**


* Before doing anything, SOOMLA recommends that you go through [Selling with In-App Purchase](https://developer.apple.com/appstore/in-app-purchase/index.html).

1. Download SoomlaiOSStore.zip and unpack it.

2. Add libSoomlaiOSStore.a and add it to your project's library dependencies. Add SooomlaiOSStore headers forder to your project as a source folder.

3. Got to your project's "Build Phases" and set the value "-ObjC" for the key "Other Linker Flags".

4. Go through steps 3-5 from [Getting Started (using source code)](https://github.com/soomla/ios-store#getting-started-using-source-code).

What's next? In App Purchasing.
---

ios-store provides you with VirtualCurrencyPacks. VirtualCurrencyPack is a representation of a "bag" of currencies that you want to let your users purchase in the App Store. You define VirtualCurrencyPacks in your game specific assets file which is your implemetation of IStoreAssets ([example](https://github.com/soomla/ios-store/blob/master/SoomlaiOSStoreExamples/MuffinRush/MuffinRush/MuffinRushAssets.m)). After you do that you can call StoreController to make actual purchases and ios-store will take care of the rest.

Example:

Lets say you have a VirtualCurrencyPack you call TEN_COINS_PACK, a VirtualCurrency you call COIN_CURRENCY and a VirtualCategory you call CURRENCYPACKS_CATEGORY:

```objective-c
VirtualCurrencyPack* TEN_COINS_PACK = [[VirtualCurrencyPack alloc] initWithName:@"10 Coins"
                                              andDescription:@"A pack of 10 coins"
                                              andImgFilePath:@"themes/awsomegame/img/coins/10_coins.png"
                                                   andItemId:@"10_coins"
                                                    andPrice:0.99
                                                andProductId:TEN_COINS_PACK_PRODUCT_ID
                                           andCurrencyAmount:10
                                                 andCurrency:COIN_CURRENCY
                                                 andCategory:CURRENCYPACKS_CATEGORY];
```

Now you can use StoreController to call the App Store's in-app purchasing mechanism:

```objective-c
    [[StoreController getInstance] buyCurrencyPackWithProcuctId:TEN_COINS_PACK.productId];
```

And that's it! ios-store knows how to contact the App Store for you and redirect the user to the purchasing mechanis. Don't forget to define your IStoreEventHandler in order to get the events of successful or failed purchase (see [Event Handling](https://github.com/soomla/ios-store#event-handling)).

Storage & Meta-Data
---

When you initialize _StoreController_, it automatically initializes two other classes: StorageManager and StoreInfo. _StorageManager_ is the father of all stoaage related instances in your game. Use it to access tha balances of virtual currencies and virtual goods (ususally, using their itemIds). _StoreInfo_ is the mother of all meta data information about your specific game. It is initialized with your implementation of IStoreAssets and you can use it to retrieve information about your specific game.

The on-device storage is encrypted and kept in a SQLite database. SOOMLA is preparing a cloud-based storage service that'll allow this SQLite to be synced to a cloud-based repository that you'll define. Stay tuned... this is just one of the goodies we prepare for you.

**Example Usages**

* Add 10 coins to the virtual currency with itemId "currency_coin":

    ```objective-c
    VirtualCurrency* coin = [[StoreInfo getInstance] currencyWithItemId:@"currency_coin"];
    [[[StorageManager getInstance] virtualCurrencyStorage] addAmount:10 toCurrency:coin];
    ```
    
* Remove 10 virtual goods with itemId "green_hat":

    ```objective-c
    VirtualGood* greenHat = [[StoreInfo getInstance] goodWithItemId:@"green_hat"];
    [[[StorageManager getInstance] virtualGoodStorage] removeAmount:10 fromGood:greenHat];
    ```
    
* Get the current balance of green hats (virtual goods with itemId "green_hat"):

    ```objective-c
    VirtualGood* greenHat = [[StoreInfo getInstance] goodWithItemId:@"green_hat"];
    int greenHatsBalance = [[[StorageManager getInstance] virtualGoodStorage] getBalanceForGood:greenHat];
    ```
    
Security
---

If you want to protect your application from 'bad people' (and who doesn't?!), you might want to follow some guidelines:

+ SOOMLA keeps the game's data in an encrypted database. In order to encrypt your data, SOOMLA generates a private key out of several parts of information. StoreConfig's STORE_CUSTOM_SECRET is one of them. SOOMLA recommends that you change this value before you release your game. BE CAREFUL: You can change this value once! If you try to change it again, old data from the database will become unavailable.


Event Handling
---

SOOMLA lets you get notifications on various events and implement your own application specific behaviour.

NOTE: Your behaviour is an addition to the default behaviour implemented by SOOMLA. You don't replace SOOMLA's behaviour.

In order to observe store events you need to import EventHandling.h and than you can add a notification to *NSNotificationCenter*:

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourCustomSelector:) name:EVENT_VIRTUAL_CURRENCY_PACK_PURCHASED object:nil];
    
OR, you can observe all events with the same selector by calling:

    [EventHandling observeAllEventsWithObserver:self withSelector:@selector(yourCustomSelector:)];

Our way of saying "Thanks !"
---

Other open-source projects that we use:

* [FBEncryptor](https://github.com/dev5tec/FBEncryptor)
* [JSONKit](https://github.com/johnezang/JSONKit)
* [UIDevice-with-UniqueIdentifier-for-iOS-5](https://github.com/gekitz/UIDevice-with-UniqueIdentifier-for-iOS-5)

Contribution
---

We want you!

Fork -> Clone -> Implement -> Test -> Pull-Request. We have great RESPECT for contributors.

SOOMLA, Elsewhere ...
---

+ [Website](http://project.soom.la/)
+ [On Facebook](https://www.facebook.com/pages/The-SOOMLA-Project/389643294427376).
+ [On AngelList](https://angel.co/the-soomla-project)

License
---
MIT License. Copyright (c) 2012 SOOMLA. http://project.soom.la
+ http://www.opensource.org/licenses/MIT

