unit LuaMemoryRecordHotkey;

{$mode delphi}

interface

uses
  Classes, SysUtils, lua, lualib, lauxlib, CEFuncProc;

procedure initializeMemoryRecordHotkey;

implementation

uses luaclass, luahandler, luacaller, luaobject, MemoryRecordUnit;



function memoryrecordhotkey_getDescription(L: PLua_State): integer; cdecl;
var
  memoryrecordhotkey: TMemoryRecordHotkey;
begin
  memoryrecordhotkey:=luaclass_getClassObject(L);
  lua_pushstring(L, memoryrecordhotkey.description);
  result:=1;
end;

function memoryrecordhotkey_getHotkeyString(L: PLua_State): integer; cdecl;
var
  memoryrecordhotkey: TMemoryRecordHotkey;
begin
  memoryrecordhotkey:=luaclass_getClassObject(L);
  lua_pushstring(L, ConvertKeyComboToString(memoryrecordhotkey.keys));
  result:=1;
end;

function memoryrecordhotkey_getID(L: PLua_State): integer; cdecl;
var
  memoryrecordhotkey: TMemoryRecordHotkey;
begin
  memoryrecordhotkey:=luaclass_getClassObject(L);
  lua_pushinteger(L, memoryrecordhotkey.id);
  result:=1;
end;

function memoryrecordhotkey_setOnHotkey(L: PLua_State): integer; cdecl;
var
  c: Tmemoryrecordhotkey;
  m: tmethod;
begin
  if lua_gettop(L)>=1 then
  begin
    c:=luaclass_getClassObject(L);
    m:=tmethod(c.OnHotkey);
    LuaCaller_setMethodProperty(L, m, 'TNotifyEvent', lua_gettop(L));
    c.OnHotkey:=tnotifyevent(m);
  end;
  result:=0;
end;

function memoryrecordhotkey_setOnPostHotkey(L: PLua_State): integer; cdecl;
var
  c: Tmemoryrecordhotkey;
  m: tmethod;
begin
  if lua_gettop(L)>=1 then
  begin
    c:=luaclass_getClassObject(L);
    m:=tmethod(c.OnPostHotkey);
    LuaCaller_setMethodProperty(L, m, 'TNotifyEvent', lua_gettop(L));
    c.OnPostHotkey:=tnotifyevent(m);
  end;
  result:=0;
end;

function memoryrecordhotkey_getOwner(L: PLua_State): integer; cdecl;
var
  memoryrecordhotkey: TMemoryRecordHotkey;
begin
  memoryrecordhotkey:=luaclass_getClassObject(L);
  luaclass_newClass(L, memoryrecordhotkey.owner);
  result:=1;
end;

function memoryrecordhotkey_doHotkey(L: PLua_State): integer; cdecl;
var
  memoryrecordhotkey: TMemoryRecordHotkey;
begin
  memoryrecordhotkey:=luaclass_getClassObject(L);
  memoryrecordhotkey.doHotkey;
  result:=0;
end;


procedure memoryrecordhotkey_addMetaData(L: PLua_state; metatable: integer; userdata: integer );
begin
  object_addMetaData(L, metatable, userdata);
  luaclass_addClassFunctionToTable(L, metatable, userdata, 'doHotkey', memoryrecordhotkey_doHotkey);
  luaclass_addPropertyToTable(L, metatable, userdata, 'HotkeyString', memoryrecordhotkey_getHotkeyString, nil);
end;

procedure initializeMemoryRecordHotkey;
begin
  Lua_register(LuaVM, 'memoryrecordhotkey_getDescription', memoryrecordhotkey_getDescription);
  Lua_register(LuaVM, 'memoryrecordhotkey_getHotkeyString', memoryrecordhotkey_getHotkeyString);
  Lua_register(LuaVM, 'memoryrecordhotkey_getID', memoryrecordhotkey_getID);
  Lua_register(LuaVM, 'memoryrecordhotkey_onHotkey', memoryrecordhotkey_setonHotkey);
  Lua_register(LuaVM, 'memoryrecordhotkey_onPostHotkey', memoryrecordhotkey_setonPostHotkey);
  Lua_register(LuaVM, 'memoryrecordhotkey_getOwner', memoryrecordhotkey_getOwner);
  Lua_register(LuaVM, 'memoryrecordhotkey_doHotkey', memoryrecordhotkey_doHotkey);
end;

initialization
  luaclass_register(TMemoryRecordHotkey, memoryrecordhotkey_addMetaData);



end.

