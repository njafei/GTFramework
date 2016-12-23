//
//  MacroDef.h
//  Demo4GT
//
//  Created by  on 13-6-6.
//  Copyright ©[Insert Year of First Publication] - 2014 Tencent.All Rights Reserved. This software is licensed under the terms in the LICENSE.TXT file that accompanies this software.
//

#undef	M_AS_SINGLETION
#define M_AS_SINGLETION( __class ) \
+ (__class *)sharedInstance;

#undef	M_DEF_SINGLETION
#define M_DEF_SINGLETION( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}
