//
//  ViewController.m
//  ZXing二维码1-5
//
//  Created by dc004 on 16/1/5.
//  Copyright © 2016年 gang. All rights reserved.
//

#import "ViewController.h"
#import <ZXingObjC.h>
@interface ViewController ()
{
    UIImage *imageResult;
    UIImageView *imageView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self encoding];
    [self decoding];
    [self layout];
}
-(void)layout{
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(152, 230, 60, 60)];
    imageView.image = [UIImage imageNamed:@"胡歌"];
    [self.view addSubview:imageView];
}

//Quick Response Code
#pragma mark 编码
- (void)encoding{
    NSError *error = nil;
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:@"http://weixin.qq.com/r/Plt4YArE3FejrU4D9w4s"
                                  format:kBarcodeFormatQRCode
                                   width:500
                                  height:500
                                   error:&error];
     if (result) {
        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
        
        imageResult = [UIImage imageWithCGImage:image];
        UIImageView *result = [[UIImageView alloc]initWithFrame:CGRectMake(20, 100, 345, 345)];
         result.backgroundColor = [UIColor redColor];
        result.image = imageResult;
        [self.view addSubview:result];
    } else {
        NSString *errorMessage = [error localizedDescription];
        NSLog(@"出错：%@",errorMessage);
    }
}

#pragma mark 解码
- (void)decoding{
    CGImageRef imageToDecode = [imageResult CGImage];  // Given a CGImage in which we are looking for barcodes
    
    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
    ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    
    NSError *error = nil;
    
    // There are a number of hints we can give to the reader, including
    // possible formats, allowed lengths, and the string encoding.
    ZXDecodeHints *hints = [ZXDecodeHints hints];
    
    ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
    ZXResult *result = [reader decode:bitmap
                                hints:hints
                                error:&error];
    if (result) {
        // The coded result as a string. The raw data can be accessed with
        // result.rawBytes and result.length.
        NSString *contents = result.text;
        NSLog(@"二维码结果：%@",contents);
        // The barcode format, such as a QR code or UPC-A
        ZXBarcodeFormat format = result.barcodeFormat;
        NSLog(@"该码格式为：%u", format);
    } else {
        // Use error to determine why we didn't get a result, such as a barcode
        // not being found, an invalid checksum, or a format inconsistency.
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
