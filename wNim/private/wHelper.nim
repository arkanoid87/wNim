#====================================================================
#
#               wNim - Nim's Windows GUI Framework
#                 (c) Copyright 2017-2019 Ward
#
#====================================================================

# converter DWORDToInt(x: DWORD): int = int x
converter IntToDWORD(x: int): DWORD = DWORD x
converter PtrPtrObjectToPtrPointer(x: ptr ptr object): ptr pointer = cast[ptr pointer](x)

template `^$`[T](x: T): untyped =
  # `$` cause ambiguous call since 0.2.0, use ^$ instead
  when T is ptr char:
    $x
  else:
    winstr.`$`(x)

proc `-`(a, b: wPoint): wPoint =
  result = (a.x - b.x, a.y - b.y)

proc `+`(a, b: wPoint): wPoint =
  result = (a.x + b.x, a.y + b.y)

iterator rnodes[T](L: SomeLinkedList[T]): SomeLinkedNode[T] =
  var it = L.tail
  while it != nil:
    var prv = it.prev
    yield it
    it = prv

proc toRect(r: wRect): RECT =
  result.left = r.x
  result.top = r.y
  result.right = r.x + r.width
  result.bottom = r.y + r.height

proc toWRect(r: RECT): wRect =
  result.x = r.left
  result.y = r.top
  result.width = r.right - r.left
  result.height = r.bottom - r.top

template SendMessage(hwnd, msg, wparam, lparam: typed): untyped =
  SendMessage(hwnd, msg, cast[WPARAM](wparam), cast[LPARAM](lparam))

template objectOffset(Typ, member): int =
  when declared(offsetOf):
    offsetOf(Typ, member)
  else:
    var dummy: Typ
    cast[int](dummy.member.addr) -% cast[int](dummy.addr)

proc toWStyle(style, exstyle: DWORD): wStyle {.inline.} =
  result = exstyle.wStyle shl 32 or style.wStyle

proc toolBarDirection(hwnd: HWND): int =
  case SendMessage(hwnd, TB_GETSTYLE, 0, 0) and CCS_RIGHT
  of CCS_RIGHT: result = wRight
  of CCS_LEFT: result = wLeft
  of CCS_BOTTOM: result = wBottom
  else: result = wTop

proc centerWindow(hwnd: HWND, inScreen = false, direction = wBoth) =
  # this works on top level window only
  var rect: RECT
  var rectOwner: RECT

  GetWindowRect(hwnd, rect)
  let owner = GetParent(hwnd)
  if owner == 0 or inScreen:
    GetClientRect(GetDesktopWindow(), &rectOwner)
  else:
    GetWindowRect(owner, &rectOwner)

  let width = rect.right - rect.left
  let height = rect.bottom - rect.top
  let ownerWidth = rectOwner.right - rectOwner.left
  let ownerHeight = rectOwner.bottom - rectOwner.top

  if (direction and wHorizontal) != 0:
    rect.left = (rectOwner.left + (ownerWidth - width) div 2)
      .clamp(0, GetSystemMetrics(SM_CXSCREEN) - width)

  if (direction and wVertical) != 0:
    rect.top = (rectOwner.top + (ownerHeight - height) div 2)
      .clamp(0, GetSystemMetrics(SM_CYSCREEN) - height)

  SetWindowPos(hwnd, 0, rect.left, rect.top, 0, 0,
    SWP_NOSIZE or SWP_NOZORDER or SWP_NOREPOSITION or SWP_NOACTIVATE)

proc isVaildPath(str: string): bool =
  if str.len <= MAX_PATH and PathFileExists(str) != 0:
    result = true

proc getTextFontSize(text: string, hFont: HANDLE, hwnd: HWND): wSize =
  var
    text = T(text)
    hdc = GetDC(hwnd)
    prev = SelectObject(hdc, hFont)
    rect: RECT

  DrawText(hdc, text, text.len, &rect, DT_CALCRECT)
  SelectObject(hdc, prev)
  ReleaseDC(hwnd, hdc)

  result.width = rect.right
  result.height = rect.bottom

proc getAverageASCIILetterSize(hFont: HANDLE, hwnd: HWND): wSize =
  result = getTextFontSize("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz",
    hFont, hWnd)
  result.width = (result.width div 26 + 1) div 2

var hwndComboBoxForCountSize {.threadvar.}: HWND

proc getLineControlDefaultHeight(hFont: HANDLE): int =
  # a hack way to get default height from autosize combobox
  # is there a correct way to calculate it?
  if hwndComboBoxForCountSize == 0:
    hwndComboBoxForCountSize = CreateWindowEx(0, WC_COMBOBOX, "", CBS_DROPDOWN,
      0, 0, 0, 0, 0, 0, 0, nil)

  var r: RECT
  SendMessage(hwndComboBoxForCountSize, WM_SETFONT, hFont, 0)
  GetWindowRect(hwndComboBoxForCountSize, r)
  result = r.bottom - r.top

proc getTextFontSizeWithCheckMark(text: string, hFont: HANDLE, hwnd: HWND): wSize =
  let
    hdc = GetDC(hwnd)
    prev = SelectObject(hdc, hFont)
    checkWidth = 12 * GetDeviceCaps(hdc, LOGPIXELSX).int div 96 + 1
    checkHeight = 12 * GetDeviceCaps(hdc, LOGPIXELSY).int div 96 + 1
  var textOffset: INT
  GetCharWidth(hdc, '0'.UINT, '0'.UINT, addr textOffset)
  SelectObject(hdc, prev)
  ReleaseDC(hwnd, hdc)

  result = getTextFontSize(text & " ", hFont, hwnd)
  result.width += checkWidth + textOffset.int div 2
  if result.width < checkHeight: result.width = checkHeight

proc toDateTime(st: SYSTEMTIME): DateTime =
  initDateTime(st.wDay, Month st.wMonth, st.wYear.int, st.wHour, st.wMinute,
    st.wSecond)

proc toSystemTime(dateTime: DateTime): SYSTEMTIME =
  result.wSecond = WORD dateTime.second
  result.wMinute = WORD dateTime.minute
  result.wHour = WORD dateTime.hour
  result.wYear = WORD dateTime.year
  result.wMonth = WORD dateTime.month
  result.wDay = WORD dateTime.monthday

proc toTime(st: SYSTEMTIME): wTime =
  st.toDateTime().toTime()

proc toSystemTime(time: wTime): SYSTEMTIME =
  result = time.inZone(local()).toSystemTime()


proc wGetMenuItemInfo(hmenu: HMENU, pos: int, fMask = MIIM_STATE): MENUITEMINFO =
  result = MENUITEMINFO(cbSize: sizeof(MENUITEMINFO), fMask: fMask)
  GetMenuItemInfo(hmenu, pos, true, result)

proc wGetMenuItemString(hmenu: HMENU, pos: int, buffer: var TString): int =
  var menuItemInfo = MENUITEMINFO(
    cbSize: sizeof(MENUITEMINFO),
    fMask: MIIM_STRING,
    dwTypeData: &buffer,
    cch: buffer.high)

  if GetMenuItemInfo(hmenu, pos, true, menuItemInfo) != 0:
    result = menuItemInfo.cch

proc wEnableMenu(hmenu: HMENU, pos: int, flag: bool) =
  var menuItemInfo = wGetMenuItemInfo(hmenu, pos)
  if flag:
    menuItemInfo.fState = menuItemInfo.fState and (not MFS_DISABLED)
  else:
    menuItemInfo.fState = menuItemInfo.fState or MFS_DISABLED
  SetMenuItemInfo(hmenu, pos, true, menuItemInfo)

proc wIsMenuEnabled(hmenu: HMENU, pos: int): bool =
  var menuItemInfo = wGetMenuItemInfo(hmenu, pos)
  result = (menuItemInfo.fState and MFS_DISABLED) == 0

proc wCheckMenuItem(hmenu: HMENU, pos: int, flag: bool) =
  var menuItemInfo = wGetMenuItemInfo(hmenu, pos)
  if flag:
    menuItemInfo.fState = menuItemInfo.fState or MFS_CHECKED
  else:
    menuItemInfo.fState = menuItemInfo.fState and (not MFS_CHECKED)
  SetMenuItemInfo(hmenu, pos, true, menuItemInfo)

proc isMouseInWindow(mHwnd: HWND): bool =
  var mousePos: POINT
  GetCursorPos(mousePos)

  var hwnd = WindowFromPoint(mousePos)
  while hwnd != 0 and hwnd != mHwnd:
    hwnd = GetParent(hwnd)

  result = hwnd != 0

proc loadRichDll(): bool =
  var richDllLoaded {.global, threadvar.}: bool
  if not richDllLoaded:
    if LoadLibrary("msftedit.dll") != 0:
      richDllLoaded = true
  result = richDllLoaded

proc useTheme(): bool =
  let hDll = LoadLibrary("comctl32.dll")
  if hDll != 0:
    defer: FreeLibrary(hDll)

    var dllGetVersion = cast[DLLGETVERSIONPROC](GetProcAddress(hDll, "DllGetVersion"))
    if not dllGetVersion.isNil:
      var vi = DLLVERSIONINFO(cbSize: int32 sizeof(DLLVERSIONINFO))
      discard dllGetVersion(vi)
      result = vi.dwMajorVersion >= 6

proc getSize(iconInfo: ICONINFO): wSize =
  var bitmapInfo: BITMAP
  if iconInfo.hbmColor != 0:
    let hbm = iconInfo.hbmColor
    if GetObject(hbm, sizeof(bitmapInfo), cast[LPVOID](&bitmapInfo)) != 0:
      result.width = int bitmapInfo.bmWidth
      result.height = int bitmapInfo.bmHeight

  elif iconInfo.hbmMask != 0:
    let hbm = iconInfo.hbmMask
    if GetObject(hbm, sizeof(bitmapInfo), cast[LPVOID](&bitmapInfo)) != 0:
      result.width = int bitmapInfo.bmWidth
      result.height = int bitmapInfo.bmHeight div 2
