#define EXTENSION_NAME PPReader
#define LIB_NAME "PPReader"
#define MODULE_NAME "ppreader_native"

#define DLIB_LOG_DOMAIN LIB_NAME
#include <dmsdk/sdk.h>

#if defined(DM_PLATFORM_IOS) || defined(DM_PLATFORM_OSX)
#include "PPReader_private.h"

static int ppread(lua_State* L) {
    int top = lua_gettop(L);
    const char* path = luaL_checkstring(L, 1);
    const char* result_path = PPReader_getPath(path);
    const char* result = PPReader_read(result_path);
    bool is_fail = false;
    if(result) {
      dmJson::Document doc;
      dmJson::Result r = dmJson::Parse(result, &doc);
      if (r == dmJson::RESULT_OK && doc.m_NodeCount > 0) {
        char error_str_out[128];
        if (dmScript::JsonToLua(L, &doc, 0, error_str_out, sizeof(error_str_out)) < 0) {
          dmLogError("Failed converting object JSON to Lua; %s", error_str_out);
          is_fail = true;
        }
      } else {
        dmLogError("Failed to parse JSON object(%d): (%s)", r, result);
        is_fail = true;
      }
      dmJson::Free(&doc);
    } else {
      is_fail = true;
    }
    if (is_fail) {
      lua_pushnil(L);
    }
    lua_pushstring(L, result_path);
    assert(top + 2 == lua_gettop(L));
    return 2;
}

static const luaL_reg Module_methods[] =
{
  {"read", ppread},
  {0, 0}
};

static void LuaInit(lua_State* L)
{
  int top = lua_gettop(L);
  luaL_register(L, MODULE_NAME, Module_methods);
  lua_pop(L, 1);
  assert(top == lua_gettop(L));
}

dmExtension::Result InitializePPReader(dmExtension::Params* params)
{
  LuaInit(params->m_L);
  return dmExtension::RESULT_OK;
}

dmExtension::Result FinalizePPReader(dmExtension::Params* params)
{
  return dmExtension::RESULT_OK;
}

#else // unsupported platforms

static dmExtension::Result InitializePPReader(dmExtension::Params* params)
{
  return dmExtension::RESULT_OK;
}

static dmExtension::Result FinalizePPReader(dmExtension::Params* params)
{
  return dmExtension::RESULT_OK;
}

#endif // platforms


DM_DECLARE_EXTENSION(EXTENSION_NAME, LIB_NAME, 0, 0, InitializePPReader, 0, 0, FinalizePPReader)
