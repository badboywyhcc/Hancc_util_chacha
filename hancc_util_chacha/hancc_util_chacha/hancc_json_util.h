//
// Created by chenqy on 10/5/2018.
//

#ifndef HANCC_JSON_UTIL_H
#define HANCC_JSON_UTIL_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

typedef enum {
    INVALID_TYPE = -1,
    NULL_TYPE = 0,
    INTEGER_TYPE,
    BOOLEAN_TYPE,
    STRING_TYPE,
    OBJECT_TYPE,
    ARRAY_TYPE,
}VALUE_TYPE_E;

typedef enum {
    True = 1,
    MY_true = 1,
    MY_TRUE = 1,
    MY_False = 0,
    MY_false = 0,
    MY_FALSE = 0,
}jsonBool;

typedef struct jsonObj {
    char *key;
    char *value;
    int valType;
    int nextIdx;
    int count;
} jsonObj;

typedef struct jsonPack {
    int pos;
    struct jsonPack *next;
} jsonPack;

typedef struct jsonPack_t {
    jsonPack *root;
    jsonPack *prev;
} jsonPack_t;

#define MEM_JSON_SIZE       1*1024
#define PACK_JSON_SIZE      1*1024

//parse json string
jsonObj *jsonParse(char *str);

//array
jsonObj *jsonArray(jsonObj *root, const char *key);
jsonObj *getJsonArrObject(jsonObj *root, int index);
char    *getJsonArrString(jsonObj *root, int index);
int     getJsonArrInteger(jsonObj *root, int index);
float   getJsonArrFloat(jsonObj *root, int index);

//object
jsonObj *jsonObject(jsonObj *root, const char *key);
char    *getJsonObjString(jsonObj *obj, const char *key);
int     getJsonObjInteger(jsonObj *obj, const char *key);
float   getJsonObjFloat(jsonObj *obj, const char *key);
int     getJsonObjBoolean(jsonObj *obj, const char *key);

//print json object
void printJsonObj(jsonObj *obj);

//package json
void    createJsonPack(jsonPack *root);
int     addJsonStrPair(jsonPack *root, const char *key, const char *val);
int     addJsonIntPair(jsonPack *root, const char *key, int num);
int     addJsonBoolPair(jsonPack *root, const char *key, jsonBool BOOL);
int     addJsonObject(jsonPack *root, const char *key, jsonPack *obj);
int     addJsonArray(jsonPack *root, const char *key, jsonPack *obj);
int     addJsonStrArr(jsonPack *root, const char *val);
int     addJsonObjArr(jsonPack *root, jsonPack *obj);
int     addJsonIntArr(jsonPack *root, int num);
char    *getPackJsonString(void);

    
#ifdef __cplusplus
}
#endif

#endif //UNTITLED_JSON_UTILS_H
