//
//  Cryptography.m
//  chronometer
//
//  Created by Giovani Ferreira Silvério da Silva on 14/04/15.
//  Copyright (c) 2015 Giovani Ferreira Silvério da Silva. All rights reserved.
//

#import "Cryptography.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation Cryptography

NSString* geraHash (NSString *senha, NSString *sal) {
  const char *cSalt = [sal cStringUsingEncoding:NSASCIIStringEncoding];
  const char *cData = [senha cStringUsingEncoding:NSASCIIStringEncoding];

  unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];

  CCHmac(kCCHmacAlgSHA256, cSalt, strlen(cSalt), cData, strlen(cData), cHMAC);

  NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];

  NSString *base64String = [HMAC base64EncodedStringWithOptions:0];

  return base64String;
}


- (instancetype)initWithPassword:(NSString*)psw{
  self = [super init];
  if (self) {
    self.sal = [NSString stringWithFormat:@"%@", [self getRandomBytes:64]];
    self.password = geraHash(psw, self.sal);
  }
  return self;
}

- (instancetype)initComSenha:(NSString *)senha eSal:(NSString *)sal {
  self = [super init];
  if (self) {
    self.sal = sal;
    self.password = geraHash(senha, self.sal);
  }
  return self;
}

-(NSData *)getRandomBytes:(NSUInteger)length {
  return [[NSFileHandle fileHandleForReadingAtPath:@"/dev/random"] readDataOfLength:length];
}

- (NSString *)description{
  return [NSString stringWithFormat:@"%@", self.password];
}

-(BOOL)autenticaSenha:(NSString *)senha sal:(NSString *)sal {
  NSString* hashCandidata = geraHash(senha, sal);
  return [hashCandidata isEqualToString:self.password];
}

@end
