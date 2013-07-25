//
//  WPTableImageSource.h
//  WordPress
//
//  Created by Jorge Bernal on 6/19/13.
//  Copyright (c) 2013 WordPress. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WPTableImageSourceDelegate;

/**
 WPTableImageSource downloads images to include in a UITableView
 
 It uses the [Photon API](http://developer.wordpress.com/docs/photon/) to resize images to the maximum expected display size to save bandwidth. Then it resizes them locally if a smaller size is needed.
 
 The rationale is that you might need different image sizes for portrait and landscape (or different layouts), so you want exact sizes to avoid having CoreGraphics scaling images for smoother scrolling. At the same time, you don't want to have to fetch a slightly bigger image when the user rotates to landscape, and definitely you don't want to download a 10 megapixel image when you plan to display it at 300x200.
 
 All the downloading and image resizing is done in background queues, so blocking of the main thread should be minimal. You can expect the delegate methods to be called on the main thread
 */
@interface WPTableImageSource : NSObject

/**
 Maximum expected size to display images
 
 @see initWithMaxSize:
 */
@property (readonly, assign) CGSize maxSize;

/**
 The delegate for the image source
 */
@property (nonatomic, weak) id<WPTableImageSourceDelegate> delegate;

/**
 Initializes the object with the maximum expected image size

 @param size the maximum expected size
 @see maxSize
 */
- (id)initWithMaxSize:(CGSize)size;

/**
 If YES, the image source will resize images on the fly if it has a larger version available.
 Otherwise, you'll need to call fetchImageForURL:withSize:indexPath:andTag: and images will be resized on a background queue
 */
@property (nonatomic, assign) BOOL resizesImagesSynchronously;

/**
 Returns an image if there's a valid cached copy

 If resizesImagesSynchronously is set to YES and there is a cached image with a different size, it will be resized and returned.
 Otherwise it will return `nil`. You are expected to call fetchImageForURL:withSize:indexPath: if you need an image that's not in the cache
 
 @param url the URL for the image.
 @param size what size you are planning to display the image.
 @return the image if a cached version was found, or `nil` otherwise.
 */
- (UIImage *)imageForURL:(NSURL *)url withSize:(CGSize)size;

/**
 Downloads an image at the specified URL

 If `size` is smaller than the `maxSize` property, the larger one will be downloaded and resized

 @param url the URL for the image.
 @param size what size you are planning to display the image.
 @param indexPath the indexPath for the cell that wants this image.
 @param isPrivate if the image is hosted on a private blog. photon will be skipped for private blogs. 
*/
- (void)fetchImageForURL:(NSURL *)url withSize:(CGSize)size indexPath:(NSIndexPath *)indexPath isPrivate:(BOOL)isPrivate;

/**
 Invalidates stored index paths.
 
 Calling this method doesn't cancel the image requests, but prevents them from calling the delegate.
 */
- (void)invalidateIndexPaths;

@end

/**
 The WPTableImageSourceDelegate protocol describes methods that should be implemented by the delegate for an instance of WPTableImageSource.
 */
@protocol WPTableImageSourceDelegate <NSObject>

/**
 Sent when the requested image has been downloaded, and resized (if necessary)
 
 @param tableImageSource the image source sending the message.
 @param image the image requested.
 @param indexPath the indexPath passed in fetchImageForURL:withSize:indexPath:.
*/
- (void)tableImageSource:(WPTableImageSource *)tableImageSource imageReady:(UIImage *)image forIndexPath:(NSIndexPath *)indexPath;

@end
