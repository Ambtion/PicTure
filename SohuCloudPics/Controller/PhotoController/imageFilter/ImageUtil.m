//
//  RootViewController.h
//  pictureProcess
//
//  Created by Ibokan on 12-9-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ImageUtil.h"
#import "ColorMatrix.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import "UIImage+ExternScale.h"

@implementation ImageUtil

static CGContextRef CreateRGBABitmapContext (CGImageRef inImage)// 返回一个使用RGBA通道的位图上下文 
{
	CGContextRef context = NULL; 
	CGColorSpaceRef colorSpace; 
	void *bitmapData; //内存空间的指针，该内存空间的大小等于图像使用RGB通道所占用的字节数。
	int bitmapByteCount; 
	int bitmapBytesPerRow;
    
	size_t pixelsWide = CGImageGetWidth(inImage); //获取横向的像素点的个数
	size_t pixelsHigh = CGImageGetHeight(inImage); //纵向
    
	bitmapBytesPerRow	= (pixelsWide * 4); //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit(0-255)的空间
	bitmapByteCount	= (bitmapBytesPerRow * pixelsHigh); //计算整张图占用的字节数
    
	colorSpace = CGColorSpaceCreateDeviceRGB();//创建依赖于设备的RGB通道
	
	bitmapData = malloc(bitmapByteCount); //分配足够容纳图片字节数的内存空间
    
	context = CGBitmapContextCreate (bitmapData, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
    
    //创建CoreGraphic的图形上下文，该上下文描述了bitmaData指向的内存空间需要绘制的图像的一些绘制参数
	CGColorSpaceRelease( colorSpace ); 
    //Core Foundation中通过含有Create、Alloc的方法名字创建的指针，需要使用CFRelease()函数释放

	return context;
}

+(UIImage*)imageWithImage:(UIImage*)inImage withColorMatrix:(const float*) f
{
    CGContextRef context = NULL;
	CGColorSpaceRef colorSpace;
	void *bitmapData; //内存空间的指针，该内存空间的大小等于图像使用RGB通道所占用的字节数。
	int bitmapByteCount;
	int bitmapBytesPerRow;
    
	size_t pixelsWide = CGImageGetWidth(inImage.CGImage); //获取横向的像素点的个数
	size_t pixelsHigh = CGImageGetHeight(inImage.CGImage); //纵向
    
	bitmapBytesPerRow	= (pixelsWide * 4); //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit(0-255)的空间
	bitmapByteCount	= (bitmapBytesPerRow * pixelsHigh); //计算整张图占用的字节数
    
	colorSpace = CGColorSpaceCreateDeviceRGB();//创建依赖于设备的RGB通道
	
	bitmapData = malloc(bitmapByteCount); //分配足够容纳图片字节数的内存空间
    

	context = CGBitmapContextCreate (bitmapData, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
    //创建CoreGraphic的图形上下文，该上下文描述了bitmaData指向的内存空间需要绘制的图像的一些绘制参数
	CGColorSpaceRelease( colorSpace );
    //Core Foundation中通过含有Create、Alloc的方法名字创建的指针，需要使用CFRelease()函数释放
    
    CGSize size = inImage.size;
    CGRect rect = {{0,0},{size.width, size.height}};
	CGContextDrawImage(context, rect, inImage.CGImage); //将目标图像绘制到指定的上下文，实际为上下文内的bitmapData。
    unsigned char *data = CGBitmapContextGetData (context);
    
    
    
    CGImageRef inImageRef = [inImage CGImage];
	GLuint w = CGImageGetWidth(inImageRef);
	GLuint h = CGImageGetHeight(inImageRef);
    
    GLuint xsize = w * h;
    for (GLuint i = 0; i < xsize; ++i) {
        unsigned int point = ((unsigned int *) data)[i];
        changeRGBA(&point, f);
        ((unsigned int *) data)[i] = point;
    }
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage * F_image = [UIImage imageWithCGImage:imageRef];
    free(bitmapData);
    CGContextRelease(context);
    CGImageRelease(imageRef);
//    NSLog(@"end");
    return F_image;

}
+ (NSString*)getImagePath
{
    
    NSString * outputPath = [[NSString alloc] initWithFormat:@"%@/Documents/%@",NSHomeDirectory(), @"tmpImage.png"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:outputPath])
    {
        NSError *error;
        if ([fileManager removeItemAtPath:outputPath error:&error] == NO)
        {
            //Error - handle if requried
        }
    }
    return [outputPath autorelease];
}
+ (UIImage*)imageWithImage:(UIImage*)inImage withMatrixNum:(NSInteger) num
{
    if (num == 7) {
        return [self imageWithFilterImage:inImage];
    }
    float * matrix = (float *)[self getFiltername:num];
    if (matrix ) {
        return [self imageWithImage:inImage withColorMatrix:(float*)[self getFiltername:num]];
    }
    return nil;
}
+ (UIImage *)imageWithFilterImage:(UIImage*)inimage
{
    
    // 得到图片路径创建CIImage对象
    UIImage * image = [ImageUtil imageWithImage:inimage withColorMatrix:colormatrix_heibai];
    CIImage * ci_image = [CIImage imageWithCGImage:image.CGImage];
    
    UIImage * bgimage = [UIImage imageNamed:@"bg-filter.png"];
    bgimage = [self imageByScaling:bgimage :inimage.size];
    CIImage * ci_bgimage = [CIImage imageWithCGImage:bgimage.CGImage];
    
    // 创建基于GPU的CIContext对象
    CIContext* context = [CIContext contextWithOptions: nil];
    // 创建基于CPU的CIContext对象
    //context = [CIContext contextWithOptions: [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:kCIContextUseSoftwareRenderer]];
    CIFilter* filter2 = [CIFilter filterWithName:@"CIHighlightShadowAdjust"];
    [filter2 setValue:ci_image forKey:@"inputImage"];
    [filter2 setValue:[NSNumber numberWithFloat:0.9] forKey:@"inputShadowAmount"];
    [filter2 setValue:[NSNumber numberWithFloat:0.3] forKey:@"inputHighlightAmount"];
    CIFilter* filter = [CIFilter filterWithName:@"CIColorDodgeBlendMode"];

    [filter setValue:[filter2 outputImage] forKey:@"inputImage"];
    
    [filter setValue:ci_bgimage forKey:@"inputBackgroundImage"];

    // 得到过滤后的图片
    CIImage *outputImage = [filter outputImage];
    // 转换图片

    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg]; 
    CGImageRelease(cgimg);
    return newImg;
    
}
+(UIImage*)imageByScaling:(UIImage*)source :(CGSize)targetsize
{
    UIGraphicsBeginImageContext(targetsize);
    [source drawInRect:CGRectMake(0,0,targetsize.width, targetsize.height)];
    UIImage * newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
}
+ (UIImage *) normalize:(UIImage*)source {
    
    CGColorSpaceRef genericColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef thumbBitmapCtxt = CGBitmapContextCreate(NULL,
                                                         source.size.width,
                                                         source.size.height,
                                                         8, (4 * source.size.width),
                                                         genericColorSpace,
                                                         kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(genericColorSpace);
    CGContextSetInterpolationQuality(thumbBitmapCtxt, kCGInterpolationDefault);
    CGRect destRect = CGRectMake(0, 0, source.size.width, source.size.height);
    CGContextDrawImage(thumbBitmapCtxt, destRect, source.CGImage);
    CGImageRef tmpThumbImage = CGBitmapContextCreateImage(thumbBitmapCtxt);
    CGContextRelease(thumbBitmapCtxt);   
    UIImage *result = [UIImage imageWithCGImage:tmpThumbImage];
    CGImageRelease(tmpThumbImage);
    
    return result;   
}
+ (UIImage*) image:(UIImage*) source stackBlur:(NSUInteger)inradius
{
    
	int radius=inradius; // Transform unsigned into signed for further operations
	
	if (radius<1){
		return nil;
	}
    // Suggestion xidew to prevent crash if size is null
	if (CGSizeEqualToSize(source.size, CGSizeZero)) {
        return nil;
    }
    
	// First get the image into your data buffer
    CGImageRef inImage = source.CGImage;
    int nbPerCompt=CGImageGetBitsPerPixel(inImage);
    if(nbPerCompt!=32){
        UIImage *tmpImage=[ImageUtil normalize:source];
        inImage=tmpImage.CGImage;
    }
	CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));  
    UInt8 * m_PixelBuf=malloc(CFDataGetLength(m_DataRef));
    CFDataGetBytes(m_DataRef,
                   CFRangeMake(0,CFDataGetLength(m_DataRef)) ,
                   m_PixelBuf);
	
	CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,  
											 CGImageGetWidth(inImage),  
											 CGImageGetHeight(inImage),  
											 CGImageGetBitsPerComponent(inImage),
											 CGImageGetBytesPerRow(inImage),  
											 CGImageGetColorSpace(inImage),  
											 CGImageGetBitmapInfo(inImage) 
											 );
    
	int w=CGImageGetWidth(inImage);
	int h=CGImageGetHeight(inImage);
	int wm=w-1;
	int hm=h-1;
	int wh=w*h;
	int div=radius+radius+1;
	
	int *r=malloc(wh*sizeof(int));
	int *g=malloc(wh*sizeof(int));
	int *b=malloc(wh*sizeof(int));
	memset(r,0,wh*sizeof(int));
	memset(g,0,wh*sizeof(int));
	memset(b,0,wh*sizeof(int));
    
	int rsum,gsum,bsum,x,y,i,p,yp,yi,yw;
	int *vmin = malloc(sizeof(int)*MAX(w,h));
	memset(vmin,0,sizeof(int)*MAX(w,h));
	int divsum=(div+1)>>1;
	divsum*=divsum;
	int *dv=malloc(sizeof(int)*(256*divsum));
	for (i=0;i<256*divsum;i++){
		dv[i]=(i/divsum);
	}
	
    
	yw=yi=0;
	int *stack=malloc(sizeof(int)*(div*3));
	int stackpointer;
	int stackstart;
	int *sir;
	int rbs;
	int r1=radius+1;
	int routsum,goutsum,boutsum;
	int rinsum,ginsum,binsum;
	memset(stack,0,sizeof(int)*div*3);
	
	for (y=0;y<h;y++){
        
		rinsum=ginsum=binsum=routsum=goutsum=boutsum=rsum=gsum=bsum=0;
		
		for(int i=-radius;i<=radius;i++){
            
			sir=&stack[(i+radius)*3];
        
			int offset=(yi+MIN(wm,MAX(i,0)))*4;
			sir[0]=m_PixelBuf[offset];
			sir[1]=m_PixelBuf[offset+1];
			sir[2]=m_PixelBuf[offset+2];
			
			rbs=r1-abs(i);
			rsum+=sir[0]*rbs;
			gsum+=sir[1]*rbs;
			bsum+=sir[2]*rbs;
			if (i>0){
				rinsum+=sir[0];
				ginsum+=sir[1];
				binsum+=sir[2];
			} else {
				routsum+=sir[0];
				goutsum+=sir[1];
				boutsum+=sir[2];
			}
		}
		stackpointer=radius;
		
		for (x=0;x<w;x++){
			r[yi]=dv[rsum];
			g[yi]=dv[gsum];
			b[yi]=dv[bsum];
			
			rsum-=routsum;
			gsum-=goutsum;
			bsum-=boutsum;
			
			stackstart=stackpointer-radius+div;
			sir=&stack[(stackstart%div)*3];
			
			routsum-=sir[0];
			goutsum-=sir[1];
			boutsum-=sir[2];
			
			if(y==0){
				vmin[x]=MIN(x+radius+1,wm);
			}
			
        
			int offset=(yw+vmin[x])*4;
			sir[0]=m_PixelBuf[offset];
			sir[1]=m_PixelBuf[offset+1];
			sir[2]=m_PixelBuf[offset+2];
			rinsum+=sir[0];
			ginsum+=sir[1];
			binsum+=sir[2];
			
			rsum+=rinsum;
			gsum+=ginsum;
			bsum+=binsum;
			
			stackpointer=(stackpointer+1)%div;
			sir=&stack[((stackpointer)%div)*3];
			
			routsum+=sir[0];
			goutsum+=sir[1];
			boutsum+=sir[2];
			
			rinsum-=sir[0];
			ginsum-=sir[1];
			binsum-=sir[2];
			
			yi++;
		}
		yw+=w;
	}
	for (x=0;x<w;x++){
		rinsum=ginsum=binsum=routsum=goutsum=boutsum=rsum=gsum=bsum=0;
		yp=-radius*w;
		for(i=-radius;i<=radius;i++){
			yi=MAX(0,yp)+x;
			
			sir=&stack[(i+radius)*3];
			
			sir[0]=r[yi];
			sir[1]=g[yi];
			sir[2]=b[yi];
			
			rbs=r1-abs(i);
			
			rsum+=r[yi]*rbs;
			gsum+=g[yi]*rbs;
			bsum+=b[yi]*rbs;
			
			if (i>0){
				rinsum+=sir[0];
				ginsum+=sir[1];
				binsum+=sir[2];
			} else {
				routsum+=sir[0];
				goutsum+=sir[1];
				boutsum+=sir[2];
			}
			
			if(i<hm){
				yp+=w;
			}
		}
		yi=x;
		stackpointer=radius;
		for (y=0;y<h;y++){
			int offset=yi*4;
			m_PixelBuf[offset]=dv[rsum];
			m_PixelBuf[offset+1]=dv[gsum];
			m_PixelBuf[offset+2]=dv[bsum];
			rsum-=routsum;
			gsum-=goutsum;
			bsum-=boutsum;
			
			stackstart=stackpointer-radius+div;
			sir=&stack[(stackstart%div)*3];
			
			routsum-=sir[0];
			goutsum-=sir[1];
			boutsum-=sir[2];
			
			if(x==0){
				vmin[y]=MIN(y+r1,hm)*w;
			}
			p=x+vmin[y];
			
			sir[0]=r[p];
			sir[1]=g[p];
			sir[2]=b[p];
			
			rinsum+=sir[0];
			ginsum+=sir[1];
			binsum+=sir[2];
			
			rsum+=rinsum;
			gsum+=ginsum;
			bsum+=binsum;
			
			stackpointer=(stackpointer+1)%div;
			sir=&stack[(stackpointer)*3];
			
			routsum+=sir[0];
			goutsum+=sir[1];
			boutsum+=sir[2];
			
			rinsum-=sir[0];
			ginsum-=sir[1];
			binsum-=sir[2];
			
			yi+=w;
		}
	}
	free(r);
	free(g);
	free(b);
	free(vmin);
	free(dv);
	free(stack);
	CGImageRef imageRef = CGBitmapContextCreateImage(ctx);  
	CGContextRelease(ctx);	
	
	UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);	
	CFRelease(m_DataRef);
    free(m_PixelBuf);
	return finalImage;
}

//static void changeRGBA(int *red,int *green,int *blue,int *alpha, const float* f)//修改RGB的值
static void changeRGBA(unsigned int *point, const float* f)//修改RGB的值
{
    //    int redV = *red;
    //    int greenV = *green;
    //    int blueV = *blue;
    //    int alphaV = *alpha;
    unsigned int pointV = *point;
    
    int redV = ((unsigned char *) &pointV)[0];
    int greenV = ((unsigned char *) &pointV)[1];
    int blueV = ((unsigned char *) &pointV)[2];
    int alphaV = ((unsigned char *) &pointV)[3];
    
    register int sred = f[0] * redV + f[1] * greenV + f[2] * blueV + f[3] * alphaV + f[4];
    register int sgreen = f[0+5] * redV + f[1+5] * greenV + f[2+5] * blueV + f[3+5] * alphaV + f[4+5];
    register int sblue = f[0+5*2] * redV + f[1+5*2] * greenV + f[2+5*2] * blueV + f[3+5*2] * alphaV + f[4+5*2];
    register int salpha = f[0+5*3] * redV + f[1+5*3] * greenV + f[2+5*3] * blueV + f[3+5*3] * alphaV + f[4+5*3];
    
    if (sred > 255)
    {
        sred = 255;
    }
    if(sred < 0)
    {
        sred = 0;
    }
    if (sgreen > 255)
    {
        sgreen = 255;
    }
    if (sgreen < 0)
    {
        sgreen = 0;
    }
    if (sblue > 255)
    {
        sblue = 255;
    }
    if (sblue < 0)
    {
        sblue = 0;
    }
    if (salpha > 255)
    {
        salpha = 255;
    }
    if (salpha < 0)
    {
        salpha = 0;
    }
    
    //    *red = sred;
    //    *green = sgreen;
    //    *blue = sblue;
    //    *alpha = salpha;
    ((unsigned char *) point)[0] = sred;
    ((unsigned char *) point)[1] = sgreen;
    ((unsigned char *) point)[2] = sblue;
    ((unsigned char *) point)[3] = salpha;
}
+(const float (* )[20])getFiltername:(NSInteger)num{
    switch (num) {
        case 0:
        {
            return &colormatrix_lomo;//LOMO
        }
            break;
        case 1:
        {
            return &colormatrix_heibai;//黑白
        }
            break;
        case 2:
        {
            return &colormatrix_gete;//哥特
            
        }
            break;
        case 3:
        {
            return &colormatrix_ruise;//锐色
            
        }
            break;
        case 4:
        {
            return &colormatrix_jiuhong;//酒红
            
        }
            break;
        case 5:
        {
            return &colormatrix_qingning;//清宁
            
        }
            break;
        case 6:
        {
            return &colormatrix_guangyun;//光晕
            
        }
            break;
            
        default:
            break;
    }
    return NULL;
}
static unsigned char *RequestImagePixelData(UIImage *inImage)
// 返回一个指针，该指针指向一个数组，数组中的每四个元素都是图像上的一个像素点的RGBA的数值(0-255)，用无符号的char是因为它正好的取值范围就是0-255
{
	CGImageRef img = [inImage CGImage];
	CGSize size = [inImage size];
	CGContextRef cgctx = CreateRGBABitmapContext(img); //使用上面的函数创建上下文
	CGRect rect = {{0,0},{size.width, size.height}};
	CGContextDrawImage(cgctx, rect, img); //将目标图像绘制到指定的上下文，实际为上下文内的bitmapData。
	unsigned char *data = CGBitmapContextGetData (cgctx);
	CGContextRelease(cgctx);//释放上面的函数创建的上下文
	return data;
}

//+(UIImage*)imageWithImage:(UIImage*)inImage withColorMatrix:(const float*) f
//{
//    NSLog(@"start1");
//	unsigned char * imgPixel = RequestImagePixelData(inImage);
//    NSLog(@"start2");
//
//	CGImageRef inImageRef = [inImage CGImage];
//	GLuint w = CGImageGetWidth(inImageRef);
//	GLuint h = CGImageGetHeight(inImageRef);
//
////	int wOff = 0;
////	int pixOff = 0;
//
//    NSLog(@"start3");
//
//    GLuint size = w * h;
//    for (GLuint i = 0; i < size; ++i) {
//        unsigned int point = ((unsigned int *) imgPixel)[i];
//        changeRGBA(&point, f);
//        ((unsigned int *) imgPixel)[i] = point;
//    }
//
////	for(GLuint y = 0;y< h;y++)//双层循环按照长宽的像素个数迭代每个像素点
////	{
////		pixOff = wOff;
////
////		for (GLuint x = 0; x<w; x++)
////		{
////            unsigned int point = *(unsigned int *)&imgPixel[pixOff];
//////			int red = (unsigned char)imgPixel[pixOff];
//////			int green = (unsigned char)imgPixel[pixOff+1];
//////			int blue = (unsigned char)imgPixel[pixOff+2];
//////          int alpha = (unsigned char)imgPixel[pixOff+3];
////
//////            changeRGBA(&red, &green, &blue, &alpha, f);
////            changeRGBA(&point, f);
////
////            //回写数据
//////			imgPixel[pixOff] = red;
//////			imgPixel[pixOff+1] = green;
//////			imgPixel[pixOff+2] = blue;
//////          imgPixel[pixOff+3] = alpha;
////            *(unsigned int *)&imgPixel[pixOff] = point;
////
////			pixOff += 4; //将数组的索引指向下四个元素
////		}
////		wOff += w * 4;
////	}
//    NSLog(@"start4");
//
//	NSInteger dataLength = w * h * 4;
//
//    //下面的代码创建要输出的图像的相关参数
//	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgPixel, dataLength, NULL);
//
//	int bitsPerComponent = 8;
//	int bitsPerPixel = 32;
//	int bytesPerRow = 4 * w;
//	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
//	CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
//	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
//
//
//	CGImageRef imageRef = CGImageCreate(w, h, bitsPerComponent, bitsPerPixel, bytesPerRow,colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);//创建要输出的图像
//    NSLog(@"start5");
//
//	UIImage * myImage = [UIImage imageWithCGImage:imageRef];
//	CFRelease(imageRef);
//	CGColorSpaceRelease(colorSpaceRef);
//	CGDataProviderRelease(provider);
//    NSLog(@"start6");
//
//    //write to file
////    NSString * outputPath = [[NSString alloc] initWithFormat:@"%@/Documents/%@",NSHomeDirectory(), @"tmpImage.png"];
//    NSData * data =  UIImagePNGRepresentation(myImage);
//    UIImage * newimage = [UIImage imageWithData:data];
//    NSLog(@"start7");
//
//    free(imgPixel);
//	return newimage;
//
//}
@end
