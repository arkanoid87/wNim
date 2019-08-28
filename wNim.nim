#====================================================================
#
#               wNim - Nim's Windows GUI Framework
#                (c) Copyright 2017-2019 Ward
#
#====================================================================

##  wNim is Nim's Windows GUI framework.
##
##  Reference
##  =========
##
##  Basic Elements
##  --------------
##  - `wTypes <wTypes.html>`_
##  - `wApp <wApp.html>`_
##  - `wImage <wImage.html>`_
##  - `wImageList <wImageList.html>`_
##  - `wIconImage <wIconImage.html>`_
##  - `wResizer <wResizer.html>`_
##  - `wResizable <wResizable.html>`_
##  - `wAcceleratorTable <wAcceleratorTable.html>`_
##  - `wDataObject <wDataObject.html>`_
##  - `wPrintData <wPrintData.html>`_
##  - `wUtils <wUtils.html>`_
##
##  Windows
##  -------
##  - `wWindow <wWindow.html>`_
##  - `wPanel <wPanel.html>`_
##  - `wFrame <wFrame.html>`_
##
##  Menus
##  -----
##  - `wMenuBar <wMenuBar.html>`_
##  - `wMenu <wMenu.html>`_
##  - `wMenuItem <wMenuItem.html>`_
##  - `wMenuBase <wMenuBase.html>`_
##
##  GUI Controls
##  ------------
##  - `wControl <wControl.html>`_
##  - `wStatusBar <wStatusBar.html>`_
##  - `wToolBar <wToolBar.html>`_
##  - `wButton <wButton.html>`_
##  - `wCheckBox <wCheckBox.html>`_
##  - `wRadioButton <wRadioButton.html>`_
##  - `wStaticBox <wStaticBox.html>`_
##  - `wTextCtrl <wTextCtrl.html>`_
##  - `wListBox <wListBox.html>`_
##  - `wComboBox <wComboBox.html>`_
##  - `wCheckComboBox <wCheckComboBox.html>`_
##  - `wStaticText <wStaticText.html>`_
##  - `wStaticBitmap <wStaticBitmap.html>`_
##  - `wStaticLine <wStaticLine.html>`_
##  - `wNoteBook <wNoteBook.html>`_
##  - `wSpinCtrl <wSpinCtrl.html>`_
##  - `wSpinButton <wSpinButton.html>`_
##  - `wSlider <wSlider.html>`_
##  - `wScrollBar <wScrollBar.html>`_
##  - `wGauge <wGauge.html>`_
##  - `wCalendarCtrl <wCalendarCtrl.html>`_
##  - `wDatePickerCtrl <wDatePickerCtrl.html>`_
##  - `wTimePickerCtrl <wTimePickerCtrl.html>`_
##  - `wListCtrl <wListCtrl.html>`_
##  - `wTreeCtrl <wTreeCtrl.html>`_
##  - `wHyperlinkCtrl <wHyperlinkCtrl.html>`_
##  - `wSplitter <wSplitter.html>`_
##  - `wIpCtrl <wIpCtrl.html>`_
##  - `wWebView <wWebView.html>`_
##  - `wHotkeyCtrl <wHotkeyCtrl.html>`_
##  - `wRebar <wRebar.html>`_  (experimental)
##
##  Device Contexts
##  ---------------
##  - `wDC <wDC.html>`_
##  - `wMemoryDC <wMemoryDC.html>`_
##  - `wClientDC <wClientDC.html>`_
##  - `wWindowDC <wWindowDC.html>`_
##  - `wScreenDC <wScreenDC.html>`_
##  - `wPaintDC <wPaintDC.html>`_
##  - `wPrinterDC <wPrinterDC.html>`_
##
##  GDI Objects
##  -----------
##  - `wGdiObject <wGdiObject.html>`_
##  - `wFont <wFont.html>`_
##  - `wPen <wPen.html>`_
##  - `wBrush <wBrush.html>`_
##  - `wBitmap <wBitmap.html>`_
##  - `wIcon <wIcon.html>`_
##  - `wCursor <wCursor.html>`_
##  - `wRegion <wRegion.html>`_
##  - `wPredefined <wPredefined.html>`_
##
##  Dialogs
##  -------
##  - `wDialog <wDialog.html>`_
##  - `wMessageDialog <wMessageDialog.html>`_
##  - `wDirDialog <wDirDialog.html>`_
##  - `wFileDialog <wFileDialog.html>`_
##  - `wColorDialog <wColorDialog.html>`_
##  - `wFontDialog <wFontDialog.html>`_
##  - `wTextEntryDialog <wTextEntryDialog.html>`_
##  - `wPasswordEntryDialog <wPasswordEntryDialog.html>`_
##  - `wFindReplaceDialog <wFindReplaceDialog.html>`_
##  - `wPageSetupDialog <wPageSetupDialog.html>`_
##  - `wPrintDialog <wPrintDialog.html>`_
##
##  Events
##  ------
##  - `wEvent <wEvent.html>`_
##  - `wMouseEvent <wMouseEvent.html>`_
##  - `wKeyEvent <wKeyEvent.html>`_
##  - `wSizeEvent <wSizeEvent.html>`_
##  - `wMoveEvent <wMoveEvent.html>`_
##  - `wContextMenuEvent <wContextMenuEvent.html>`_
##  - `wScrollWinEvent <wScrollWinEvent.html>`_
##  - `wTrayEvent <wTrayEvent.html>`_
##  - `wDragDropEvent <wDragDropEvent.html>`_
##  - `wNavigationEvent <wNavigationEvent.html>`_
##  - `wSetCursorEvent <wSetCursorEvent.html>`_
##  - `wStatusBarEvent <wStatusBarEvent.html>`_
##  - `wCommandEvent <wCommandEvent.html>`_
##  - `wScrollEvent <wScrollEvent.html>`_
##  - `wSpinEvent <wSpinEvent.html>`_
##  - `wHyperlinkEvent <wHyperlinkEvent.html>`_
##  - `wListEvent <wListEvent.html>`_
##  - `wTreeEvent <wTreeEvent.html>`_
##  - `wIpEvent <wIpEvent.html>`_
##  - `wWebViewEvent <wWebViewEvent.html>`_
##  - `wDialogEvent <wDialogEvent.html>`_
##
##  Constants
##  ---------
##  - `wKeyCodes <wKeyCodes.html>`_
##  - `wColors <wColors.html>`_
##
##  Autolayout
##  ----------
##  - `autolayout <autolayout.html>`_

{.experimental, deadCodeElim: on.}

import
  tables, lists, math, strutils, dynlib, hashes, macros, times, sets, net,
  winim/[winstr, utils], wNim/autolayout, winim/inc/windef, wNim/private/wWinimx,
  wNim/private/kiwi/[variable, constraint, term, expression, symbolics,
  solver, strength]
  # winim/inc/[winbase, winerror, winuser, wingdi, commctrl, commdlg,
  #   objbase, shellapi, gdiplus, richedit, uxtheme, mshtml]

export
  winstr, utils, autolayout, variable, constraint, term, expression, symbolics,
  solver, strength

include
  wNim/private/wSymbolics,
  wNim/private/wMacro,
  wNim/private/wTypes,
  wNim/private/consts/wKeyCodes,
  wNim/private/consts/wColors,
  wNim/private/wHelper,
  wNim/private/wAcceleratorTable,
  wNim/private/wApp,
  wNim/private/wUtils,
  wNim/private/events/wEvent,
  wNim/private/events/wMouseEvent,
  wNim/private/events/wKeyEvent,
  wNim/private/events/wSizeEvent,
  wNim/private/events/wMoveEvent,
  wNim/private/events/wContextMenuEvent,
  wNim/private/events/wScrollWinEvent,
  wNim/private/events/wTrayEvent,
  wNim/private/events/wNavigationEvent,
  wNim/private/events/wSetCursorEvent,
  wNim/private/events/wStatusBarEvent,
  wNim/private/events/wCommandEvent,
  wNim/private/events/wScrollEvent,
  wNim/private/events/wSpinEvent,
  wNim/private/events/wHyperlinkEvent,
  wNim/private/events/wIpEvent,
  wNim/private/events/wListEvent,
  wNim/private/events/wTreeEvent,
  wNim/private/events/wDragDropEvent,
  wNim/private/events/wDialogEvent,
  wNim/private/events/wWebViewEvent,
  wNim/private/wIconImage,
  wNim/private/wImage,
  wNim/private/gdiobjects/wGdiObject,
  wNim/private/gdiobjects/wFont,
  wNim/private/gdiobjects/wPen,
  wNim/private/gdiobjects/wBrush,
  wNim/private/gdiobjects/wBitmap,
  wNim/private/gdiobjects/wIcon,
  wNim/private/gdiobjects/wCursor,
  wNim/private/gdiobjects/wRegion,
  wNim/private/gdiobjects/wPredefined,
  wNim/private/wImageList,
  wNim/private/wDataObject,
  wNim/private/wPrintData,
  wNim/private/wResizer,
  wNim/private/wResizable,
  wNim/private/wWindow,
  wNim/private/wPanel,
  wNim/private/dc/wDC,
  wNim/private/dc/wMemoryDC,
  wNim/private/dc/wClientDC,
  wNim/private/dc/wWindowDC,
  wNim/private/dc/wScreenDC,
  wNim/private/dc/wPaintDC,
  wNim/private/dc/wPrinterDC,
  wNim/private/dc/hotfix,
  wNim/private/menu/wMenuBar,
  wNim/private/menu/wMenu,
  wNim/private/menu/wMenuItem,
  wNim/private/menu/wMenuBase,
  wNim/private/controls/wControl,
  wNim/private/controls/wStatusBar,
  wNim/private/controls/wToolBar,
  wNim/private/controls/wRebar,
  wNim/private/controls/wButton,
  wNim/private/controls/wCheckBox,
  wNim/private/controls/wRadioButton,
  wNim/private/controls/wStaticBox,
  wNim/private/controls/wTextCtrl,
  wNim/private/controls/wListBox,
  wNim/private/controls/wComboBox,
  wNim/private/controls/wCheckComboBox,
  wNim/private/controls/wStaticText,
  wNim/private/controls/wStaticBitmap,
  wNim/private/controls/wStaticLine,
  wNim/private/controls/wNoteBook,
  wNim/private/controls/wSpinCtrl,
  wNim/private/controls/wSpinButton,
  wNim/private/controls/wSlider,
  wNim/private/controls/wScrollBar,
  wNim/private/controls/wGauge,
  wNim/private/controls/wCalendarCtrl,
  wNim/private/controls/wDatePickerCtrl,
  wNim/private/controls/wTimePickerCtrl,
  wNim/private/controls/wListCtrl,
  wNim/private/controls/wTreeCtrl,
  wNim/private/controls/wHyperlinkCtrl,
  wNim/private/controls/wSplitter,
  wNim/private/controls/wIpCtrl,
  wNim/private/controls/wWebView,
  wNim/private/controls/wHotkeyCtrl,
  wNim/private/wFrame,
  wNim/private/dialogs/wDialog,
  wNim/private/dialogs/wMessageDialog,
  wNim/private/dialogs/wDirDialog,
  wNim/private/dialogs/wFileDialog,
  wNim/private/dialogs/wColorDialog,
  wNim/private/dialogs/wFontDialog,
  wNim/private/dialogs/wTextEntryDialog,
  wNim/private/dialogs/wPasswordEntryDialog,
  wNim/private/dialogs/wFindReplaceDialog,
  wNim/private/dialogs/wPageSetupDialog,
  wNim/private/dialogs/wPrintDialog
