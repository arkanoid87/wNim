#====================================================================
#
#               wNim - Nim's Windows GUI Framework
#                 (c) Copyright 2017-2018 Ward
#
#====================================================================

## *wEvent* and it's subclass hold information about an event passed to
## a event handler. A object of wWindow can be bound to an event handler
## by ``connect`` proc. For example:
##
## .. code-block:: Nim
##   var button = Button(panel, label="Button")
##   button.connect(wEvent_Button) do (event: wEvent):
##     discard
##
## If an event is generated from a control or menu, it may also associated with
## a wCommandID:
##
## .. code-block:: Nim
##   var frame = Frame()
##   frame.connect(wEvent_Menu, wIdExit) do (event: wEvent):
##     discard
##
## For frame, button, and toolbar, you can also simply connect to a wCommandID:
##
## .. code-block:: Nim
##   var frame = Frame()
##   frame.connect(wIdExit) do (event: wEvent):
##     discard
##
## If the event object is not used in the handler, it can be omitted. Moreover,
## dot is a symbol alias for ``connect``, so following is the simplest code:
##
## .. code-block:: Nim
##   var frame = Frame()
##   frame.wIdExit do ():
##     discard
##
## An event is usually generated from system. However, the user may define their
## own event type, create the event object, and pass to a window by
## wWindow.processEvent().
#
## :Subclasses:
##   `wMouseEvent <wMouseEvent.html>`_
##   `wKeyEvent <wKeyEvent.html>`_
##   `wSizeEvent <wSizeEvent.html>`_
##   `wMoveEvent <wMoveEvent.html>`_
##   `wTrayEvent <wTrayEvent.html>`_
##   `wSetCursorEvent <wSetCursorEvent.html>`_
##   `wContextMenuEvent <wContextMenuEvent.html>`_
##   `wScrollWinEvent <wScrollWinEvent.html>`_
##   `wNavigationEvent <wNavigationEvent.html>`_
##   `wCommandEvent <wCommandEvent.html>`_
#
## :Events:
##   ================================  =============================================================
##   wEvent                            Description
##   ================================  =============================================================
##   wEvent_SetFocus                   A window has gained the keyboard focus.
##   wEvent_KillFocus                  A window is about to loses the keyboard focus.
##   wEvent_Show                       A window is about to be hidden or shown.
##   wEvent_Activate                   A window being activated or deactivated.
##   wEvent_Timer                      A timer expires.
##   wEvent_Paint                      A window's client area must be painted.
##   wEvent_NcPaint                    A window's frame must be painted.
##   wEvent_HotKey                     The user presses the registered hotkey.
##   wEvent_Close                      The user has tried to close a window. This event can be vetoed.
##   wEvent_MenuHighlight              The user selects a menu item (not clicks).
##   wEvent_Destroy                    A window is being destroyed.
##   wEvent_App                        Used to define private event type, usually of the form wEvent_App+x.
##   ================================  =============================================================

# forward declaration
proc isMouseEvent(msg: UINT): bool {.inline.}
proc isKeyEvent(msg: UINT): bool {.inline.}
proc isSizeEvent(msg: UINT): bool {.inline.}
proc isMoveEvent(msg: UINT): bool {.inline.}
proc isContextMenuEvent(msg: UINT): bool {.inline.}
proc isScrollWinEvent(msg: UINT): bool {.inline.}
proc isTrayEvent(msg: UINT): bool {.inline.}
proc isDragDropEvent(msg: UINT): bool {.inline.}
proc isNavigationEvent(msg: UINT): bool {.inline.}
proc isSetCursorEvent(msg: UINT): bool {.inline.}
proc isCommandEvent(msg: UINT): bool {.inline.}
proc isScrollEvent(msg: UINT): bool {.inline.}
proc isListEvent(msg: UINT): bool {.inline.}
proc isTreeEvent(msg: UINT): bool {.inline.}
proc isStatusBarEvent(msg: UINT): bool {.inline.}
proc isSpinEvent(msg: UINT): bool {.inline.}
proc isHyperLinkEvent(msg: UINT): bool {.inline.}
proc isIpEvent(msg: UINT): bool {.inline.}
proc screenToClient*(self: wWindow, pos: wPoint): wPoint

const
  wEvent_PropagateMax* = int INT_PTR.high
  wEvent_PropagateNone* = 0

  wEvent_SetFocus* = WM_SETFOCUS
  wEvent_KillFocus* = WM_KILLFOCUS
  wEvent_Show* = WM_SHOWWINDOW
  wEvent_Activate* = WM_ACTIVATE
  wEvent_Timer* = WM_TIMER
  wEvent_MenuHighlight* = WM_MENUSELECT
  wEvent_Paint* = WM_PAINT
  wEvent_NcPaint* = WM_NCPAINT
  wEvent_HotKey* = WM_HOTKEY

  # wEvent_AppQuit = WM_APP + 1
  # wEvent_Navigation* = WM_APP + 2
  # wEvent_SetCursor* = WM_APP + 3
  wEvent_Close* = WM_APP + 4
  wEvent_Destroy* = WM_APP + 5

  # wEvent_MouseEnter* = WM_APP + 51
  # wEvent_Size* = WM_APP + 52
  # wEvent_Iconize* = WM_APP + 53
  # wEvent_Minimize* = WM_APP + 53
  # wEvent_Maximize* = WM_APP + 54
  # wEvent_Sizing* = WM_APP + 55
  # wEvent_Dragging* = WM_APP + 56

  wEvent_ScrollWinFirst = WM_APP + 100
  wEvent_TrayFirst = WM_APP + 150
  wEvent_DragDropFirst = WM_APP + 200

  wEvent_CommandFirst = WM_APP + 500
  wEvent_StatusBarFirst = WM_APP + 600
  wEvent_ScrollFirst = WM_APP + 650
  wEvent_ListFirst = WM_APP + 700
  wEvent_TreeFirst = WM_APP + 750
  wEvent_SpinFirst = WM_APP + 800
  wEvent_HyperLinkFirst = WM_APP + 850
  wEvent_IpFirst = WM_APP + 900
  wEvent_CommandLast = WM_APP + 1000
  wEvent_App* = wEvent_CommandLast + 1

proc defaultPropagationLevel(msg: UINT): int =
  if msg.isCommandEvent() or wAppIsMessagePropagation(msg):
    result = wEvent_PropagateMax
  else:
    result = 0

proc Event*(window: wWindow = nil, msg: UINT = 0, wParam: WPARAM = 0,
    lParam: LPARAM = 0, origin: HWND = 0, userData: int = 0): wEvent =
  ## Constructor.

  template CreateEvent(Constructor: untyped): untyped =
    Constructor(mWindow: window, mMsg: msg, mWparam: wParam, mLparam: lParam,
      mOrigin: origin, mUserData: userData)

  if msg.isMouseEvent():
    result = CreateEvent(wMouseEvent)

  elif msg.isKeyEvent():
    result = CreateEvent(wKeyEvent)

  elif msg.isSizeEvent():
    result = CreateEvent(wSizeEvent)

  elif msg.isMoveEvent():
    result = CreateEvent(wMoveEvent)

  elif msg.isContextMenuEvent():
    result = CreateEvent(wContextMenuEvent)

  elif msg.isScrollWinEvent():
    result = CreateEvent(wScrollWinEvent)

  elif msg.isTrayEvent():
    result = CreateEvent(wTrayEvent)

  elif msg.isDragDropEvent():
    result = CreateEvent(wDragDropEvent)

  elif msg.isNavigationEvent():
    result = CreateEvent(wNavigationEvent)

  elif msg.isSetCursorEvent():
    result = CreateEvent(wSetCursorEvent)

  elif msg.isScrollEvent():
    result = CreateEvent(wScrollEvent)

  elif msg.isSpinEvent():
    result = CreateEvent(wSpinEvent)

  elif msg.isHyperLinkEvent():
    result = CreateEvent(wHyperLinkEvent)

  elif msg.isIpEvent():
    result = CreateEvent(wIpEvent)

  elif msg.isListEvent():
    result = CreateEvent(wListEvent)

  elif msg.isTreeEvent():
    result = CreateEvent(wTreeEvent)

  elif msg.isStatusBarEvent():
    result = CreateEvent(wStatusBarEvent)

  elif msg.isCommandEvent(): # must last check
    result = CreateEvent(wCommandEvent)

  else:
    result = CreateEvent(wOtherEvent)

  if result of wCommandEvent:
    result.mId = wCommandID LOWORD(wParam)

  result.mPropagationLevel = msg.defaultPropagationLevel()

  # save the status for the last message occured
  GetKeyboardState(cast[PBYTE](&result.mKeyStatus[0]))
  result.mMousePos = wGetMessagePosition()
  result.mClientPos = wDefaultPoint

proc getEventObject*(self: wEvent): wWindow {.validate, property, inline.} =
  ## Returns the object (usually a window) associated with the event
  result = mWindow

proc getWindow*(self: wEvent): wWindow {.validate, property, inline.} =
  ## Returns the window associated with the event. This proc is equal to
  ## getEventObject.
  result = mWindow

proc getEventType*(self: wEvent): UINT {.validate, property, inline.} =
  ## Returns the type of the given event, such as wEvent_Button, aka message code.
  result = mMsg

proc getEventMessage*(self: wEvent): UINT {.validate, property, inline.} =
  ## Returns the message code of the given event. The same as getEventType().
  result = mMsg

proc getId*(self: wEvent): wCommandID {.validate, property, inline.} =
  ## Returns the ID associated with this event, aka command ID or menu ID.
  result = mID

proc getIntId*(self: wEvent): int {.validate, property, inline.} =
  ## Returns the ID associated with this event, aka command ID or menu ID.
  result = int mID

proc getTimerId*(self: wEvent): int {.validate, property, inline.} =
  ## Return the timer ID. Only for wEvent_Timer event.
  result = int mWparam

proc getlParam*(self: wEvent): LPARAM {.validate, property, inline.} =
  ## Returns the low-level LPARAM data of the associated windows message.
  result = mLparam

proc getwParam*(self: wEvent): WPARAM {.validate, property, inline.} =
  ## Returns the low-level WPARAM data of the associated windows message.
  result = mWparam

proc getResult*(self: wEvent): LRESULT {.validate, property, inline.} =
  ## Returns data that will be sent to system after event handler exit.
  result = mResult

proc setResult*(self: wEvent, ret: LRESULT) {.validate, property, inline.} =
  ## Set the data that will be sent to system after event handler exit.
  mResult = ret

proc getUserData*(self: wEvent): int {.validate, property, inline.} =
  ## Return the userdata associated with a event.
  result = mUserData

proc setUserData*(self: wEvent, userData: int) {.validate, property, inline.} =
  ## Set the userdata associated with a event.
  mUserData = userData

proc skip*(self: wEvent, skip = true) {.validate, inline.} =
  ## This proc can be used inside an event handler to control whether further
  ## event handlers bound to this event will be called after the current one
  ## returns. It sometimes means skip the default behavior for a event.
  mSkip = skip

proc `skip=`*(self: wEvent, skip: bool) {.validate, inline.} =
  ## Nim style setter for skip
  skip(skip)

proc veto*(self: wEvent) {.validate, inline.} =
  ## Prevents the change announced by this event from happening.
  # Most windows's message return non-zero value to "veto". So for convenience,
  # here just set mResult to TRUE. If somewhere the logic is inverted, deal with
  # the value clearly in the event handler.
  mResult = TRUE

proc deny*(self: wEvent) {.validate, inline.} =
  ## The same as veto().
  veto()

proc allow*(self: wEvent) {.validate, inline.} =
  ## This is the opposite of veto(): it explicitly allows the event to be
  ## processed.
  mResult = FALSE

proc isAllowed*(self: wEvent): bool {.validate, inline.} =
  ## Returns true if the change is allowed (veto() hasn't been called) or false
  ## otherwise (if it was).
  result = mResult != TRUE

proc stopPropagation*(self: wEvent): int {.validate, inline, discardable.} =
  ## Stop the event from propagating to its parent window.
  result = mPropagationLevel
  mPropagationLevel = 0

proc resumePropagation*(self: wEvent, propagationLevel = wEvent_PropagateMax)
    {.validate, inline.} =
  ## Sets the propagation level to the given value.
  mPropagationLevel = propagationLevel

method shouldPropagate*(self: wEvent): bool {.base.} = mPropagationLevel > 0
  ## Test if this event should be propagated or not, i.e. if the propagation
  ## level is currently greater than 0.This method can be override, for example:
  ##
  ## .. code-block:: Nim
  ##   method shouldPropagate(event: wKeyEvent): bool =
  ##     if event.eventType == wEvent_Char:
  ##       result = true
  ##     else:
  ##       result = procCall wEvent(event).shouldPropagate()


proc getPropagationLevel*(self: wEvent): int {.validate, property, inline.} =
  ## Get how many levels the event can propagate.
  result = mPropagationLevel

proc setPropagationLevel*(self: wEvent, propagationLevel: int)
    {.validate, property, inline.}  =
  ## Set how many levels the event can propagate.
  mPropagationLevel = propagationLevel

proc getMouseScreenPos*(self: wEvent): wPoint {.validate, property, inline.} =
  ## Get coordinate of the cursor.
  ## The coordinate is relative to the screen.
  result = mMousePos

proc getMousePos*(self: wEvent): wPoint {.validate, property.} =
  ## Get coordinate of the cursor.
  ## The coordinate is relative to the origin of the client area.
  if mClientPos == wDefaultPoint:
    mClientPos = mWindow.screenToClient(mMousePos)

  result = mClientPos

proc getX*(self: wEvent): int {.validate, property, inline.} =
  ## Get x-coordinate of the cursor.
  ## The coordinate is relative to the origin of the client area.
  result = getMousePos().x

proc getY*(self: wEvent): int {.validate, property, inline.} =
  ## Get y-coordinate of the cursor.
  ## The coordinate is relative to the origin of the client area.
  result = getMousePos().y

proc lCtrlDown*(self: wEvent): bool {.validate, inline.} =
  ## Returns true if the left ctrl key is pressed.
  result = mKeyStatus[wKeyLCtrl] < 0

proc lShiftDown*(self: wEvent): bool {.validate, inline.} =
  ## Returns true if the left shift key is pressed.
  result = mKeyStatus[wKeyLShift] < 0

proc lAltDown*(self: wEvent): bool {.validate, inline.} =
  ## Returns true if the left alt key is pressed.
  result = mKeyStatus[wKeyLAlt] < 0

proc lWinDown*(self: wEvent): bool {.validate, inline.} =
  ## Returns true if the left win key is pressed.
  result = mKeyStatus[wKeyLWin] < 0

proc rCtrlDown*(self: wEvent): bool {.validate, inline.} =
  ## Returns true if the right ctrl key is pressed.
  result = mKeyStatus[wKeyRCtrl] < 0

proc rShiftDown*(self: wEvent): bool {.validate, inline.} =
  ## Returns true if the right shift key is pressed.
  result = mKeyStatus[wKeyRShift] < 0

proc rAltDown*(self: wEvent): bool {.validate, inline.} =
  ## Returns true if the right alt key is pressed.
  result = mKeyStatus[wKeyRAlt] < 0

proc rWinDown*(self: wEvent): bool {.validate, inline.} =
  ## Returns true if the right win key is pressed.
  result = mKeyStatus[wKeyRWin] < 0

proc ctrlDown*(self: wEvent): bool {.validate, inline.} =
  ## Returns true if any ctrl key is pressed.
  result = lCtrlDown() or rCtrlDown()

proc shiftDown*(self: wEvent): bool {.validate, inline.} =
  ## Returns true if any shift key is pressed.
  result = lShiftDown() or rShiftDown()

proc altDown*(self: wEvent): bool {.validate, inline.} =
  ## Returns true if any alt key is pressed.
  result = lAltDown() or rAltDown()

proc winDown*(self: wEvent): bool {.validate, inline.} =
  ## Returns true if any win key is pressed.
  result = lWinDown() or rWinDown()

proc leftDown*(self: wEvent): bool {.validate, inline.} =
  ## Returns true if the left mouse button is currently down.
  result = mKeyStatus[wKeyLButton] < 0

proc rightDown*(self: wEvent): bool {.validate, inline.} =
  ## Returns true if the right mouse button is currently down.
  result = mKeyStatus[wKeyRButton] < 0

proc middleDown*(self: wEvent): bool {.validate, inline.} =
  ##  Returns true if the middle mouse button is currently down.
  result = mKeyStatus[wKeyMButton] < 0

proc getKeyStatus*(self: wEvent): array[256, bool] {.validate, property, inline.} =
  ## Return an bool array with all the pressed keys.
  ## Using const defined in wKeyCodes.nim as the index.
  ## For example:
  ##
  ## .. code-block:: Nim
  ##   echo event.keyStauts[wKeyCtrl]
  for key, val in mKeyStatus:
    result[key] = val < 0

method getIndex*(self: wEvent): int {.base, property.} = discard
  ## Method needs to be overridden.
method getPosition*(self: wEvent): wPoint {.base, property.} = discard
  ## Method needs to be overridden.
method getKeyCode*(self: wEvent): int {.base, property.} = discard
  ## Method needs to be overridden.
method getSize*(self: wEvent): wSize {.base, property.} = discard
  ## Method needs to be overridden.
method setPosition*(self: wEvent, x: int, y: int) {.base, property.} = discard
  ## Method needs to be overridden.
method setPosition*(self: wEvent, pos: wPoint) {.base, property.} = discard
  ## Method needs to be overridden.
method getOrientation*(self: wEvent): int {.base, property.} = discard
  ## Method needs to be overridden.
method getScrollPos*(self: wEvent): int {.base, property.} = discard
  ## Method needs to be overridden.
method getKind*(self: wEvent): int {.base, property.} = discard
  ## Method needs to be overridden.
method getWheelRotation*(self: wEvent): int {.base, property.} = discard
  ## Method needs to be overridden.
method getSpinPos*(self: wEvent): int {.base, property.} = discard
  ## Method needs to be overridden.
method setSpinPos*(self: wEvent, pos: int) {.base, property.} = discard
  ## Method needs to be overridden.
method getSpinDelta*(self: wEvent): int {.base, property.} = discard
  ## Method needs to be overridden.
method setSpinDelta*(self: wEvent, delta: int) {.base, property.} = discard
  ## Method needs to be overridden.
method getUrl*(self: wEvent): string {.base, property.} = discard
  ## Method needs to be overridden.
method getLinkId*(self: wEvent): string {.base, property.} = discard
  ## Method needs to be overridden.
method getVisited*(self: wEvent): bool {.base, property.} = discard
  ## Method needs to be overridden.
method getCursor*(self: wEvent): wCursor {.base, property.} = discard
  ## Method needs to be overridden.
method setCursor*(self: wEvent, cursor: wCursor) {.base, property.} = discard
  ## Method needs to be overridden.
method getColumn*(self: wEvent): int {.base, property.} = discard
  ## Method needs to be overridden.
method getText*(self: wEvent): string {.base, property.} = discard
  ## Method needs to be overridden.
method getItem*(self: wEvent): wTreeItem {.base, property.} = discard
  ## Method needs to be overridden.
method getOldItem*(self: wEvent): wTreeItem {.base, property.} = discard
  ## Method needs to be overridden.
method getInsertMark*(self: wEvent): int {.base, property.} = discard
  ## Method needs to be overridden.
method getPoint*(self: wEvent): wPoint {.base, property.} = discard
  ## Method needs to be overridden.
method getDataObject*(self: wEvent): wDataObject {.base, property.} = discard
  ## Method needs to be overridden.
method getEffect*(self: wEvent): int {.base, property.} = discard
  ## Method needs to be overridden.
method setEffect*(self: wEvent, effect: int) {.base, property.} = discard
  ## Method needs to be overridden.
method getValue*(self: wEvent): int {.base, property.} = discard
  ## Method needs to be overridden.
method setValue*(self: wEvent, value: int) {.base, property.} = discard
  ## Method needs to be overridden.