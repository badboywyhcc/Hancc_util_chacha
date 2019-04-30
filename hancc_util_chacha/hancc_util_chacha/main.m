//
//  main.m
//  hancc_util_chacha
//
//  Created by 韩帆 on 2019/4/29.
//  Copyright © 2019 hancc. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "hancc_alloc_util.h"
#include "hancc_json_util.h"
#include <stdlib.h>
#include "cJSON.h"



#pragma pack(push) // 将当前pack设置压栈保存
#pragma pack(1) // 必须在结构体定义之前使用
typedef struct{
    uint8     Frame_flag;            //  1.协议头
    uint16    Frame_dataLen;         //  2.数据长度
    uint8     Frame_version;         //  1.协议版本号
    uint16    Frame_packetNum;       //  2.帧序
    uint16    Frame_command;         //  2.命令
    uint8     *Frame_dataBody;       //  N.有效数据区
    uint16    Frame_CRC16;           //  2.CRC校验
}universalCommunicateFrame;
#pragma pack(pop)






/*
 *  描述: 将字符串转化为16进制数数组
 *  parameter(s): [OUT] pbDest - 输出缓冲区
 *  [IN] pbSrc - 字符串
 *  [IN] nLen - 16进制数的字节数(字符串的长度/2)
 *  return value:
 */
void StrToHex(unsigned char *pbDest, unsigned char *pbSrc, int nLen)
{
    char h1,h2;
    unsigned char s1,s2;
    int i;
    
    for (i=0; i<nLen; i++)
    {
        h1 = pbSrc[2*i];
        h2 = pbSrc[2*i+1];
        
        s1 = toupper(h1) - 0x30;
        if (s1 > 9)
            s1 -= 7;
        
        s2 = toupper(h2) - 0x30;
        if (s2 > 9)
            s2 -= 7;
        
        pbDest[i] = s1*16 + s2;
    }
}

/*
 *  描述: 将16进制数数据转化为字符串
 *  pbDest - 存放目标字符串
 *  [IN] pbSrc - 输入16进制数的起始地址
 *  [IN] nLen - 16进制数的字节数
 *  return value:
 */
void HexToStr(unsigned char *pbDest, unsigned char *pbSrc, int nLen)
{
    char    ddl,ddh;
    int i;
    
    for (i=0; i<nLen; i++)
    {
        ddh = 48 + pbSrc[i] / 16;
        ddl = 48 + pbSrc[i] % 16;
        if (ddh > 57) ddh = ddh + 7;
        if (ddl > 57) ddl = ddl + 7;
        pbDest[i*2] = ddh;
        pbDest[i*2+1] = ddl;
    }
    
    pbDest[nLen*2] = '\0';
}




















void cJSON_test1(){
    char *data = "{\"love\":[\"LOL\",\"Go shopping\"]}";
    printf("长度:%ld\n",strlen(data));
    
    //从缓冲区中解析出JSON结构
    cJSON * json= cJSON_Parse(data);
    
    //将传入的JSON结构转化为字符串 并打印
    char *json_data = NULL;
    printf("data:%s\n",json_data = cJSON_Print(json));
    
    cJSON_Delete(json);
}
void cJSON_test2(){
    //创建一个空的文档（对象）
    cJSON *json = cJSON_CreateObject();
    
    //向文档中增加一个键值对{"name":"王大锤"}
    cJSON_AddItemToObject(json,"name",cJSON_CreateString("王大锤"));
    //向文档中添加一个键值对
    //cJSON_AddItemToObject(json,"age",cJSON_CreateNumber(29));
    cJSON_AddNumberToObject(json,"age",29);
    
    cJSON *array = NULL;
    cJSON_AddItemToObject(json,"love",array=cJSON_CreateArray());
    cJSON_AddItemToArray(array,cJSON_CreateString("LOL"));
    cJSON_AddItemToArray(array,cJSON_CreateString("NBA"));
    cJSON_AddItemToArray(array,cJSON_CreateString("Go shopping"));
    
    cJSON_AddNumberToObject(json,"score",59);
    cJSON_AddStringToObject(json,"address","beijing");
    
    //将json结构格式化到缓冲区
    char *buf = cJSON_Print(json);
    printf("data:%s\n",buf = cJSON_Print(json));
    //释放json结构所占用的内存
    cJSON_Delete(json);
}
void cJSON_test3(){
    //先创建空对象
    cJSON *json = cJSON_CreateObject();
    //在对象上添加键值对
    cJSON_AddStringToObject(json,"country","china");
    //添加数组
    cJSON *array = NULL;
    cJSON_AddItemToObject(json,"stars",array=cJSON_CreateArray());
    
    //在数组上添加对象
    cJSON *obj =  cJSON_CreateObject();
    //在对象上添加键值对
    cJSON_AddItemToObject(obj,"name",cJSON_CreateString("andy"));
    cJSON_AddItemToObject(obj,"address",cJSON_CreateString("HK"));
    cJSON_AddNumberToObject(obj, "phoneNum", 18665945497);
    cJSON_AddNumberToObject(obj, "temperature", -24.5f);
    cJSON_AddItemToArray(array,obj);
    
    
    cJSON *obj1 = cJSON_CreateObject();
    cJSON_AddItemToObject(obj1,"name",cJSON_CreateString("Faye"));
    cJSON_AddStringToObject(obj1,"address","beijing");
    
    cJSON_AddItemToArray(array,obj1);
    
    
    cJSON *obj2 = cJSON_CreateObject();
    cJSON_AddStringToObject(obj2,"name","eddie");
    cJSON_AddStringToObject(obj2,"address","TaiWan");
    cJSON_AddItemToArray(array,obj2);
    
    cJSON *node = NULL;
    node = cJSON_GetObjectItem(obj,"temperature");
    if(node == NULL){
        printf("country node == NULL\n");
    }
    else{
        printf("found country node,country:%f\n",node->valuedouble);
    }
    
    
    //将json结构格式化到缓冲区
    char *buf = cJSON_Print(json);
    printf("data:%s\n",buf = cJSON_Print(json));
    //    free(buf);
    cJSON_Delete(json);
}

void cJSON_test4(){
    char *string = "{\"family\":[\"father\",\"mother\",\"brother\",\"sister\",\"somebody\"]}";
    //char *string ="{\"arr\":[{\"name\":\"sensorA\",\"temperature\":12.05,\"pressure\":10.05,\"humidity\":30.06},{\"name\":\"sensorB\",\"temperature\":22.07,\"pressure\":10.010,\"humidity\":50.66},{\"name\":\"sensorC\",\"temperature\":0.17,\"pressure\":1.010,\"humidity\":0.88}]}";
    //从缓冲区中解析出JSON结构
    cJSON *json = cJSON_Parse(string);
    cJSON *node = NULL;
    
    node = cJSON_GetObjectItem(json,"family");
    
    // 判断是什么类型的
    if(node->type == cJSON_Array){
        //非array类型的node 被当做array获取size的大小是未定义的行为 不要使用
        printf("array size is %d\n\n",cJSON_GetArraySize(node));
    }
    
    
    cJSON *tnode = NULL;
    int size = cJSON_GetArraySize(node);
    int i;
    for(i=0;i<size;i++){
        tnode = cJSON_GetArrayItem(node,i);
        if(tnode->type == cJSON_String){
            printf("value[%d]:%s\n",i,tnode->valuestring);
        }else{
            printf("node' type is not string\n");
        }
    }
    printf("\n\n");
    
    // 遍历
    cJSON_ArrayForEach(tnode,node){
        if(tnode->type == cJSON_String){
            printf("int forEach: vale:%s\n",tnode->valuestring);
        }else{
            printf("node's type is not string\n");
        }
    }
}
void cJSON_test5(){
    char *data = "{\"love\":[\"LOL\",\"Go shopping\"]}";
    printf("长度:%ld\n",strlen(data));
    
    //从缓冲区中解析出JSON结构
    cJSON * json= cJSON_Parse(data);
    
    //将传入的JSON结构转化为字符串 并打印
    char *json_data = NULL;
    printf("data:%s\n",json_data = cJSON_Print(json));
    
    free(json_data);
    cJSON_Delete(json);
}














int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // 1.原始协议数据
        uint8 desData[] = { 0x9A,
            0x00,0xEE,
            0x02,
            0x00,0x01,
            0x9a,0x20,
            //0x7b,0x22,0x61,0x61,0x61,0x22,0x3a,0x31,0x31,0x31,0x7d,// "{\"aaa\":111}"
            0x7b,0x22,0x61,0x72,0x72,0x22,0x3a,0x5b,0x7b,0x22,0x6e,
            0x61,0x6d,0x65,0x22,0x3a,0x22,0x73,0x65,0x6e,0x73,
            0x6f,0x72,0x41,0x22,0x2c,0x22,0x74,0x65,0x6d,0x70,
            0x65,0x72,0x61,0x74,0x75,0x72,0x65,0x22,0x3a,0x31,
            0x32,0x2e,0x30,0x35,0x2c,0x22,0x70,0x72,0x65,0x73,
            0x73,0x75,0x72,0x65,0x22,0x3a,0x31,0x30,0x2e,0x30,
            0x35,0x2c,0x22,0x68,0x75,0x6d,0x69,0x64,0x69,0x74,
            0x79,0x22,0x3a,0x33,0x30,0x2e,0x30,0x36,0x7d,0x2c,
            0x7b,0x22,0x6e,0x61,0x6d,0x65,0x22,0x3a,0x22,0x73,
            0x65,0x6e,0x73,0x6f,0x72,0x42,0x22,0x2c,0x22,0x74,
            0x65,0x6d,0x70,0x65,0x72,0x61,0x74,0x75,0x72,0x65,
            0x22,0x3a,0x32,0x32,0x2e,0x30,0x37,0x2c,0x22,0x70,
            0x72,0x65,0x73,0x73,0x75,0x72,0x65,0x22,0x3a,0x31,
            0x30,0x2e,0x30,0x31,0x30,0x2c,0x22,0x68,0x75,0x6d,
            0x69,0x64,0x69,0x74,0x79,0x22,0x3a,0x35,0x30,0x2e,
            0x36,0x36,0x7d,0x2c,0x7b,0x22,0x6e,0x61,0x6d,0x65,
            0x22,0x3a,0x22,0x73,0x65,0x6e,0x73,0x6f,0x72,0x43,
            0x22,0x2c,0x22,0x74,0x65,0x6d,0x70,0x65,0x72,0x61,
            0x74,0x75,0x72,0x65,0x22,0x3a,0x30,0x2e,0x31,0x37,
            0x2c,0x22,0x70,0x72,0x65,0x73,0x73,0x75,0x72,0x65,
            0x22,0x3a,0x31,0x2e,0x30,0x31,0x30,0x2c,0x22,0x68,
            0x75,0x6d,0x69,0x64,0x69,0x74,0x79,0x22,0x3a,0x30,
            0x2e,0x38,0x38,0x7d,0x5d,0x7d,
            0xaa,0xbb
        };
 /*🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊*/
        // 2.原始协议数据转化为结构体数据
        universalCommunicateFrame myFrame;
        myFrame.Frame_flag      = desData[0];
        myFrame.Frame_dataLen   = desData[1] << 8 |desData[2] -10;
        myFrame.Frame_version   = desData[3];
        myFrame.Frame_packetNum = desData[4] << 8 |desData[5];
        myFrame.Frame_command   = desData[6] << 8 |desData[7];
        myFrame.Frame_dataBody  = hancc_mem_malloc(myFrame.Frame_dataLen);
        memset(myFrame.Frame_dataBody, 0x00, myFrame.Frame_dataLen);
        memcpy(myFrame.Frame_dataBody, &desData[8], myFrame.Frame_dataLen);
        myFrame.Frame_CRC16     = desData[8 +myFrame.Frame_dataLen]  << 8 |desData[8 +myFrame.Frame_dataLen+1];;
        
        
        printf("0x%02x\n",myFrame.Frame_flag);
        printf("0x%04x\n",myFrame.Frame_dataLen);
        printf("0x%02x\n",myFrame.Frame_version);
        printf("0x%04x\n",myFrame.Frame_packetNum);
        printf("0x%04x\n",myFrame.Frame_command);
        hancc_buffer_print(myFrame.Frame_dataBody, myFrame.Frame_dataLen);
        //        for(int jj = 0; jj <myFrame.Frame_dataLen ;jj++){
        //            printf("🍉:%c\n",myFrame.Frame_dataBody[jj]);
        //        }
        printf("0x%04x\n",myFrame.Frame_CRC16);
/*🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊🦊*/

        
        
        
        
        
        
/*🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹*/
#if 0
        //  3.有效数据区数据转换为json数据   验证hancc_json_util
        jsonObj *rootJson = jsonParse((char *)myFrame.Frame_dataBody);
//        printf("aaa = %d\n", getJsonObjInteger(rootJson, "aaa"));
        
        // 取出根元素
        jsonObj *ArrJson =jsonArray(rootJson, "arr");
        // 取出数组中的第1个元素
        jsonObj *obj1 = getJsonArrObject(ArrJson, 0);
        printJsonObj(obj1);

        // 取出数组中的第2个元素
        jsonObj *obj2 = getJsonArrObject(ArrJson, 1);
        printJsonObj(obj2);

        // 取出数组中的第3个元素
        jsonObj *obj3 = getJsonArrObject(ArrJson, 2);
        printJsonObj(obj3);

        
        
        jsonObj *temp = getJsonArrObject(ArrJson, 0);
        char *name = getJsonObjString(temp,"name");
//        printf("name = %s\n",name);
//        float temperature = getJsonObjFloat(temp,"temperature");
//        printf("temperature = %f\n",temperature);
//        float humidity = getJsonObjFloat(temp,"humidity");
//        printf("humidity = %f\n",humidity);
//        float pressure = getJsonObjFloat(temp,"pressure");
//        printf("pressure = %f\n\n",pressure);
        
        
        
        //  问题:hancc_json_util,单独去obj可以，用工具printJsonObj都正常。但是用循环取的话就不行
     
        printf("🍎list总长度:%d\n",ArrJson->count);
        for (int index = 0; index < ArrJson->count; index ++) {
            jsonObj *temp = getJsonArrObject(ArrJson, 0);
            char *name = getJsonObjString(temp,"name");
            printf("name = %s\n",name);
            float temperature = getJsonObjFloat(temp,"temperature");
            printf("temperature = %f\n",temperature);
            float humidity = getJsonObjFloat(temp,"humidity");
            printf("humidity = %f\n",humidity);
            float pressure = getJsonObjFloat(temp,"pressure");
            printf("pressure = %f\n\n",pressure);
        }
        hancc_mem_free(myFrame.Frame_dataBody);
#endif
/*🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹🐹*/
        
        
        
/*🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶*/
//        cJSON_test1();
//        cJSON_test2();
//        cJSON_test3();
//        cJSON_test4();
/*🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶*/

//        cJSON * json= cJSON_Parse((const char *)myFrame.Frame_dataBody);
        cJSON * json= cJSON_Parse("{\"arr\":[{\"name\":\"sensorA\",\"temperature\":12.05,\"pressure\":10.05,\"humidity\":30.06},{\"name\":\"sensorB\",\"temperature\":22.07,\"pressure\":10.010,\"humidity\":50.66},{\"name\":\"sensorC\",\"temperature\":0.17,\"pressure\":1.010,\"humidity\":0.88}]}");
        
        cJSON *node = cJSON_GetObjectItem(json,"arr");
        // 判断是什么类型的
        if(node->type == cJSON_Array){
            //非array类型的node 被当做array获取size的大小是未定义的行为 不要使用
            printf("array size is %d\n\n",cJSON_GetArraySize(node));
        }
        cJSON *tnode = NULL;
        // 遍历
        cJSON_ArrayForEach(tnode,node){
            printf("🧤name vale:%s\n",cJSON_GetObjectItem(tnode, "name")->valuestring);
            printf("🧤temperature vale:%lf\n",cJSON_GetObjectItem(tnode, "temperature")->valuedouble);
            printf("🧤humidity vale:%lf\n",cJSON_GetObjectItem(tnode, "humidity")->valuedouble);
            printf("🧤pressure vale:%lf\n",cJSON_GetObjectItem(tnode, "pressure")->valuedouble);
            
            cJSON_Delete(tnode);
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        char *pbSrc = "aabbccff";
        //        unsigned char *pbDest[20] ={0x00};
        unsigned char *pbDest = hancc_mem_malloc(strlen(pbSrc)/2);
        memset(pbDest, 0x00, strlen(pbSrc)/2);
        StrToHex(pbDest,pbSrc,strlen(pbSrc)/2);
        hancc_buffer_print(pbDest,strlen(pbSrc)/2);
        hancc_mem_free(myFrame.Frame_dataBody);
    
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        // 主要是是想把字符串转化为ascii16进制表示
        char a[]="{\"arr\":[{\"name\":\"sensorA\",\"temperature\":12.05,\"pressure\":10.05,\"humidity\":30.06},{\"name\":\"sensorB\",\"temperature\":22.07,\"pressure\":10.010,\"humidity\":50.66},{\"name\":\"sensorC\",\"temperature\":0.17,\"pressure\":1.010,\"humidity\":0.88}]}";
        int len = (int)strlen(a);
        printf("长度:%d\n",len);
        //  228 = len +1;
        char b[228], *pp=a;
        int j=0;
        while(*pp!=0){
            j+=sprintf(b+j,"%02x",*pp++);
        }
        for (int kk = 0; kk < 228; kk ++) {
            int hehe = kk+1;
            if (hehe < 228) {
                printf("0x%c%c,",b[kk*2],b[kk*2 +1]);
                if (kk != 0 && kk %10 == 0) {
                    printf("\n");
                }
            }
//            printf("0x%c%c\n",b[kk],b[kk+1]);
        }
        
        printf("%s\n",b);
        
        
        
        
        
        
    }
    return 0;
}
